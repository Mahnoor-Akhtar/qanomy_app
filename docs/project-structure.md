# Project Structure

The Qanomy mobile app uses a feature-based architectural pattern to ensure scalability and maintainability.

```text
lib/
├── core/                   # Shared utilities, themes, and global widgets
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_radius.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart
│   │   └── app_typography.dart
│   ├── utils/
│   │   └── responsive.dart # Handles breakpoints & global constraints
│   └── widgets/
│       ├── primary_button.dart
│       ├── secondary_button.dart
│       └── qanomy_card.dart
│
├── features/               # Independent feature modules
│   ├── dashboard/          # Main dashboard views
│   │   └── screens/
│   │       └── dashboard_screen.dart
│   ├── navigation/         # App-wide routing and navigation shells
│   │   └── main_layout.dart
│   └── splash/             # Splash screen and loader
│       ├── screens/
│       │   └── splash_screen.dart
│       └── widgets/
│           ├── courtline_illustration.dart
│           ├── minimal_loader.dart
│           └── qanomy_animated_logo.dart
│
└── main.dart               # Application entry point
```

## Responsive Pattern

All new features should utilize `lib/core/utils/responsive.dart` to determine device type (`isMobile`, `isTablet`, `isDesktop`) and apply layout transformations dynamically. Fixed heights and widths should be avoided in feature widgets.
