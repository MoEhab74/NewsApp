import 'package:flutter/material.dart';
import 'package:news_app/features/home/widgets/category_headline_title_widget.dart';
import 'package:news_app/features/home/widgets/offline_cache_banner_widget.dart';

class TopHeadlinesSectionHeader extends StatelessWidget {
  const TopHeadlinesSectionHeader({
    super.key,
    required this.isFromCache,
    required this.categoryDisplayName,
  });

  final bool isFromCache;
  final String categoryDisplayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isFromCache) const OfflineCacheBanner(),
        CategoryHeadlineTitle(categoryDisplayName: categoryDisplayName),
      ],
    );
  }
}