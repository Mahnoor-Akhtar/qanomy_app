# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **Global Responsive Utilities**: Introduced `lib/core/utils/responsive.dart` with `Responsive` and `ResponsiveConstraints` classes.
- **Tablet Layouts**: `MainLayout` now seamlessly transitions to a `NavigationRail` when rendered on a tablet or desktop size display.

### Changed
- **Dashboard Layout**: Wrapped `DashboardScreen` in `ConstrainedBox` to restrict maximum width on tablets, maintaining readability and preventing UI stretching.
- **Buttons**: Wrapped `PrimaryButton` and `SecondaryButton` in a `Center` and `ConstrainedBox` to enforce a maximum width of `400.0` on wide screens.
- **Splash Screen Graphics**: Removed hardcoded `120.0` height/width values from `QanomyAnimatedLogo` and `CourtlineIllustration`. Both components now scale proportionally based on `MediaQuery.sizeOf(context)`.

### Fixed
- **Responsiveness**: Audited existing UI components to guarantee zero RenderFlex overflow errors across 360px, 390px, 430px, tablet portrait, and tablet landscape form factors.
