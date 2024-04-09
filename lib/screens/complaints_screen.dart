import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/app_colors.dart';
import 'package:gowiide_broadband_app/services/complaint_selection_dialog.dart';
import 'package:gowiide_broadband_app/services/notification_services.dart';
import 'package:gowiide_broadband_app/services/resources_respository.dart';
import 'package:gowiide_broadband_app/widgets/complaint_card.dart';

class ComplaintsScreen extends StatefulWidget {
  final String userId;
  static const routeName = '/complaint';

  const ComplaintsScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  late Future<List<Map<String, dynamic>>?> _complaintListFuture;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _complaintListFuture = fetchUserComplaintList();
    notificationServices.requestNotificationPermisions();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isRefreshToken();
    notificationServices.getDeviceToken().then((value) {
      print(value);
    });
  }

  Future<List<Map<String, dynamic>>> fetchUserComplaintList() async {
    final ApiRepository apiRepository = ApiRepository();
    try {
      final dynamic response =
          await apiRepository.getUserComplaintList(widget.userId);
      if (response != null && response is List<dynamic>) {
        return response.cast<Map<String, dynamic>>();
      } else {
        // Return an empty list if response is null or not of the expected type
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch user complaints: $e');
    }
  }

  // Future<List<Map<String, dynamic>>?> fetchUserComplaintList() async {
  //   final ApiRepository apiRepository = ApiRepository();
  //   try {
  //     final List<Map<String, dynamic>>? complaints =
  //         await apiRepository.getUserComplaintList(widget.userId);
  //     return complaints;
  //   } catch (e) {
  //     throw Exception('Failed to fetch user complaints: $e');
  //   }
  // }

  bool hasPendingComplaints(List<Map<String, dynamic>>? complaints) {
    if (complaints == null) return false;
    return complaints.any((complaint) =>
        complaint['complaintStatus'] == 'Pending' ||
        complaint['complaintStatus'] == 'In Progress');
  }

  // Callback function to refresh complaints screen
  Future<void> _refreshComplaints() async {
    setState(() {
      _complaintListFuture = fetchUserComplaintList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFECF1EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Complaint History',
          style: GoogleFonts.workSans(
            fontSize: screenSize.width * 0.055,
            color: const Color.fromARGB(255, 251, 121, 77),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _complaintListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Map<String, dynamic>>? complaints = snapshot.data;
            if (complaints == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No complaints found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            } else if (complaints.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'No Complaints added yet',
                      style: GoogleFonts.notoSansKhojki(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 255, 128, 86),
                          fontWeight: FontWeight.bold),
                    ),
                    const Image(
                        image: AssetImage('assets/images/complaint-1.png'))
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: ComplaintCard(
                      complaintNo: complaint['complaintNo'] ?? '',
                      complaintSubject: complaint['complaintSubject'] ?? '',
                      complaintOpenTime: complaint['complaintOpenTime'] ?? '',
                      engineerName: complaint['engineerName'] ?? '',
                      complaintStatus: complaint['complaintStatus'] ?? '',
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColors.backgroundColor,
        shape: const CircleBorder(),
        onPressed: () async {
          try {
            final complaints = await _complaintListFuture;
            if (hasPendingComplaints(complaints)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "You have an open complaint",
                      style: GoogleFonts.workSans(
                          fontSize: 20,
                          color: Color.fromARGB(135, 16, 16, 16),
                          fontWeight: FontWeight.w500),
                    ),
                    content: Text(
                      "Please wait for resolution.",
                      style: GoogleFonts.workSans(
                          fontSize: 18.3,
                          color: Color.fromARGB(221, 42, 42, 42)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: GoogleFonts.workSans(
                              fontSize: 18,
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ComplaintRegistrationScreen(
                    userId: widget.userId,
                    onComplaintAdded:
                        _refreshComplaints, // Pass the callback function
                  );
                },
              );
            }
          } catch (e) {
            // Handle error gracefully
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Error",
                    style: GoogleFonts.workSans(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                  content: Text(
                    "An error occurred. Please try again later.",
                    style: GoogleFonts.workSans(
                        fontSize: 18.3, color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: GoogleFonts.workSans(
                            fontSize: 18,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 26,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
