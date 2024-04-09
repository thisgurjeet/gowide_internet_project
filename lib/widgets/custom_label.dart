import 'package:flutter/material.dart';

class CustomBottomNavigationBarLabel extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CustomBottomNavigationBarLabel({
    Key? key,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.black : Colors.black38,
          ),
        ),
        if (isSelected)
          Positioned(
            bottom: 0,
            child: Container(
              width: 50, // Adjust width as needed
              height: 2,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.orange,
                    width: 1, // Adjust thickness as needed
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
