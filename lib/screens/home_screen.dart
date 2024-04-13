import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/app_colors.dart';
import 'package:gowiide_broadband_app/services/notification_services.dart';
import 'package:gowiide_broadband_app/services/resources_respository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _paymentHistory;
  NotificationServices notificationServices = NotificationServices();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();

    _paymentHistory = ApiRepository().getPaymentHistory(widget.userId);
    _checkRemainingDays();
    notificationServices.requestNotificationPermisions();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isRefreshToken();
    notificationServices.getDeviceToken().then((value) {
      print(value);
    });

    // notificationServices.requestNotificationPermission();
    // // notificationServices.isTokenRefresh();
    // notificationServices.firebaseInit(context);
    // notificationServices.getDeviceToken().then((value) {
    //   print('device token');
    //   print(value);
    // });
  }

  void _checkRemainingDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastShownDate = prefs.getString('lastShownDate');
    final today = DateTime.now().toString().substring(0, 10);

    // If the dialog hasn't been shown today
    if (lastShownDate != today) {
      final paymentHistory = await _paymentHistory;

      if (paymentHistory.isNotEmpty) {
        final latestPayment = paymentHistory[0];
        final expiryDate = latestPayment['expiryDate'] ?? '';

        if (expiryDate.isNotEmpty) {
          final expiryDateTime = DateTime.parse(expiryDate);
          final remainingDays =
              expiryDateTime.difference(DateTime.now()).inDays + 1;

          if (remainingDays <= 4 && remainingDays >= 0) {
            _showRechargeDialog();

            // Save the current date as the last shown date
            prefs.setString('lastShownDate', today);
          }
        }
      }
    }
  }

  void _showRechargeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Recharge'),
          content: const Text(
              'Your remaining days are 3 or less. Please recharge to continue using the service.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFECF1EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                'assets/images/apk-logo-3.png',
                fit: BoxFit.contain,
              )),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello ${widget.userId}',
                style: GoogleFonts.workSans(
                  fontSize: screenSize.width * 0.046,
                  color: const Color.fromARGB(255, 251, 121, 77),
                  fontWeight: FontWeight.w600,
                )),
            Text('Welcome back!',
                style: GoogleFonts.workSans(
                  fontSize: screenSize.width * 0.039,
                  color: const Color.fromARGB(137, 30, 30, 30),
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _paymentHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final paymentHistory = snapshot.data!;
            if (paymentHistory.isEmpty) {
              return const Center(child: Text('No payment history found'));
            } else {
              final latestPayment = paymentHistory[0];
              final packageName =
                  latestPayment['packageName'] ?? 'Package Name';
              final expiryDate = latestPayment['expiryDate'] ?? '';

              final amount = latestPayment['amount'] != null
                  ? '${latestPayment['amount']}'
                  : '0';
              final renewDate = latestPayment['renewDate'] ?? '';

              final expiryDateTime = expiryDate.isNotEmpty
                  ? DateFormat('yyyy-MM-dd').parse(expiryDate)
                  : DateTime.now();

              final renewDateTime = renewDate.isNotEmpty
                  ? DateFormat('yyyy-MM-dd').parse(renewDate)
                  : DateTime.now();

              // Calculate remaining days
              int remainingDays =
                  expiryDateTime.difference(DateTime.now()).inDays + 1;
              remainingDays = max(
                  remainingDays, 0); // Ensure remaining days is not negative

              final totalDays = expiryDateTime.difference(renewDateTime).inDays;
              // // Ensure total days is not zero
              final remainingPercentage =
                  remainingDays.toDouble() / totalDays.toDouble();

              return Container(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circle for remaining days
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.6),
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 146, 146, 146)
                                  .withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: remainingDays > 0
                                    ? Text('ACTIVE',
                                        style: GoogleFonts.workSans(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenSize.width * 0.042))
                                    : Text(
                                        'INACTIVE  ',
                                        style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                            fontSize: screenSize.width * 0.039),
                                      )),
                            Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: remainingDays > 0
                                  ? Icon(
                                      Icons.circle,
                                      size: screenSize.width * 0.043,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.circle,
                                      size: screenSize.width * 0.043,
                                      color: Colors.red,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Stack(
                      children: [
                        Container(
                          height: height * 0.42,
                          width: width * 0.75,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 146, 146, 146)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: width * 0.045,
                          top: height * 0.022,
                          child: SizedBox(
                            height: height * 0.38,
                            width: width * 0.65,
                            child: Stack(
                              children: [
                                // Outer white circle with shadow

                                Container(
                                  height: height * 0.38,
                                  width: width * 0.7,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),

                                // Purple countdown line
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: CustomPaint(
                                    size: Size(height * 0.33, width * 0.6),
                                    painter: CirclePainter(remainingPercentage),
                                  ),
                                ),
                                // Text for remaining days
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('REMAINING',
                                          style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenSize.width * 0.041,
                                            color: const Color.fromARGB(
                                                255, 115, 115, 115),
                                          )),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text('$remainingDays',
                                          style: GoogleFonts.workSans(
                                              fontSize: screenSize.width * 0.23,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 74, 81, 211))),
                                      const SizedBox(
                                        height: 0,
                                      ),
                                      Text('Days',
                                          style: GoogleFonts.workSans(
                                            fontSize: screenSize.width * 0.070,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromARGB(
                                                255, 115, 115, 115),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                        expiryDate == ''
                            ? '$renewDate'
                            : '$renewDate - $expiryDate',
                        style: GoogleFonts.workSans(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 115, 115, 115),
                            fontSize: screenSize.width * 0.039)),

                    SizedBox(height: height * 0.025),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        height: height * 0.085,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 146, 146, 146)
                                  .withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_left_sharp,
                              color: AppColors.backgroundColor,
                              size: 32.5,
                            ),
                            Text(
                              packageName,
                              style: GoogleFonts.workSans(
                                color: const Color.fromARGB(255, 115, 115, 115),
                                fontWeight: FontWeight.w600,
                                fontSize: screenSize.width * 0.046,
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: height * 0.05,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  amount,
                                  style: GoogleFonts.notoSansKhojki(
                                    fontSize: screenSize.width * 0.042,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double remainingPercentage;

  CirclePainter(this.remainingPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.blackColor
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final double radius = size.width * 0.50;
    final double centerX = size.width * 0.50;
    final double centerY = size.height * 0.50;

    const double startAngle = -pi / 2;
    final double sweepAngle = 2 * pi * remainingPercentage;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
