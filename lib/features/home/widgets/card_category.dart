import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/models/category_model.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';
import 'package:news_app/features/home/widgets/view_news_by_category.dart';

class CardCategory extends StatelessWidget {
  const CardCategory({required this.category,super.key});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final cardHeight = (mq.height * 0.13).clamp(80.0, 160.0);
    final cardWidth = (mq.width * 0.45).clamp(120.0, 260.0);
    final labelFont = (mq.width * 0.05).clamp(14.0, 22.0);

    return GestureDetector(
      onTap: () {
        // Check if there's a NewsCubit in the widget tree
        try {
          context.read<NewsCubit>().fetchByCategory(category: category.name.toLowerCase());
        } catch (e) {
          // If we're not in the home view, navigate to category view
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryView(category: category.name.toLowerCase()),
            ),
          );
        }
      },
        child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: SizedBox(
          height: cardHeight,
          width: cardWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 36,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: labelFont,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
