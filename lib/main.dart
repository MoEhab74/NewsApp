import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/theme/theme_exports.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';
import 'package:news_app/features/home/cubit/article_action_cubit.dart';
import 'package:news_app/features/auth/cubit/auth_cubit.dart';
import 'package:news_app/features/auth/views/user_auth_state.dart';
import 'package:news_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Wait a moment for Firebase Auth to fully initialize
  await Future.delayed(const Duration(milliseconds: 100));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => NewsCubit()),
        BlocProvider(create: (context) => ArticleActionCubit()),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'NewsCloud',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              // themeState.themeMode ===> Saves the current theme mode in the ThemeCubit
              themeMode: themeState.themeMode,
              home: const UserAuthState(),
            );
          },
        ),
      ),
    );
  }
}

