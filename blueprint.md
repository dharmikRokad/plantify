# Plant Identifier App Blueprint

## Overview

This document outlines the architecture, features, and design of the Plant Identifier mobile application. The app allows users to identify plants by taking a photo or selecting an image from their gallery, view their scan history, and manage their favorite plants.

## Features

*   **Plant Identification:**
    *   Users can take a photo of a plant using their device's camera.
    *   Users can select an image of a plant from their photo gallery.
    *   The app uses a machine learning model to identify the plant from the image.
    *   The identification results include the plant's common name, scientific name, description, care instructions, and other details.
*   **Scan History:**
    *   All plant scans are saved to the user's device.
    *   Users can view a list of their past scans.
    *   Each history item displays the plant's name, image, and the date of the scan.
*   **Favorites:**
    *   Users can mark scans as favorites.
    *   A separate view is available to see all favorite plants.
*   **Settings:**
    *   Users can clear their scan history.
    *   Users can manage app settings, such as enabling or disabling analytics.

## Architecture

The app follows the **Clean Architecture** principles, separating the code into three main layers:

*   **Presentation:** This layer is responsible for the UI and user interaction. It includes:
    *   **BLoC (Business Logic Component):** Manages the state of the UI and communicates with the domain layer.
    *   **Widgets:** The UI components that the user sees and interacts with.
*   **Domain:** This layer contains the core business logic of the application. It includes:
    *   **Use Cases:** Encapsulate specific business rules and orchestrate the flow of data between the presentation and data layers.
    *   **Entities:** Represent the core data models of the application.
    *   **Repositories:** Abstract the data sources and provide a clean API for the domain layer to access data.
*   **Data:** This layer is responsible for retrieving and storing data. It includes:
    *   **Repositories Impl:** The implementation of the repository interfaces defined in the domain layer.
    *   **Data Sources:** Communicate with local and remote data sources, such as a local database or a remote API.

## Current Implementation

### 1. **Project Setup and Core Dependencies**

*   Initialized a new Flutter project.
*   Added the following core dependencies:
    *   `flutter_bloc` for state management.
    *   `equatable` for value equality.
    *   `dartz` for functional programming (Either type).
    *   `get_it` and `injectable` for dependency injection.
    *   `shared_preferences` for local data storage.
    *   `image_picker` for accessing the device's camera and gallery.
    *   `camera` for building a custom camera interface.
    *   `provider` for dependency injection.

### 2. **Application Theme and Styling**

*   Created a modern and visually appealing theme using Material 3.
*   Defined a color scheme, typography, and component styles in a centralized `ThemeData` object.
*   Implemented support for both light and dark themes using the `provider` package.
*   Used `google_fonts` for custom typography.

### 3. **Navigation and Routing**

*   Set up named routes for the main screens of the application:
    *   `/` (Home)
    *   `/result` (Identification Result)
    *   `/history` (Scan History)
    *   `/settings` (Settings)
*   Implemented a bottom navigation bar for easy access to the main screens.

### 4. **Plant Identification Feature**

*   Created the UI for the home screen, which includes a welcome message and a "Scan Plant" button.
*   Implemented the `PlantIdentificationBloc` to manage the state of the plant identification feature.
*   Created the `PlantIdentificationRepository` and its implementation to handle the data flow for plant identification.
*   Created the `IdentifyPlant` use case to encapsulate the business logic for identifying a plant.
*   Integrated the `image_picker` package to allow users to select an image from their gallery.
*   Created a custom `CameraPage` to allow users to take a photo of a plant.
*   Created the `PlantRecognizer` class to simulate the plant identification process using a mock AI service.

### 5. **Refactoring and Code Organization**

*   Refactored the `main.dart` file to initialize the `ServiceLocator` and set up the `MultiBlocProvider`.
*   Organized the project structure into feature-based folders (e.g., `home`, `plant_identification`, `settings`).
*   Created a `lib/injection_container.dart` file to manage dependency injection.
*   Updated the codebase to use image bytes (`Uint8List`) instead of image paths for plant identification.

