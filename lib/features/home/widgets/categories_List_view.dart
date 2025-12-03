import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/widgets/card_category.dart';
import 'package:news_app/features/home/models/category_model.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';
import 'package:news_app/features/home/cubit/news_states.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {

  final List<CategoryModel> categoriesInfo = const [
    CategoryModel(image: 'assets/images/business.png', name: 'Business'),
    CategoryModel(
      image: 'assets/images/entertaiment.png',
      name: 'Entertainment',
    ),
    CategoryModel(image: 'assets/images/general.png', name: 'General'),
    CategoryModel(image: 'assets/images/health.png', name: 'Health'),
    CategoryModel(image: 'assets/images/science.png', name: 'Science'),
    CategoryModel(image: 'assets/images/sports.png', name: 'Sports'),
    CategoryModel(image: 'assets/images/technology.jpeg', name: 'Technology'),
  ];

  

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final listHeight = (mq.height * 0.13).clamp(80.0, 160.0);

    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        String currentCategory = 'general'; // default
        
        // Get current category from cubit
        if (state is FetchTopHeadlinesSuccessState) {
          currentCategory = state.category;
        } else if (state is FetchByCategorySuccessState) {
          currentCategory = state.category;
        } else {
          currentCategory = context.read<NewsCubit>().currentCategory;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(
              height: listHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesInfo.length,
                itemBuilder: (context, index) {
                  final category = categoriesInfo[index];
                  final isSelected = category.name.toLowerCase() == currentCategory.toLowerCase();
                  
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
                    child: Container(
                      decoration: isSelected
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: CardCategory(category: category),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
