import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/auth/widgets/login_form.dart';

class SocialMediaOptions extends StatelessWidget {
  const SocialMediaOptions({
    super.key,
    required this.widget,
  });

  final LoginForm widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: widget.isDark ? Colors.white54 : Colors.black54,
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: widget.isDark ? Colors.white54 : Colors.black54,
                thickness: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/images/google.png',
                width: 32.w,
                height: 32.h,
              ),
              onPressed: () {
                // Handle Google login
              },
            ),
            SizedBox(width: 24.w),
            IconButton(
              icon: Image.asset(
                'assets/images/facebook.png',
                width: 32.w,
                height: 32.h,
              ),
              onPressed: () {
                // Handle Facebook login
              },
            ),
          ],
        ),
      ],
    );
  }
}
