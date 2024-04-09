import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/services/notification_services.dart';

import 'package:gowiide_broadband_app/services/resources_respository.dart';
import 'package:gowiide_broadband_app/widgets/notifications_card.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;
  const NotificationsScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Map<String, dynamic>>> _notifications;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _notifications = fetchNotifications();
    notificationServices.requestNotificationPermisions();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isRefreshToken();
    notificationServices.getDeviceToken().then((value) {
      print(value);
    }); // Replace with your API call function
  }

  String formatTime(String time) {
    final parts = time.split(' ');
    if (parts.length >= 3) {
      return '${parts[0]} ${parts[1]}\n${parts.sublist(2).join(' ')}';
    } else {
      return time;
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final apiRepository = ApiRepository();
    final notifications =
        await apiRepository.getNotificationHistory(widget.userId);

    // Check if there are new notifications

    return notifications;
  }

// Initialize the plugin

// Define the initialization settings for the plugin

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Notifications',
            style: GoogleFonts.workSans(
                fontSize: screenSize.width * 0.055,
                color: const Color.fromARGB(
                    255, 249, 111, 65), // Changed color to black
                fontWeight: FontWeight.w600)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final notifications = snapshot.data ?? [];
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationsCard(
                  userId: widget.userId,
                  nid: notification['nid'].toString(),
                  title: notification['title'] ??
                      'Attention users of Gowide Broadband',
                  message: notification['message'] ?? '',
                  time: formatTime(
                    notification['time'] ?? '',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
