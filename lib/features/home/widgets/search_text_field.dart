import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        // Trigger search method here
        if (timer != null) {
          timer!.cancel();
        }
        timer = Timer(Duration(milliseconds: 600), () {
          // Call your search function with the 'value'
          context.read<NewsCubit>().searchArticlesByKeyword(keyword: value);
        });
      },
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
