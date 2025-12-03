import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/widgets/news_list_view_builder.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..getTopHeadlines(category: category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            category.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        body: CustomScrollView(
          slivers: [
            NewsListViewBuilder(),
          ],
        ),
      ),
    );
  }
}