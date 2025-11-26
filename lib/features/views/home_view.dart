import 'package:flutter/material.dart';
import 'package:news_app/features/home/widgets/news_list_view_builder.dart';
import 'package:news_app/features/home/widgets/categories_List_view.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final titleFont = (mq.width * 0.06).clamp(18.0, 28.0);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News',
              style: TextStyle(
                fontSize: titleFont,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cloud',
              style: TextStyle(
                fontSize: titleFont,
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
