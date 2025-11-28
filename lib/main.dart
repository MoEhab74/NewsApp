import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/views/home_view.dart';
import 'package:news_app/core/theme/theme.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

final dio = Dio();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => NewsCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NewsCloud',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}

