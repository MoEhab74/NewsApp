import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:news_app/Widgets/card_category.dart';
import 'package:news_app/models/category_model.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  final ScrollController _scrollController = ScrollController();

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final listHeight = (mq.height * 0.13).clamp(80.0, 160.0);

    return SizedBox(
      height: listHeight,
      child: Listener(
        // Map vertical mouse wheel to horizontal scroll for web/desktop
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            final scrollDelta = pointerSignal.scrollDelta.dy;
            if (_scrollController.hasClients) {
              final newOffset = (_scrollController.offset + scrollDelta).clamp(
                _scrollController.position.minScrollExtent,
                _scrollController.position.maxScrollExtent,
              );
              _scrollController.jumpTo(newOffset);
            }
          }
        },
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: categoriesInfo.length,
            itemBuilder: (context, index) {
              return CardCategory(category: categoriesInfo[index]);
            },
          ),
        ),
      ),
    );
  }
}
