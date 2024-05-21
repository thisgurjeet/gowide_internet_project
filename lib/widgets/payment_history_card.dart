import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/app_colors.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentHistoryCard extends StatelessWidget {
  final String packageName;
  final String amount;
  final String expiryDate;
  final String invoiceLink;

  const PaymentHistoryCard({
    Key? key,
    required this.packageName,
    required this.amount,
    required this.expiryDate,
    required this.invoiceLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card,
            color: AppColors.blackColor,
            size: screenSize.width * 0.075,
          ),
          SizedBox(width: screenSize.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  packageName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.workSans(
                    color: const Color.fromARGB(255, 115, 115, 115),
                    fontSize: screenSize.width * 0.044,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  expiryDate,
                  style: GoogleFonts.workSans(
                    fontWeight: FontWeight.w500,
                    fontSize: screenSize.width * 0.039,
                    color: const Color.fromARGB(137, 30, 30, 30),
                  ),
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: () {
                    if (invoiceLink.isNotEmpty) {
                      String correctedLink = 'https://www.gowidenet.in/admin' +
                          invoiceLink.substring(1);
                      launch(correctedLink);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.only(top: 1),
                    width: screenSize.width * 0.40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Download Invoice',
                          style: GoogleFonts.workSans(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: screenSize.width * 0.039,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Ionicons.download,
                          size: screenSize.width * 0.04,
                          color: const Color.fromARGB(255, 79, 86, 222),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10), // Added SizedBox for spacing
          Container(
            height: screenSize.height * 0.06,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                amount,
                style: GoogleFonts.openSans(
                  fontSize: screenSize.width * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
