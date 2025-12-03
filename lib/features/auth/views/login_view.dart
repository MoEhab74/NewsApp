import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/auth/widgets/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme.of(context).brightness ===> current theme mode (dark or light)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen glass effect background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [Colors.black87, Colors.grey[900]!]
                        : [Colors.white, Colors.orange[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: (isDark ? Colors.black45 : Colors.white70).withOpacity(
                    0.2,
                  ),
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    width: 320.w,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.black54 : Colors.white70)
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: (isDark ? Colors.white24 : Colors.white30),
                        width: 1,
                      ),
                    ),
                    child: LoginForm(isDark: isDark),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
