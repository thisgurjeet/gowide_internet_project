import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:unicons/unicons.dart';

import 'package:gowiide_broadband_app/screens/utils/constants.dart';

class BottomNavigationScreen extends StatefulWidget {
  final String userId;

  const BottomNavigationScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 233, 233, 233),
        bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BottomNavigationBar(
              elevation: 2,
              onTap: (idx) {
                setState(() {
                  pageIdx = idx;
                });
              },
              currentIndex: pageIdx,
              selectedLabelStyle: GoogleFonts.notoSansKhojki(
                  fontSize: 13,
                  color: Colors.black38,
                  fontWeight: FontWeight.w600),
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Color.fromARGB(255, 252, 103, 53),
              unselectedItemColor: Color.fromARGB(255, 54, 54, 54),
              backgroundColor: Color.fromARGB(255, 255, 223, 214),
              items: [
                _buildBottomNavigationBarItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                  backgroundColor: Colors.white,
                ),
                _buildBottomNavigationBarItem(
                  icon: Icons.help,
                  label: 'Complaints',
                  index: 1,
                  backgroundColor: Colors.white,
                ),
                _buildBottomNavigationBarItem(
                  icon: UniconsLine.dollar_sign,
                  label: 'Payments',
                  index: 2,
                  backgroundColor: Colors.white,
                ),
                _buildBottomNavigationBarItem(
                  icon: Icons.wifi,
                  label: 'Plans',
                  index: 3,
                  backgroundColor: Colors.white,
                ),
                _buildBottomNavigationBarItem(
                  icon: Ionicons.notifications,
                  label: 'Notify',
                  index: 4,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
        body: initializePages(widget.userId)[pageIdx]);
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
    required Color backgroundColor,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 25),
      label: pageIdx == index ? label : '', // Show label only if selected
      backgroundColor: backgroundColor, // Set the background color for the item
    );
  }
}
