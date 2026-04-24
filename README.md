# Fruits Hub

## Demo Video

[![Watch the project walkthrough](https://img.youtube.com/vi/IGN0yAw0GXo/maxresdefault.jpg)](https://youtu.be/IGN0yAw0GXo?si=BIA_u9XmlOxp5J0u)

[Watch the project walkthrough on YouTube](https://youtu.be/IGN0yAw0GXo?si=BIA_u9XmlOxp5J0u)

`Fruits_Hub` is the customer-facing Flutter application in a connected e-commerce ecosystem that also includes `Fruits_Hub_Dashboard` for admin operations. The mobile app handles catalog browsing, cart management, checkout, orders, and customer notifications, while the dashboard manages products, order operations, notifications, and product visibility.

## Quick Links

- APK: [Download the latest build](https://drive.google.com/file/d/1C7XYxYFcSsBtmUYZeLfUFS2CN92RUaP0/view)
- Course reference: [Firebase course by Eng. Tharwat Samy](https://www.udemy.com/share/10b5Bg3@o34JzGTwgGxceYhhkU0ehG4gtRlyS_pCFpZqPTpZkXIrqvJbFjPwajs47z0I7Y-HAQ==/)

## Project Background

This version of Fruits Hub was built on top of material originally taught by Eng. Tharwat Samy in his Firebase course, then extended with practical changes to make the app closer to a production-style grocery commerce flow and more aligned with current market expectations.

The repository does not present the app as an original greenfield idea. Instead, it documents the implementation work, structural updates, and product-level changes added on top of that learning foundation.

## Overview

Fruits Hub is implemented as a two-app business system:

- `Fruits_Hub` is the shopper application.
- `Fruits_Hub_Dashboard` is the admin and operations dashboard.
- Both apps share the same commerce data flow around `products`, `orders`, `notifications`, `user_devices`, and `user_carts`.
- Push delivery is handled through Firebase Cloud Messaging and the shared Supabase edge function `send-push-notification`.

This repository is the main customer app entry point, but it is tightly connected to the dashboard project through the same backend and operational workflow.

## Customer App Features

- Onboarding flow with persisted completion state
- Splash bootstrap with onboarding, cached user, and restored session checks
- Email and password authentication
- Google sign-in and Facebook sign-in
- Product browsing with search and client-side sorting
- Best-selling products section powered by `selling_count`
- Product details with quantity selection and add-to-cart actions
- Cart persistence with local storage and signed-in sync through `user_carts`
- Multi-step checkout flow
- Cash on delivery and Paymob card payment flow
- Order creation and order history
- Realtime notifications with mark-as-read support
- Push token registration in `user_devices`
- Push navigation into notifications and orders
- Basic offline and connectivity-aware handling

## Connected Dashboard Features

The connected `Fruits_Hub_Dashboard` project is responsible for the admin side of the same ecosystem:

- Product creation and editing
- Product image upload to Supabase Storage
- Product deletion
- Product visibility control through `is_visible`
- Realtime order monitoring
- Order status updates
- Manual and automatic notification sending
- Admin push handling and navigation

## Product Visibility

Product visibility is implemented as a real cross-project feature:

- The dashboard writes and updates `is_visible` in `products`.
- The dashboard UI exposes a visibility toggle for end users.
- The customer app already maps `is_visible` in the product model and entity layer.

Current note: the customer repository supports `is_visible` at the model level, but the active `ProductsRepoImpl` query path does not explicitly add an `is_visible` filter in the catalog read. That means hidden-product enforcement currently depends on backend-side filtering, RLS rules, or a follow-up customer-side query update.

## Tech Stack

- Flutter
- Dart
- Flutter Bloc / Cubit
- GetIt
- Supabase
- Firebase Core
- Firebase Authentication
- Firebase Cloud Messaging
- Google Sign-In
- Facebook Login
- SharedPreferences
- Connectivity Plus
- Paymob through the local `packages/pay_with_paymob` package

## Architecture

The customer app uses a hybrid feature-first structure with shared core services and repository boundaries:

- `lib/core/` contains common services, repositories, models, utilities, connectivity handling, and reusable widgets.
- Feature modules under `lib/features/` contain their own UI, data, and state management pieces.
- UI state is primarily managed with Cubits.
- Repository implementations coordinate data access between presentation logic and backend services.
- Checkout and order creation are split into Cubits, use cases, repositories, and notification services.
- Notifications combine Supabase realtime listeners with push-token registration and navigation handling.

The structure is practical and production-oriented, although the codebase still contains some legacy naming duplication such as `manager` / `manger` and `entities` / `entites`.

## Project Structure

```text
lib/
|-- app/
|-- core/
|   |-- config/
|   |-- connectivity/
|   |-- entities/
|   |-- errors/
|   |-- helper_fun/
|   |-- models/
|   |-- products_cubit/
|   |-- repos/
|   |   |-- order_repo/
|   |   `-- products_repo/
|   |-- services/
|   |-- utils/
|   `-- widgets/
|-- features/
|   |-- admin/
|   |   `-- orders/
|   |-- auth/
|   |-- best_selling/
|   |-- checkout/
|   |-- home/
|   |-- notifications/
|   |-- on_boarding/
|   |-- product_details/
|   `-- splash/
|-- generated/
`-- l10n/

packages/
`-- pay_with_paymob/
```

### Folder Highlights

- `lib/main.dart`: app bootstrap, service initialization, and startup wiring
- `lib/app/fruit_hub.dart`: app shell, localization, routing, and connection bootstrap
- `lib/core/services/get_it_services.dart`: dependency injection registration
- `lib/core/repos/products_repo/products_repo_impl.dart`: catalog reads from Supabase
- `lib/core/repos/order_repo/order_repo_impl.dart`: order creation and order retrieval
- `lib/features/home/data/repos/cart_repository_impl.dart`: local and remote cart sync
- `lib/features/checkout/data/services/order_creation_notifications_service.dart`: order-created notification flow
- `lib/features/notifications/data/services/notifications_service.dart`: realtime customer notifications

## Ecosystem Flow

```text
Dashboard -> create / edit / hide products -> Customer app catalog
Customer app -> cart / checkout / create order -> orders
Customer app -> create admin notification -> Dashboard alerts
Dashboard -> update order status -> customer notifications
Both apps -> register device tokens -> send-push-notification -> FCM delivery
```

## Data Flow

- Catalog: `UI -> ProductsCubit -> ProductsRepoImpl -> SupabaseService -> products`
- Authentication: `UI -> SigninCubit / SignupCubit -> AuthRepoImpl -> FirebaseAuthService + users table + CurrentUserService`
- Cart: `UI -> CartCubit -> CartRepositoryImpl -> local source + remote source -> user_carts`
- Checkout: `UI -> CheckoutCubit / AddOrderCubit -> AddOrderUseCase -> OrderRepoImpl -> orders`
- Order notifications: `AddOrderUseCase -> OrderCreationNotificationsService -> notifications + push dispatch`
- Customer notifications: `UI -> NotificationsCubit -> NotificationsService -> notifications realtime stream`

## Backend And Integrations

### Supabase

- `products`
- `orders`
- `notifications`
- `user_devices`
- `user_carts`
- Storage bucket: `product-images`
- Edge function: `send-push-notification`

### Firebase

- App initialization
- Firebase Authentication
- Firebase Cloud Messaging for push delivery and device registration

### Payments

- Paymob integration through the local package under `packages/pay_with_paymob`

## Getting Started

```bash
git clone <your-repository-url>
cd fruit_hub
flutter pub get
```

Create local runtime configuration:

```powershell
Copy-Item dart_defines.example.json dart_defines.json
```

Run the app:

```powershell
flutter run --dart-define-from-file=dart_defines.json
```

Build release APK:

```powershell
flutter build apk --release --dart-define-from-file=dart_defines.json
```

Optional Android Facebook setup:

```powershell
Copy-Item android/secrets.properties.example android/secrets.properties
```

## Environment Configuration

From `dart_defines.example.json`:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `PAYMOB_API_KEY`
- `PAYMOB_IFRAME_ID`
- `PAYMOB_INTEGRATION_CARD_ID`
- `PAYMOB_INTEGRATION_MOBILE_WALLET_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_WEB_API_KEY`
- `FIREBASE_WEB_APP_ID`
- `FIREBASE_WEB_MESSAGING_SENDER_ID`
- `FIREBASE_WEB_AUTH_DOMAIN`
- `FIREBASE_WEB_MEASUREMENT_ID`
- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_ANDROID_APP_ID`
- `FIREBASE_ANDROID_MESSAGING_SENDER_ID`
- `FIREBASE_IOS_API_KEY`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_IOS_MESSAGING_SENDER_ID`
- `FIREBASE_IOS_BUNDLE_ID`
- `FIREBASE_WINDOWS_API_KEY`
- `FIREBASE_WINDOWS_APP_ID`
- `FIREBASE_WINDOWS_MESSAGING_SENDER_ID`
- `FIREBASE_WINDOWS_MEASUREMENT_ID`

From `android/secrets.properties`:

- `FACEBOOK_APP_ID`
- `FACEBOOK_CLIENT_TOKEN`
- `FACEBOOK_LOGIN_PROTOCOL_SCHEME`

## Notes

- Native Firebase platform configuration files are not committed in the repository, so local setup is still required.
- Arabic is the default locale in the current app bootstrap.
- The customer app and dashboard are designed to work together, but the admin authentication layer belongs to the dashboard project, not this repository.

## Acknowledgement

This project is based on learning material by Eng. Tharwat Samy and then extended with additional implementation work, integration changes, and product adjustments in this repository.
