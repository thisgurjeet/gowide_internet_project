import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gowiide_broadband_app/app_colors.dart';
import 'package:gowiide_broadband_app/services/resources_respository.dart';

class NotificationsCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String nid;
  final String userId;
  const NotificationsCard({
    Key? key,
    required this.title,
    required this.message,
    required this.time,
    required this.nid,
    required this.userId,
  }) : super(key: key);

  void showNotificationMessage(
      BuildContext context, String title, String nid, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ApiRepository().updateNotificationStatus(nid, userId);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Set border radius to 0
          ),
          content: Text(message,
              style: GoogleFonts.notoSansKhojki(
                  color: Color.fromARGB(221, 45, 45, 45), fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ok',
                style:
                    TextStyle(fontSize: 16, color: AppColors.backgroundColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.14,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 146, 146, 146).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 8, right: 15),
        child: Row(
          children: [
            Icon(
              Icons.notification_add_outlined,
              color: AppColors.blackColor,
              size: screenSize.width * 0.072,
            ),
            SizedBox(width: width * 0.01),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              width: width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.workSans(
                        color: const Color.fromARGB(255, 121, 121, 121),
                        fontSize: screenSize.width * 0.042,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  Flexible(
                      child: Container(
                    padding: const EdgeInsets.only(left: 70),
                    child: GestureDetector(
                      onTap: () =>
                          showNotificationMessage(context, title, nid, message),
                      child: Text('...view more',
                          maxLines: 2,
                          softWrap: true, // Allow text to wrap
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                              color: const Color.fromARGB(255, 247, 84, 30),
                              fontSize: screenSize.width * 0.042,
                              fontWeight: FontWeight.w500)),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.16,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: screenSize.width * 0.034,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
