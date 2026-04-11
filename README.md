# 🧊 Iceberg POS — Point of Sale for Ice Cream Houses

> A production-ready, offline-first Point of Sale and Admin dashboard built with Flutter for ice cream businesses.

---

## 📖 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Default Credentials](#default-credentials)
- [Navigation & Screens](#navigation--screens)
- [Build & Deploy](#build--deploy)
- [Troubleshooting](#troubleshooting)

---

## Overview

**Iceberg** is a multi-platform Point of Sale (POS) system designed for ice cream shops and similar food businesses. It runs on **tablets** (POS terminal), **desktops**, and the **web** (Admin dashboard), with a fully **offline-first** architecture powered by Hive CE.

All transactions are stored locally on-device, ensuring the system works even without an internet connection. Data can optionally sync to Firebase when connectivity is available.

---

## Features

### 🍦 POS Terminal
- **Product Grid** with category filtering (Ice Cream, Vessels, Toppings, Drinks, Other)
- **Modifier Modal** — select size, vessel type, and toppings per product
- **Shopping Cart** with quantity management and swipe-to-delete
- **Payment Dialog** — Cash (with change calculator & quick amounts), GCash, and Card
- **Receipt Dialog** — full order summary after checkout
- **Role-Based Access** — Cashiers see POS only; Admins see everything

### 📊 Admin Dashboard (5 Tabs)
1. **Overview** — 4 stat cards (Today's Sales, Total Orders, Avg Order, Top Product) + 3 interactive charts
2. **Products** — Full CRUD management with search, category filter, availability toggle
3. **Orders** — Complete order history with payment method & date range filters
4. **Staff** — Add/edit staff, assign roles (Admin/Cashier), toggle active status
5. **Settings** — Store name, tax rate, receipt header/footer customization

### 📈 Analytics Charts (powered by fl_chart)
- **Sales Line Chart** — 7-day revenue trend
- **Category Pie Chart** — Revenue by product category
- **Hourly Bar Chart** — Order volume by hour of day
- **Top Products** — Ranked by revenue

### ⏰ End-of-Day Clock-Out (Z-Reading)
- Automatic calculation of daily totals from actual order data
- Payment method breakdown (Cash, GCash, Card)
- **Cash declaration** with discrepancy detection (overage/shortage/balanced)
- Shift report saved to Hive for audit trail
- Automatic logout after submission

### 🔐 PIN-Based Authentication
- 4-digit PIN login with animated keypad
- Role-based routing guard (Admin vs Cashier)
- Shake animation on invalid PIN

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | Riverpod (with `riverpod_annotation`) |
| Routing | GoRouter (with authentication guards) |
| Offline Storage | Hive CE (offline-first, all data local) |
| Cloud (Optional) | Firebase (Firestore & Storage) |
| Charts | fl_chart |
| Typography | Google Fonts (Inter) |
| Code Generation | Freezed, json_serializable, build_runner |
| Models | Freezed for immutable data classes |

---

## Architecture

```
lib/
├── main.dart                          # App entry point
└── src/
    ├── core/
    │   ├── cache/
    │   │   └── hive_setup.dart        # Hive initialization & box registry
    │   ├── layout/
    │   │   └── responsive_layout.dart # Mobile/Tablet/Desktop breakpoints
    │   ├── sync/
    │   │   └── sync_controller.dart   # Offline queue → Cloud push
    │   └── theme/
    │       └── iceberg_theme.dart     # Design tokens, colors, typography
    ├── features/
    │   ├── admin/
    │   │   ├── application/
    │   │   │   └── admin_analytics_controller.dart
    │   │   └── presentation/
    │   │       ├── admin_dashboard_screen.dart
    │   │       └── widgets/
    │   │           ├── admin_overview_content.dart
    │   │           ├── category_pie_chart.dart
    │   │           ├── hourly_bar_chart.dart
    │   │           ├── order_detail_dialog.dart
    │   │           ├── order_history_content.dart
    │   │           ├── product_form_dialog.dart
    │   │           ├── product_management_content.dart
    │   │           ├── sales_line_chart.dart
    │   │           ├── settings_content.dart
    │   │           └── staff_management_content.dart
    │   ├── auth/
    │   │   ├── application/
    │   │   │   └── auth_controller.dart
    │   │   ├── data/
    │   │   │   └── staff_repository.dart
    │   │   ├── domain/
    │   │   │   └── staff_member.dart
    │   │   └── presentation/
    │   │       └── pin_login_screen.dart
    │   ├── orders/
    │   │   ├── application/
    │   │   │   └── cart_controller.dart
    │   │   ├── data/
    │   │   │   └── order_repository.dart
    │   │   └── domain/
    │   │       └── order.dart
    │   ├── pos/
    │   │   └── presentation/
    │   │       ├── clock_out_screen.dart
    │   │       ├── pos_screen.dart
    │   │       └── widgets/
    │   │           ├── modifier_modal.dart
    │   │           ├── payment_dialog.dart
    │   │           └── receipt_dialog.dart
    │   ├── products/
    │   │   ├── data/
    │   │   │   └── product_repository.dart
    │   │   └── domain/
    │   │       └── product.dart
    │   └── reports/
    │       ├── data/
    │       │   └── shift_report_repository.dart
    │       └── domain/
    │           └── shift_report.dart
    └── routing/
        └── app_router.dart            # GoRouter with auth guards
```

---

## Getting Started

### Prerequisites
- Flutter SDK (3.x or later)
- Dart SDK (3.x or later)
- A code editor (VS Code recommended)

### Install & Run

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd iceberg_app

# 2. Install dependencies
flutter pub get

# 3. Run code generation (REQUIRED before first run)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run -d chrome         # Web (Admin dashboard)
flutter run -d windows        # Windows desktop
flutter run -d <device-id>    # iOS/Android tablet
```

> **Important:** You MUST run `build_runner` before the first launch. This generates the `.g.dart` and `.freezed.dart` files required by Riverpod, Freezed, json_serializable, and Hive adapters.

---

## Default Credentials

The system comes pre-seeded with two staff accounts:

| Role | Name | PIN |
|------|------|-----|
| **Admin** | Admin User | `1234` |
| **Cashier** | Jane Doe | `5678` |

- **Admin** has access to both the POS terminal and the Admin Dashboard.
- **Cashier** can only access the POS terminal and Clock-Out screen.

You can add more staff from the Admin Dashboard → Staff tab.

---

## Navigation & Screens

| Route | Screen | Access |
|-------|--------|--------|
| `/login` | PIN Login | Public |
| `/pos` | POS Terminal | Admin, Cashier |
| `/admin` | Admin Dashboard | Admin only |
| `/clock-out` | End-of-Day Z-Reading | Admin, Cashier |

The app automatically redirects unauthenticated users to `/login` and prevents Cashiers from accessing `/admin`.

---

## Build & Deploy

### Web Build
```bash
flutter build web
```
Output is in `build/web/`. Deploy to any static hosting (Firebase Hosting, Vercel, Netlify).

### Windows Build
```bash
flutter build windows
```
Output is in `build/windows/x64/runner/Release/`.

### Android/iOS
```bash
flutter build apk   # Android
flutter build ios    # iOS
```

---

## Troubleshooting

### "Missing .g.dart files" errors
```bash
dart run build_runner build --delete-conflicting-outputs
```

### "Box not found" Hive errors
Make sure `setupHive()` is called in `main()` before `runApp()`. Check that all Hive boxes are registered in `hive_setup.dart`.

### Google Fonts not loading
Ensure you have internet connectivity on first launch. Google Fonts are cached after the first download. For fully offline deployments, you can bundle fonts in the `assets/` folder.

### "No products found" on POS
Products are seeded on first launch via `ProductRepository`. If the Hive box is cleared, products will re-seed automatically.

---

## License

This project is proprietary. All rights reserved.

---

**Built with ❤️ using Flutter & Riverpod**
