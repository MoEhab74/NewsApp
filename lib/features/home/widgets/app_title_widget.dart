import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required this.titleFont});

  final double titleFont;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'News',
            style: TextStyle(
              fontSize: titleFont,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Cloud',
            style: TextStyle(
              fontSize: titleFont,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}