// ComplaintRegistrationScreen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/app_colors.dart';
import 'package:gowiide_broadband_app/services/resources_respository.dart';

class ComplaintRegistrationScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onComplaintAdded; // Callback function
  const ComplaintRegistrationScreen({
    Key? key,
    required this.userId,
    required this.onComplaintAdded,
  }) : super(key: key);

  @override
  _ComplaintRegistrationScreenState createState() =>
      _ComplaintRegistrationScreenState();
}

class _ComplaintRegistrationScreenState
    extends State<ComplaintRegistrationScreen> {
  late String _selectedSubject;
  late TextEditingController _messageController;
  late Future<List<String>> _complaintSubjectsFuture;
  final ApiRepository _apiRepository = ApiRepository();

  @override
  void initState() {
    super.initState();
    _selectedSubject = 'No internet';
    _messageController = TextEditingController();
    _complaintSubjectsFuture = _apiRepository.getComplaintSubjects();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    final String message = _messageController.text;
    if (message.isNotEmpty) {
      try {
        final response = await _apiRepository.registerComplaint(
            widget.userId, _selectedSubject, message);

        // Call the callback function when complaint is successfully added
        widget.onComplaintAdded();
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(response['status'] == 'OK' ? 'Success' : 'Error'),
            content: Text(
              response['message'],
              style: GoogleFonts.workSans(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        _messageController.clear();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to submit complaint: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a message.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Reason',
            style: GoogleFonts.workSans(
                color: const Color.fromARGB(221, 35, 35, 35),
                fontSize: screenSize.width * 0.05,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Container(
                width: width * 0.7,
                child: Text(
                  _selectedSubject,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.workSans(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: screenSize.width * 0.042,
                  ),
                ),
              ),
              Expanded(child: Container()),
              IconButton(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 27,
                  color: AppColors.backgroundColor,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder<List<String>>(
                        future: _complaintSubjectsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final subject = snapshot.data![index];
                                return ListTile(
                                  title: Text(
                                    subject,
                                    style: GoogleFonts.notoSansKhojki(
                                        fontSize: 16.5,
                                        color: const Color.fromARGB(
                                            221, 35, 35, 35)),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedSubject = subject;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your complaint message...',
              hintStyle: GoogleFonts.workSans(
                fontSize: screenSize.width * 0.045,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.13),
                child: Container(
                  height: 70,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 224),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 210, 210, 210),
                            offset: Offset(1, 1),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ]),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.workSans(
                        color: const Color.fromARGB(255, 39, 39, 39),
                        fontSize: screenSize.width * 0.036,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: _submitComplaint,
              child: Padding(
                padding: EdgeInsets.only(right: width * 0.13),
                child: Container(
                  height: 70,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 210, 210, 210),
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                          blurRadius: 1)
                    ],
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.036,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
