// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import '../main.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Ttile: ${message.notification?.title}');
//   print('Ttile: ${message.notification?.body}');
//   print('Ttile: ${message.notification?.body}');
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications',
//     importance: Importance.max,
//   );

//   final _localNotifications = FlutterLocalNotificationsPlugin();

//   void handleMessage(RemoteMessage? message) {
//     if (message != null) {
//       // Navigate to ComplaintScreen
//       navigatorKey.currentState?.pushNamed('/bottom-navigation');
//     }
//   }

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('Token: $fCMToken');
//     initPushNotifications();
//     initLocalNotifications();
//   }

//   Future initLocalNotifications() async {
//     const android = AndroidInitializationSettings('@drawable/ic_launcher.png');
//     const settings = InitializationSettings(android: android);

//     await _localNotifications.initialize(settings,
//         onDidReceiveNotificationResponse: (payload) {
//       final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
//       handleMessage(message);
//     });

//     final platform = _localNotifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//   }

//   Future initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;

//       const String customSoundPath = 'assets/audio/noti.mp3';

//       _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannel.id,
//             _androidChannel.name,
//             channelDescription: _androidChannel.description,
//             icon: '@drawable/applogo.jpg',
//             sound: const RawResourceAndroidNotificationSound(customSoundPath),
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }

// //   Future initPushNotifications() async {
// //     await FirebaseMessaging.instance
// //         .setForegroundNotificationPresentationOptions(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //     );

// //     FirebaseMessaging.instance
// //         .getInitialMessage()
// //         .then(handleMessage as FutureOr Function(RemoteMessage? value));
// //     FirebaseMessaging.onMessageOpenedApp
// //         .listen(handleMessage as void Function(RemoteMessage event)?);
// //     FirebaseMessaging.onBackgroundMessage(
// //       (message) {
// //         return handleBackgroundMessage(message);
// //       },
// //     );
// //     FirebaseMessaging.onMessage.listen((message) {
// //       final notification = message.notification;
// //       if (notification == null) return;

// //       const String customSoundPath = 'assets/audio/noti.mp3';
// // //

// //       _localNotifications.show(
// //           notification.hashCode,
// //           notification.title,
// //           notification.body,
// //           NotificationDetails(
// //               android: AndroidNotificationDetails(
// //             _androidChannel.id,
// //             _androidChannel.name,
// //             channelDescription: _androidChannel.description,
// //             icon: '@drawable/applogo.jpg',
// //             sound: const RawResourceAndroidNotificationSound(customSoundPath),
// //           )),
// //           payload: jsonEncode(message.toMap()));
// //     });
// //   }
// }
