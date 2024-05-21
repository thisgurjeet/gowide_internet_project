import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowiide_broadband_app/app_colors.dart';

class PlanDetailsCard extends StatelessWidget {
  final String planName;
  final String amount;
  final String description;

  const PlanDetailsCard({
    Key? key,
    required this.planName,
    required this.amount,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          Icon(
            Icons.wifi,
            color: AppColors.blackColor,
            size: screenSize.width * 0.075,
          ),
          SizedBox(width: width * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: GoogleFonts.workSans(
                    color: const Color.fromARGB(255, 121, 121, 121),
                    fontSize: screenSize.width * 0.044,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: null, // Allow unlimited lines
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.workSans(
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(137, 30, 30, 30),
                    fontSize: screenSize.width * 0.038,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                amount,
                style: GoogleFonts.openSans(
                  fontSize: screenSize.width * 0.042,
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
