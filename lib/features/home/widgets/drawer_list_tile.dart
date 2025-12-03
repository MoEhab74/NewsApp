import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }
}
