import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/services/notification_services.dart';

import 'package:gowiide_broadband_app/services/resources_respository.dart';
import 'package:gowiide_broadband_app/widgets/plans_details_card.dart';
// Import the ApiRepository class

class PlansDetailsScreen extends StatefulWidget {
  const PlansDetailsScreen({
    Key? key,
    required String userId,
  }) : super(key: key);

  @override
  State<PlansDetailsScreen> createState() => _PlansDetailsScreenState();
}

class _PlansDetailsScreenState extends State<PlansDetailsScreen> {
  ApiRepository apiRepository = ApiRepository();
  NotificationServices notificationServices = NotificationServices();

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Plan Details',
            style: GoogleFonts.workSans(
              fontSize: screenSize.width * 0.055,
              color: const Color.fromARGB(
                  255, 249, 129, 89), // Changed color to black
              fontWeight: FontWeight.w600,
            )),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiRepository.getPlansList(), // Fetch plans list with userId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final plansList = snapshot.data!;
            return ListView.builder(
              itemCount: plansList.length,
              itemBuilder: (context, index) {
                final plan = plansList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: PlanDetailsCard(
                    planName: plan['planName'],
                    amount: plan['amount'],
                    description: plan['description'],
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
