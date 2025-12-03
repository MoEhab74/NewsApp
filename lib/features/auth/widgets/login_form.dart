import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/ui/app_buttom.dart';
import 'package:news_app/core/ui/app_text_form_field.dart';
import 'package:news_app/features/auth/cubit/auth_cubit.dart';
import 'package:news_app/features/auth/cubit/auth_state.dart';
import 'package:news_app/features/auth/widgets/social_media_options.dart';
import 'package:news_app/features/views/home_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.isDark});

  final bool isDark;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineMedium?.color,
              ),
            ),
            SizedBox(height: 16.h),
            AppTextFormField(
              controller: _emailController,
              isDark: widget.isDark,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            AppTextFormField(
              controller: _passwordController,
              isDark: widget.isDark,
              obscureText: true,
              hintText: 'Password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                // like email validation but for password
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state is Authenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login Successful!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                  );
                }
              },
              builder: (context, state) {
                return state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButtom(
                      text: 'Login',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process login
                          context.read<AuthCubit>().login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      },
                    );
              },
            ),
            // Social login options
            SizedBox(height: 24.h),
            SocialMediaOptions(widget: widget),
          ],
        ),
      ),
    );
  }
}
