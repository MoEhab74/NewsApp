import 'package:flutter/material.dart';

class ArticleActionWidget extends StatelessWidget {
  const ArticleActionWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
