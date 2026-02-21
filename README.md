# 🛍️ Mini Shop Flutter App

A pixel-perfect Flutter app matching the provided Figma design, using **Cubit** state management.

## 📁 Project Structure

```
lib/
├── main.dart                          ← App entry + MultiBlocProvider
├── app_theme.dart                     ← Colors, TextStyles
├── models/
│   ├── product_model.dart             ← Product + CartItem models
│   └── local_products.dart            ← Local products with asset images
├── services/
│   └── product_service.dart           ← DummyJSON API calls
├── cubits/
│   ├── product_cubit.dart             ← Products state management
│   └── cart_cubit.dart                ← Cart state management
├── screens/
│   ├── home_screen.dart               ← Catalog/Home screen
│   └── cart_screen.dart               ← Cart screen
└── widgets/
    └── product_card.dart              ← Reusable product card

assets/
├── images/
│   ├── samsung_tv.png
│   ├── macbook_air.png
│   ├── watch.png
│   ├── soundcore_headphone.png
│   ├── honor_phone.png
│   └── jbl_speaker.png
└── icons/
    ├── logo.png
    └── arrow_left.png
```

## 🎯 Features

| Feature | Details |
|---|---|
| ✅ State Management | **Cubit** (flutter_bloc) only |
| ✅ Local Products | 6 real products with asset images matching design |
| ✅ API Products | Fetched from `dummyjson.com/products` |
| ✅ Infinite Scroll | Auto-loads more from API as you scroll |
| ✅ Search | Real-time search via DummyJSON API |
| ✅ Cart | Add / Remove / Adjust quantity |
| ✅ Auto Price Calculation | Items Total + Shipping (Free) = Total in EGP |
| ✅ Cart Badge | Live item count on cart icon |
| ✅ Design Match | Matches provided Figma UI exactly |

## 🚀 Setup & Run

```bash
flutter pub get
flutter run
```

## 📦 Dependencies

```yaml
flutter_bloc: ^8.1.3      # Cubit state management
http: ^1.1.0               # API calls
cached_network_image: ^3.3.0  # Efficient image loading
equatable: ^2.0.5          # State comparison
```

## 🏗️ Architecture

```
UI (Screens/Widgets)
        │
        ▼
    Cubit (State)
   /          \
ProductCubit  CartCubit
        │
        ▼
  ProductService (API)
```
