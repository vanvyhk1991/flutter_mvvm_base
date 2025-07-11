# Firebase Push Notification Setup Guide

## 1. Cài đặt Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

## 2. Tạo Firebase Project

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Tạo project mới hoặc chọn project có sẵn
3. Enable Cloud Messaging trong project

## 3. Cấu hình Android

### 3.1. Tạo file google-services.json

1. Trong Firebase Console, chọn project
2. Vào Project Settings > General
3. Trong phần "Your apps", click "Add app" > Android
4. Nhập package name: `com.video_tube.training`
5. Download file `google-services.json`
6. Đặt file vào thư mục `android/app/`

### 3.2. Cấu hình build.gradle

**android/build.gradle:**
```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**android/app/build.gradle:**
```gradle
// Add this line at the bottom
apply plugin: 'com.google.gms.google-services'
```

## 4. Cấu hình iOS

### 4.1. Tạo file GoogleService-Info.plist

1. Trong Firebase Console, chọn project
2. Vào Project Settings > General
3. Trong phần "Your apps", click "Add app" > iOS
4. Nhập Bundle ID: `com.videoTube.training`
5. Download file `GoogleService-Info.plist`
6. Đặt file vào thư mục `ios/Runner/`

### 4.2. Cấu hình iOS

**ios/Runner/AppDelegate.swift:**
```swift
import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 5. Cài đặt Dependencies

Chạy lệnh để cài đặt dependencies:
```bash
flutter pub get
```

## 6. Generate Code

Chạy lệnh để generate code cho Retrofit:
```bash
flutter packages pub run build_runner build
```

## 7. Test Push Notification

### 7.1. Test từ Firebase Console

1. Vào Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Nhập thông tin notification
4. Trong phần "Target", chọn "Single device" và nhập FCM token
5. Send message

### 7.2. Test từ API

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
      "productId": "123",
      "action": "show_dialog",
      "message": "Product updated!"
    }
  }'
```

## 8. Cấu trúc Notification Payload

### 8.1. Basic Notification
```json
{
  "notification": {
    "title": "Notification Title",
    "body": "Notification Body"
  },
  "data": {
    "screen": "product",
    "productId": "123"
  }
}
```

### 8.2. Navigation Notification
```json
{
  "notification": {
    "title": "New Product",
    "body": "Check out our new product!"
  },
  "data": {
    "screen": "product",
    "productId": "456",
    "action": "refresh"
  }
}
```

### 8.3. Dialog Notification
```json
{
  "notification": {
    "title": "Important Update",
    "body": "Please read this important message"
  },
  "data": {
    "action": "show_dialog",
    "message": "Your account has been updated successfully!"
  }
}
```

## 9. Các trạng thái App

### 9.1. Foreground (App đang mở)
- Notification được handle bởi `FirebaseMessaging.onMessage`
- Hiển thị local notification
- Có thể show custom UI

### 9.2. Background (App đang chạy nhưng không active)
- Notification được handle bởi `_firebaseMessagingBackgroundHandler`
- Hiển thị system notification
- Khi tap sẽ mở app và trigger `FirebaseMessaging.onMessageOpenedApp`

### 9.3. Terminated (App đã tắt)
- Notification được handle bởi system
- Khi tap sẽ mở app và trigger `getInitialMessage()`
- App sẽ navigate đến screen tương ứng

## 10. Troubleshooting

### 10.1. Không nhận được notification
- Kiểm tra FCM token có được generate không
- Kiểm tra permissions đã được grant chưa
- Kiểm tra internet connection
- Kiểm tra Firebase project configuration

### 10.2. Notification không hiển thị
- Kiểm tra notification channel đã được tạo chưa
- Kiểm tra notification permissions
- Kiểm tra app có bị kill bởi system không

### 10.3. Navigation không hoạt động
- Kiểm tra router đã được set trong NotificationNavigationService chưa
- Kiểm tra payload format có đúng không
- Kiểm tra route đã được định nghĩa trong AppRouter chưa

## 11. Best Practices

1. **Always handle errors**: Wrap tất cả Firebase operations trong try-catch
2. **Test on real devices**: Push notification không hoạt động trên simulator
3. **Handle token refresh**: FCM token có thể thay đổi, luôn lắng nghe sự kiện refresh
4. **Use topics for broadcast**: Subscribe users vào topics thay vì gửi individual notifications
5. **Optimize payload size**: Giữ payload nhỏ để tránh timeout
6. **Handle all app states**: Test notification ở cả 3 trạng thái (foreground, background, terminated)

## 12. Security Considerations

1. **Never expose FCM token**: Token chỉ nên được gửi lên server của bạn
2. **Validate payload**: Luôn validate payload trước khi xử lý
3. **Use HTTPS**: Chỉ gửi notification qua HTTPS
4. **Rate limiting**: Implement rate limiting để tránh spam
5. **User consent**: Luôn xin permission trước khi gửi notification 