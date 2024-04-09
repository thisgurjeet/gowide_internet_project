import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/services/notification_services.dart';

import 'package:gowiide_broadband_app/services/resources_respository.dart';
import 'package:gowiide_broadband_app/widgets/payment_history_card.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final String userId;
  const PaymentHistoryScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  ApiRepository apiRepository = ApiRepository();
  NotificationServices notificationServices =
      NotificationServices(); // Instantiate ApiRepository

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermisions();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isRefreshToken();
    notificationServices.getDeviceToken().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Payment History',
            style: GoogleFonts.workSans(
              fontSize: screenSize.width * 0.055,
              color: const Color.fromARGB(255, 251, 121, 77),
              fontWeight: FontWeight.w600,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: apiRepository.getPaymentHistory(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final paymentHistory = snapshot.data!;
                  return ListView.builder(
                    itemCount: paymentHistory.length,
                    itemBuilder: (context, index) {
                      final payment = paymentHistory[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 12),
                        child: PaymentHistoryCard(
                            packageName: payment['packageName'] ?? '',
                            expiryDate: payment['expiryDate'] ?? '',
                            // renewDate: payment['renewDate'] ?? '',
                            amount: payment['amount'] ?? '',
                            invoiceLink: payment['invoiceLink'] ?? ''),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
