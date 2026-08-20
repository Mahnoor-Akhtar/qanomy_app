# Qanomy Mobile App

Qanomy is a modern, enterprise-grade Flutter application designed for Pakistan's legal ecosystem, providing a calm, organized, and responsive case management experience for lawyers.

---

## 1. Product Overview

The product maintains a professional, minimalistic, modern, clean, and trustworthy legal-tech focused design language. 

**Core Aesthetics:**
* Deep Navy and White themes.
* Qanomy Orange accent.
* Subtle blue/pastel supporting colors.
* Rounded cards with drop shadows.
* Clean, generous spacing and minimal visual noise.

---

## 2. Navigation Architecture

### Mobile Navigation
The primary mobile bottom navigation consists of:
1. Home
2. Cases
3. Hearings
4. Teams

### Desktop Navigation
The desktop/web application utilizes a sidebar-based navigation system covering major modules:
* Dashboard
* Cases
* Hearings & Calendar
* Clients
* Documents
* Invoices & Billing
* Team
* Tasks
* Reports
* Notifications
* Settings

---

## 3. Module Documentation

### Dashboard
The dashboard serves as the main overview screen.
* **Header**: Contains date, greeting, search, notifications, and user/profile access (using a cute cat avatar).
* **Summary Statistics**: Shows Today, Tomorrow, Running, Awaited, Decided, Abandoned.
* **Daily Board & Quick Actions**: Add Case, Search, Calendar, Clients, Advocates, Tasks, Reminders.

### Cases
The Cases module is intentionally minimal on mobile, prioritizing case titles and assigned lawyers.
* **Case List**: Displays case summary cards. Entire card is clickable.
* **Case Details Screen**: Features a premium dark navy app bar without breadcrumbs, a responsive grid for case specifics, tabbed navigation, and an activity timeline.

### Clients
Designed with a mobile-first presentation.
* **Client Screen**: List of clients utilizing expandable sections and detail pages. Uses the global circular avatar for clients.

### Teams
Comprehensive module for managing firm members.
* **Team Members Screen**: A clean, simplified list displaying numerical ID, avatar, Name, and Role. Contains a top filter bar with search and dropdowns. Includes a top-right `+` icon button to add new members.
* **Add Team Member Screen**: A professional form featuring a responsive 2-column layout, customized Phone input with country code dropdown, a blue Information Alert Box, and a detailed responsive grid for Portal Permissions checkboxes.
* **Team Member Details Screen**: A beautiful card-based screen showing the selected member's avatar, role badge, email, phone, ACTIVE status in pink, joined date, and action buttons for "Edit Role" and "Delete".

---

## 4. Architecture & Technical Details

* **Framework**: Flutter (SDK: ^3.12.2)
* **Language**: Dart
* **State Management**: `To be documented` (Currently primarily internal `setState` / simple state passing)
* **Routing**: Standard `MaterialPageRoute` and `Navigator` logic.
* **Theme System**: Custom defined in `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`.

### Project Structure
```text
lib/
├── core/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── cases/
│   ├── clients/
│   ├── dashboard/
│   ├── navigation/
│   ├── splash/
│   └── team/
│
└── main.dart
```

### Design System
* **Colors**: 
  * Primary: Deep Navy (`AppColors.primaryNavy`)
  * Background: Page Background (`AppColors.pageBackground`)
  * Success/Active: Green (`#00A980`)
  * Highlight/Alert: Pink (`#E91E63`)
* **Components**: `QanomyCard`, specialized `Responsive` builders, customized `TextFields` and `Dropdowns`.
* **Typography**: `Inter` font for UI elements, `Crimson Text` for serif headers.

---

## 5. Responsive Design

* **Mobile**: Uses `CustomBottomAppBar` for bottom navigation. Forms stack in a single column.
* **Tablet/Desktop**: Uses `QanomySidebar` for side navigation. Forms dynamically wrap into multiple columns using `Responsive` utility or `Wrap` properties. 
* Uses centralized `ResponsiveConstraints` to prevent awkward stretching on ultra-wide screens.

---

## 6. Dependencies

* `cupertino_icons`: Core iOS style icons.
* `google_fonts`: For `Inter` and `Crimson Text` typography.
* `flutter_animate`: For micro-animations and smooth transitions.

---

## 7. Versioning

`Versioning: Not yet defined`

---

## 8. Product Decisions

| Date | Decision | Reason |
|------|----------|-------|
| 2026-08-20 | Simplified Team Members list to only show ID, Avatar/Name, and Role. | Reduces visual clutter and focuses on clickability for details. |
| 2026-08-20 | Removed Breadcrumbs from Case Details AppBar. | Provides a cleaner, more premium look matching the dark theme. |
| 2026-08-20 | Global usage of circular image avatars. | Standardized the user representation UI across Sidebar, Teams, and Clients. |
| 2026-08-20 | Replaced 'Add New Member' text button with a simple `+` icon button. | Saves space and maintains minimalism. |

---

## 9. Changelog

### 2026-08-20

#### Added
- `AddTeamMemberScreen` with responsive form and portal permissions checklist.
- `TeamMemberDetailsScreen` with a styled card showcasing member details and action buttons.
- Default cat avatar image asset for all users across the app.

#### Changed
- Restructured `TeamMembersScreen` from a `DataTable` to a clean `ListView.separated`.
- Updated `qanomy_sidebar.dart`, `clients_screen.dart`, and `dashboard_header.dart` to use image-based `CircleAvatars`.
- Refactored `case_details_screen.dart` AppBar to be cleaner without breadcrumbs.
- Changed "Add New Member" button to a minimalistic `+` icon.
- Replaced the App Bar 'Add' buttons on the Cases, Clients, and Team screens with global rounded orange Floating Action Buttons.

#### Removed
- Removed "Export" and "View Toggle" buttons from the Teams Screen.
- Removed unused columns from the Teams data table.

---

## 10. Future Improvements

- [ ] Complete Backend/API integration.
- [ ] Populate placeholder screens (Hearings, Documents, Invoices).
- [ ] Advanced case filtering and sorting.
- [ ] State management architecture standardization.
