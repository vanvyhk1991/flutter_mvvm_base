# Training App

## 1. Kiến trúc tổng thể

Dự án sử dụng kiến trúc **MVVM (Model-View-ViewModel)** kết hợp với **Repository Pattern** và **Dependency Injection** để đảm bảo code dễ mở rộng, dễ test và tách biệt rõ ràng giữa các tầng.

- **Model**: Chứa các model dữ liệu (ví dụ: `User`, `Product`).
- **View**: Các màn hình UI (trong `presentation/pages/`), sử dụng `BaseView` để kết nối với ViewModel.
- **ViewModel**: Quản lý logic nghiệp vụ, trạng thái UI, kế thừa từ `BaseViewModel` (trong `presentation/viewmodels/`).
- **Repository**: Đóng vai trò trung gian giữa ViewModel và tầng Service/API (trong `data/repositories/`).
- **Service/API**: Giao tiếp trực tiếp với backend thông qua các service sử dụng thư viện Retrofit/Dio (trong `data/services/`).
- **Dependency Injection**: Sử dụng `get_it` để quản lý và inject các dependency (trong `injection/injector.dart`).

## 2. Thư viện sử dụng

- **Flutter**: Framework chính để xây dựng ứng dụng.
- **provider**: Quản lý state, kết hợp với ChangeNotifier.
- **get_it**: Dependency Injection.
- **go_router**: Điều hướng (routing) giữa các màn hình.
- **dio**: HTTP client mạnh mẽ cho networking.
- **retrofit**: Tạo API client dạng type-safe.
- **hive, hive_flutter**: Lưu trữ dữ liệu local.
- **freezed, json_serializable, json_annotation**: Hỗ trợ sinh code cho model, parse JSON.
- **flutter_screenutil**: Responsive UI.
- **intl**: Đa ngôn ngữ, format ngày giờ.
- **flutter_dotenv**: Quản lý biến môi trường.
- **firebase_core, firebase_messaging, firebase_analytics**: Firebase services.
- **flutter_local_notifications**: Local notifications cho background/terminated state.

## 3. Flow tổng quan

### Khởi tạo ứng dụng

- Hàm `main()` khởi tạo router (`AppRouter`), inject các dependency qua `setupDependencies`, sau đó chạy app.
- `MyApp` sử dụng `MaterialApp.router` để tích hợp với `go_router`.
- **NotificationService** được khởi tạo để xử lý Firebase Push Notification.

### Điều hướng (Routing)

- Định nghĩa các route trong `AppRouter` (file `lib/route/app_route.dart`).
- Sử dụng `redirect` để kiểm tra trạng thái đăng nhập, tự động chuyển hướng về `/login` nếu chưa đăng nhập.

### Luồng đăng nhập (Login Flow)

1. **View**: `LoginScreen` sử dụng `BaseView<AuthViewModel>`, nhận ViewModel từ DI.
2. **ViewModel**: `AuthViewModel` nhận các usecase (login, register, forgot password), thực hiện logic đăng nhập, quản lý trạng thái busy/error.
3. **UseCase**: Thực thi logic nghiệp vụ, gọi tới repository.
4. **Repository**: `AuthRepositoryImpl` gọi tới `AuthApiService` để thực hiện request.
5. **Service**: `AuthApiService` (tạo bởi Retrofit) gửi request tới API backend.
6. **Kết quả**: Trả về model `User` hoặc thông báo lỗi, cập nhật lại UI qua ViewModel.

### Firebase Push Notification Flow

1. **Khởi tạo**: `NotificationService` được khởi tạo trong `main()`.
2. **FCM Token**: Tự động lấy và gửi FCM token lên server qua `UpdateFCMTokenUseCase`.
3. **Foreground**: Notification được handle bởi `FirebaseMessaging.onMessage`, hiển thị local notification.
4. **Background**: Notification được handle bởi `_firebaseMessagingBackgroundHandler`.
5. **Terminated**: Notification được handle bởi system, khi tap sẽ mở app và trigger `getInitialMessage()`.
6. **Navigation**: `NotificationNavigationService` xử lý navigation dựa trên payload của notification.

### Quản lý trạng thái

- ViewModel kế thừa từ `BaseViewModel` (có sẵn các hàm setBusy, setError, clearError).
- UI lắng nghe thay đổi qua `ChangeNotifierProvider` và `Consumer`.

