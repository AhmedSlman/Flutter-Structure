# Quick Start Guide - Core Hybrid

## 🚀 إنشاء مشروع جديد

### 1. إنشاء مشروع Flutter

```bash
flutter create my_app
cd my_app
```

### 2. تثبيت Mason

```bash
dart pub global activate mason_cli
```

### 3. إضافة Templates

```bash
# إنشاء مجلد mason
mason init

# إضافة البريكات
# انسخ محتوى mason.yaml من المشروع
```

### 4. تحميل البريكات

```bash
mason get
```

### 5. توليد المشروع

```bash
# 1. توليد الأصول (Assets)
mason make assets -o .

# 2. توليد Core & Shared
mason make project_template -o lib

# 3. توليد Auth System
mason make auth -o lib/features
```

### 6. تحديث pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Navigation
  go_router: ^14.0.0

  # State Management
  flutter_bloc: ^8.1.3

  # Dependency Injection
  get_it: ^7.6.0

  # Network
  dio: ^5.8.0

  # Cache
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.4

  # UI
  flutter_svg: ^2.0.7
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  lottie: ^2.0.1

  # Add all other dependencies from README.md
```

### 7. تكوين الأصول

```yaml
# في pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/json/
    - assets/fonts/
```

### 8. تشغيل التطبيق

```bash
flutter pub get
flutter run
```

---

## ⚡ إضافة Feature جديد

```bash
mason make feature -o lib/features
```

**الأسئلة:**

- Feature name: `products`
- Insert route? `yes`
- Make singleton? `yes`

**النتيجة:**

```
✅ lib/features/products/ created
✅ Route added to app_router.dart
✅ Repository registered in DI
✅ CRUD methods auto-generated
```

---

## 💻 مثال سريع

### 1. Repository

```dart
// Auto-generated in repository.dart
class ProductsRepository {
  final ApiConsumer apiConsumer;

  ProductsRepository(this.apiConsumer);

  Future<ApiResult<List<ProductsModel>>> getList() async {
    return await apiConsumer.get<List<ProductsModel>>(
      path: ProductsEndPoints.getList,
      parser: (json) {
        final list = json['data'] as List;
        return list.map((item) => ProductsModel.fromJson(item)).toList();
      },
    );
  }
}
```

### 2. Cubit

```dart
class ProductsCubit extends Cubit<ProductsStates> {
  ProductsRepository repository = sl<ProductsRepository>();

  ProductsCubit() : super(ProductsInitial());

  void loadProducts() async {
    emit(ProductsLoading());

    final result = await repository.getList();

    result.fold(
      onSuccess: (products) => emit(ProductsLoaded(products)),
      onFailure: (failure) => emit(ProductsError(failure.userMessage)),
    );
  }
}
```

### 3. UI

```dart
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit()..loadProducts(),
      child: BlocBuilder<ProductsCubit, ProductsStates>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const CircularProgressIndicator();
          }

          if (state is ProductsError) {
            return Text(state.message);
          }

          if (state is ProductsLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.products[index].name),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
```

### 4. Navigation

```dart
// في أي مكان
context.go(AppRoutes.products);

// مع arguments
context.push(
  AppRoutes.productDetails,
  extra: productId,
);
```

---

## 🔧 التخصيص

### 1. تحديث Base URL

```dart
// في core/config/key.dart
class ConstKeys {
  static const String baseUrl = 'https://your-api.com/api';
}
```

### 2. إضافة Colors

```dart
// في core/resources/app_colors.dart
static const Color myCustomColor = Color(0xFF123456);
```

### 3. إضافة Route

```bash
# تلقائي عبر Mason
mason make feature

# أو يدوي في app_router.dart
GoRoute(
  path: '/my-route',
  name: 'myRoute',
  pageBuilder: (context, state) => CustomTransitionPage(
    child: const MyScreen(),
  ),
),
```

---

## 🎯 Next Steps

1. ✅ قرأ [CORE_HYBRID_COMPLETE.md](CORE_HYBRID_COMPLETE.md)
2. ✅ راجع [CHANGELOG.md](CHANGELOG.md)
3. ✅ ابدأ تطوير features
4. ✅ استمتع بالتطوير السريع! 🚀

---

**Happy Coding! 🎉**
