import 'package:flutter/material.dart';
import 'package:news_app/Widgets/card_category.dart';
import 'package:news_app/models/category_model.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  final List<CategoryModel> categoriesInfo = const [
    CategoryModel(image: 'assets/business.avif', name: 'Business'),
    CategoryModel(
      image: 'assets/entertaiment.avif',
      name: 'Entertainment',
    ),
    CategoryModel(image: 'assets/general.avif', name: 'General'),
    CategoryModel(image: 'assets/health.avif', name: 'Health'),
    CategoryModel(image: 'assets/science.avif', name: 'Science'),
    CategoryModel(image: 'assets/sports.avif', name: 'Sports'),
    CategoryModel(image: 'assets/technology.jpeg', name: 'Technology'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categoriesInfo.length,
        itemBuilder: (context, index) {
          return CardCategory(category: categoriesInfo[index]);
        },
        // Anoter solution is to return the widget by mapping
        // return categoriesInfo
        //          .map((e) => CardCategory(categoryModel: e))
        //          .toList()[index];
      ),
    );
  }
}
