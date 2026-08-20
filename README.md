# Qanomy Mobile App

Qanomy is a modern, enterprise-grade Flutter application designed for Pakistan's legal ecosystem, providing a calm, organized, and responsive experience for lawyers.

## Features

- **Global Responsiveness**: The app is built with mobile-first principles and scales seamlessly from 360px phones up to large desktop/tablet displays.
- **Adaptive Layouts**: 
  - Centralized constraints (`ResponsiveConstraints`) to prevent text and cards from stretching awkwardly on ultra-wide screens.
  - Automatically switches between `NavigationBar` (bottom tabs) on mobile and `NavigationRail` (side tabs) on tablets.
- **Enterprise-grade UI**: Clean white space, strong typography hierarchy (`Inter` and `Crimson Text`), and strict design tokens.

## Getting Started

1. Ensure you have the latest stable Flutter SDK installed.
2. Run `flutter pub get`.
3. Run `flutter run`.

## Responsiveness Guidelines

When adding new screens to the Qanomy app, adhere to these rules:
1. **Never use fixed dimensions** for width or height unless absolutely necessary.
2. Use `MediaQuery.sizeOf(context)` or `LayoutBuilder` for proportional scaling.
3. Wrap main content areas in `Center` > `ConstrainedBox` with `ResponsiveConstraints.maxContentWidth` on tablets.
4. Respect `SafeArea`.
