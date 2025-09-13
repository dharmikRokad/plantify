import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:myapp/features/plant_identification/presentation/bloc/plant_identification_bloc.dart';
import 'package:myapp/features/plant_identification/presentation/pages/plant_result_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PlantIdentificationBloc>().add(PlantHistoryRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant History'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showFavoritesOnly = !_showFavoritesOnly),
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: _showFavoritesOnly ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PlantIdentificationBloc, PlantIdentificationState>(
        builder: (context, state) {
          if (state is PlantHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is PlantHistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load history',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<PlantIdentificationBloc>()
                        .add(PlantHistoryRequested()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is PlantHistoryLoaded) {
            final scans = _showFavoritesOnly
                ? state.scans.where((scan) => scan.isFavorite).toList()
                : state.scans;
                
            if (scans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _showFavoritesOnly ? Icons.favorite_border : Icons.history,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _showFavoritesOnly ? 'No favorites yet' : 'No plant scans yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showFavoritesOnly 
                          ? 'Mark plants as favorites to see them here'
                          : 'Start scanning plants to build your collection',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PlantIdentificationBloc>().add(PlantHistoryRequested());
              },
              child: scans.isNotEmpty 
                ? ListView.builder(
                    key: const ValueKey('plant_history_list'),
                    padding: const EdgeInsets.all(16),
                    itemCount: scans.length,
                    itemBuilder: (context, index) {
                      if (index >= scans.length) return const SizedBox.shrink();
                      final scan = scans[index];
                      return _buildPlantCard(context, scan);
                    },
                  )
                : const SizedBox.shrink(),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, PlantScan scan) {
    return Card(
      key: ValueKey('plant_card_${scan.id}'),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlantResultPage(scan: scan),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Plant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(scan.imagePath),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.eco,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Plant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.plantName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scan.scientificName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(scan.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(scan.confidence * 100).toInt()}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              Column(
                children: [
                  IconButton(
                    onPressed: () => context.read<PlantIdentificationBloc>()
                        .add(PlantFavoriteToggled(scan.id)),
                    icon: Icon(
                      scan.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: scan.isFavorite ? Colors.red : null,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteDialog(context, scan),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PlantScan scan) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Plant Scan'),
        content: Text('Are you sure you want to delete "${scan.plantName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<PlantIdentificationBloc>()
                  .add(PlantScanDeleted(scan.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}