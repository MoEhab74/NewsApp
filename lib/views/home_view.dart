import 'package:flutter/material.dart';
import 'package:news_app/Widgets/news_list_view_builder.dart';
import 'package:news_app/Widgets/categories_List_view.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cloud',
              style: TextStyle(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: CategoriesListView()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            NewsListViewBuilder(
              category: 'general', // You can change the category here
            ),
            // SliverToBoxAdapter(child: NewsListView()), // Less performance
          ],
        ),
      ),
    );
  }
}



// SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Column(
//             children: [
//               CategoriesListView(),
//               const SizedBox(
//                 height: 20,
//               ),
//                NewsListView(),
//                ]
//                ),
//         ),
//       ),