### Dependency Injection

- Tất cả các service, repository, viewmodel được đăng ký trong `setupDependencies` bằng `get_it`.
- ViewModel được inject vào View thông qua `BaseView`.

## 4. Cấu trúc thư mục

```
lib/
├── main.dart
├── core/
│   ├── base/
│   │   ├── base_view_model.dart
│   │   └── base_view.dart
│   ├── cache/
│   │   └── memory_cache.dart
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   ├── app_text_styles.dart
│   │   └── env/
│   │       └── env.dart
│   ├── network/
│   │   ├── app_exception.dart
│   │   ├── auth_change_notifier.dart
│   │   ├── dio_factory.dart
│   │   ├── error_interceptor.dart
│   │   └── retrofit_client.dart
│   ├── notificattions/
│   │   ├── notification_service.dart
│   │   └── notification_navigation_service.dart
├── data/
│   ├── models/
│   │   ├── product_model.dart
│   │   └── user_model.dart
│   ├── repositories/
│   │   ├── auth/
│   │   │   ├── auth_repository_impl.dart
│   │   │   └── auth_repository.dart
│   │   ├── notification/
│   │   │   ├── notification_repository_impl.dart
│   │   │   └── notification_repository.dart
│   │   └── product/
│   │       ├── product_repository_impl.dart
│   │       └── product_repository.dart
│   └── api_services/
│       ├── auth_api_service.dart
│       ├── auth_api_service.g.dart
│       ├── notification_api_service.dart
│       ├── notification_api_service.g.dart
│       ├── navigation_service.dart
│       ├── product_api_service.dart
│       └── product_api_service.g.dart
├── domain/
│   └── usecase/
│       ├── forgot_password_usecase.dart
│       ├── get_products_usecase.dart
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── update_fcm_token_usecase.dart
├── injection/
│   └── injector.dart
├── presentation/
│   ├── pages/
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── product/
│   │   │   └── product_screen.dart
│   │   └── user/
│   │       └── user_view.dart
│   └── viewmodels/
│       ├── auth_view_model.dart
│       ├── product_view_model.dart
│       └── user_view_model.dart
└── route/
    └── app_route.dart
```

## 5. Một số điểm nổi bật

- **Tách biệt rõ ràng** giữa UI, logic nghiệp vụ, data và networking.
- **Dễ mở rộng**: Thêm mới tính năng chỉ cần thêm UseCase, Repository, Service tương ứng.
- **Dễ test**: Có thể mock các tầng dưới khi test ViewModel.
- **Quản lý trạng thái đơn giản**: Dựa trên Provider/ChangeNotifier.
- **Firebase Push Notification**: Hỗ trợ đầy đủ notification ở mọi trạng thái app (foreground, background, terminated).
- **Navigation từ Notification**: Tự động navigate đến screen tương ứng khi tap notification.

## 6. Firebase Push Notification

### Tính năng
- ✅ Nhận notification khi app đang mở (foreground)
- ✅ Nhận notification khi app ở background
- ✅ Nhận notification khi app đã tắt (terminated)
- ✅ Tự động navigate đến screen tương ứng
- ✅ Hiển thị dialog từ notification
- ✅ Subscribe/unsubscribe topics
- ✅ Gửi FCM token lên server
- ✅ Handle token refresh

### Cách sử dụng
1. Xem file `FIREBASE_SETUP.md` để setup Firebase
2. Chạy `flutter pub get` để cài đặt dependencies
3. Generate code: `flutter packages pub run build_runner build`
4. Test notification từ Firebase Console

## 7. Hướng dẫn cài đặt và chạy

1. Clone dự án về máy
2. Setup Firebase theo hướng dẫn trong `FIREBASE_SETUP.md`
3. Chạy `flutter pub get` để cài đặt dependencies
4. Chạy `flutter packages pub run build_runner build` để generate code
5. Chạy `flutter run` để khởi động ứng dụng

## 8. Build và deploy

- **Android**: `flutter build apk` hoặc `flutter build appbundle`
- **iOS**: `flutter build ios`

## 9. Testing Push Notification

### Test từ Firebase Console
1. Vào Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Nhập thông tin notification
4. Chọn "Single device" và nhập FCM token
5. Send message

### Test từ API
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test notification"
    },
    "data": {
      "screen": "product",
      "productId": "123"
    }
  }'
```
