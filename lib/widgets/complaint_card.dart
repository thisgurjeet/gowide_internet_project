import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/app_colors.dart';

class ComplaintCard extends StatelessWidget {
  final String complaintNo;
  final String complaintSubject;
  final String complaintOpenTime;
  final String engineerName;
  final String complaintStatus;
  const ComplaintCard({
    Key? key,
    required this.complaintNo,
    required this.complaintSubject,
    required this.complaintOpenTime,
    required this.engineerName,
    required this.complaintStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    Size screenSize = MediaQuery.of(context).size;
    return Container(
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15),
          child: Text(
            complaintNo,
            style: GoogleFonts.workSans(
                color: AppColors.backgroundColor,
                fontSize: screenSize.width * 0.048,
                fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaintOpenTime,
                    style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(137, 30, 30, 30),
                        fontSize: screenSize.width * 0.041),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.527,
                    child: Text(
                      complaintSubject,
                      style: GoogleFonts.workSans(
                          color: const Color.fromARGB(137, 7, 7, 7),
                          fontSize: screenSize.width * 0.041),
                    ),
                  ),
                  Text(
                    engineerName,
                    style: GoogleFonts.openSans(
                        color: Colors.black54, fontSize: 16),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.085),
              padding: EdgeInsets.only(left: size * 0.02, right: size * 0.02),
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.275,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10), // Upper left corner circular
                    bottomRight:
                        Radius.circular(10), // Bottom right corner circular
                  ),
                  color: complaintStatus == 'Pending'
                      ? AppColors.backgroundColor
                      : Colors.green),
              child: Row(children: [
                Text(
                  complaintStatus,
                  style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(child: Container()),
                complaintStatus == 'Resolved'
                    ? const Icon(
                        Icons.check_box,
                        color: Colors.white,
                      )
                    : Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.backgroundColor,
                        ),
                      )
              ]),
            )
          ],
        ),
      ]),
    );
  }
}
