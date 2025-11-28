import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/widgets/drawer_body.dart';
import 'package:news_app/features/home/widgets/news_list_view_builder.dart';
import 'package:news_app/features/home/widgets/categories_List_view.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';
import 'package:news_app/features/home/cubit/news_states.dart';
import 'package:news_app/features/home/widgets/search_text_field.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final titleFont = (mq.width * 0.06).clamp(18.0, 28.0);

    return BlocProvider(
      create: (context) => NewsCubit()..getTopHeadlines(category: 'general'),
      child: Builder(
        builder:
            (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  context.read<NewsCubit>().refreshNews();
                },
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
              drawer: Drawer(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DrawerBody(),
              ),
              appBar: AppBar(
                actions: [
                  // Search button
                  IconButton(
                    icon: Icon(isSearching ? Icons.close : Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                      // Clear search when closing
                      if (!isSearching) {
                        searchController.clear();
                        // check if we need to refresh to top headlines
                        if (context.read<NewsCubit>().currentCategory !=
                                'general' ||
                            context.read<NewsCubit>().lastSearchKeyword != '') {
                          context.read<NewsCubit>().getTopHeadlines(
                            category: context.read<NewsCubit>().currentCategory,
                          );
                        }
                      }
                    },
                  ),
                ],
                centerTitle: true,
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      isSearching
                          ? SearchTextField()
                          : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'News',
                                  style: TextStyle(
                                    fontSize: titleFont,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Cloud',
                                  style: TextStyle(
                                    fontSize: titleFont,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: CategoriesListView()),
                    SliverToBoxAdapter(
                      child: BlocBuilder<NewsCubit, NewsState>(
                        builder: (context, state) {
                          String currentCategory = 'general';

                          if (state is FetchTopHeadlinesSuccessState) {
                            currentCategory = state.category;
                          } else if (isSearching &&
                              state is SearchArticlesSuccessState) {
                            currentCategory = state.keyword;
                          } else if (state is FetchByCategorySuccessState) {
                            currentCategory = state.category;
                          } else {
                            currentCategory =
                                context.read<NewsCubit>().currentCategory;
                          }

                          // Safety check for empty string
                          if (currentCategory.isEmpty) {
                            currentCategory = 'general';
                          }

                          String categoryDisplayName =
                              currentCategory[0].toUpperCase() +
                              currentCategory.substring(1);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 16.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Top Headlines in ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  TextSpan(
                                    text: categoryDisplayName,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    NewsListViewBuilder(),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
