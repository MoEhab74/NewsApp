import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/ui/custom_indicator.dart';
import 'package:news_app/core/ui/error_message.dart';
import 'package:news_app/features/home/widgets/news_list_view.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'package:news_app/features/home/cubit/news_cubit.dart';
import 'package:news_app/features/home/cubit/news_states.dart';

class NewsListViewBuilder extends StatelessWidget {
  const NewsListViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state is NewsErrorState ||
            state is FetchTopHeadlinesErrorState ||
            state is FetchByCategoryErrorState ||
            state is SearchArticlesErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getErrorMessage(state)),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is FetchTopHeadlinesSuccessState ||
            state is FetchByCategorySuccessState ||
            state is SearchArticlesSuccessState ||
            state is NewsSuccessState) {
          List<ArticleModel> articles = _getArticlesFromState(state);
          return NewsListView(articleNewsList: articles);
        } else if (state is FetchTopHeadlinesErrorState ||
            state is FetchByCategoryErrorState ||
            state is SearchArticlesErrorState ||
            state is NewsErrorState) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: ErrorMessage(errorMessage: _getErrorMessage(state)),
            ),
          );
        } else if (state is FetchTopHeadlinesLoadingState ||
            state is FetchByCategoryLoadingState ||
            state is SearchArticlesLoadingState ||
            state is NewsLoadingState) {
          return SliverFillRemaining(
            hasScrollBody: false, // Prevents scrolling when loading
            child: Center(child: CustomIndicator()),
          );
        } else {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select a category to view news',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NewsCubit>().getTopHeadlines(
                        category: 'general',
                      );
                    },
                    child: const Text('Load General News'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  List<ArticleModel> _getArticlesFromState(NewsState state) {
    if (state is FetchTopHeadlinesSuccessState) {
      return state.articles;
    } else if (state is SearchArticlesSuccessState) {
      return state.articles;
    } else if (state is FetchByCategorySuccessState) {
      return state.articles;
    } else if (state is NewsSuccessState) {
      return state.articles;
    }
    return [];
  }

  String _getErrorMessage(NewsState state) {
    if (state is FetchTopHeadlinesErrorState) {
      return state.errorMessage;
    } else if (state is FetchByCategoryErrorState) {
      return state.errorMessage;
    } else if (state is SearchArticlesErrorState) {
      return state.errorMessage;
    } else if (state is NewsErrorState) {
      return state.errorMessage;
    }
    return 'An unexpected error occurred';
  }
}
