import 'package:flutter/material.dart';
import 'package:gowiide_broadband_app/screens/complaints_screen.dart';
import 'package:gowiide_broadband_app/screens/home_screen.dart';
import 'package:gowiide_broadband_app/screens/notifications_screen.dart';
import 'package:gowiide_broadband_app/screens/payment_history_screen.dart';
import 'package:gowiide_broadband_app/screens/plans_details_screen.dart';

List<Widget> initializePages(String userId) {
  return [
    HomeScreen(userId: userId),
    ComplaintsScreen(userId: userId),
    PaymentHistoryScreen(userId: userId),
    PlansDetailsScreen(userId: userId),
    NotificationsScreen(userId: userId),
  ];
}
