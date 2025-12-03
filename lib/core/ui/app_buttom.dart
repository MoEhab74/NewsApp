import 'package:flutter/material.dart';

class AppButtom extends StatelessWidget {
  const AppButtom({super.key, this.text, this.onPressed});
  final String? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Text(
        text ?? 'Click Me',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
