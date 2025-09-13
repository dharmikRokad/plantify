# Evergreen - Plant Identifier App Architecture

## Overview
A Flutter plant identification app using BLoC pattern with clean architecture, Google Gemini AI, Firebase authentication, and local storage for scan history.

## Core Features
1. **Plant Identification**: Camera capture + Google Gemini AI analysis
2. **Firebase Authentication**: Email/password login and registration
3. **Local Storage**: JSON-based scan history mimicking API calls
4. **Favorites System**: Mark scans as favorites
5. **History Management**: View and manage past scans
6. **Settings**: Theme switching and about section

## Clean Architecture Layers

### 1. Domain Layer (Core Business Logic)
- **Entities**: PlantScan, User, AppSettings
- **Use Cases**: IdentifyPlant, SaveScan, GetHistory, ToggleFavorite, AuthenticateUser
- **Repositories**: Abstract interfaces for data access

### 2. Data Layer (External Data Sources)
- **Models**: Data transfer objects with JSON serialization
- **Repositories**: Concrete implementations
- **Data Sources**: Local storage, Firebase Auth, Gemini AI service

### 3. Presentation Layer (UI & State Management)
- **BLoC**: AuthBloc, PlantIdentificationBloc, HistoryBloc, SettingsBloc
- **Screens**: Login, Home, Camera, Results, History, Settings
- **Widgets**: Reusable UI components

## Technical Implementation Plan

### Phase 1: Core Architecture Setup
1. Set up clean architecture folder structure
2. Install required dependencies (BLoC, Firebase, camera, shared_preferences, etc.)
3. Create domain entities and use cases
4. Implement local JSON storage system

### Phase 2: Authentication System
1. Set up Firebase authentication
2. Create auth repository and data sources
3. Implement AuthBloc for state management
4. Build login/register screens with validation

### Phase 3: Plant Identification Core
1. Integrate camera functionality
2. Set up Google Gemini AI service
3. Create plant identification repository
4. Implement PlantIdentificationBloc
5. Build camera capture and results screens

### Phase 4: History & Favorites
1. Implement local JSON storage for scans
2. Create history repository with CRUD operations
3. Build HistoryBloc for state management
4. Develop history listing and detail screens
5. Add favorites toggle functionality

### Phase 5: Settings & Theme
1. Create settings repository for preferences
2. Implement SettingsBloc for theme management
3. Build settings screen with theme switcher
4. Add about app section

### Phase 6: Integration & Testing
1. Connect all features through main navigation
2. Add error handling and loading states
3. Test complete user flows
4. Fix any compilation issues

## File Structure
```
lib/
├── main.dart
├── theme.dart
├── core/
│   ├── errors/
│   ├── usecases/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── plant_identification/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── history/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   └── settings/
│       ├── domain/
│       ├── data/
│       └── presentation/
└── shared/
    ├── widgets/
    └── navigation/
```

## Key Dependencies
- flutter_bloc: State management
- firebase_auth: Authentication
- camera: Image capture
- image_picker: Gallery selection
- shared_preferences: Local storage
- http: API calls to Gemini
- json_annotation: JSON serialization

## Sample Data
The app will include realistic sample plant scans to demonstrate functionality, including common houseplants, flowers, and trees with detailed identification information.