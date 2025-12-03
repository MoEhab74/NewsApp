import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'package:news_app/features/home/cubit/article_action_cubit.dart';
import 'package:news_app/features/home/cubit/article_action_states.dart';
import 'package:news_app/features/home/widgets/article_action_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCategory extends StatefulWidget {
  const NewsCategory({required this.article, super.key});

  final ArticleModel article;

  @override
  State<NewsCategory> createState() => _NewsCategoryState();
}

class _NewsCategoryState extends State<NewsCategory> {
  bool _isFavorite = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    // Check initial status of the article
    context.read<ArticleActionCubit>().checkArticleStatus(widget.article);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final imageHeight = (mq.height * 0.35).clamp(180.0, 400.0);

    return BlocListener<ArticleActionCubit, ArticleActionState>(
      listener: (context, state) {
        if (state is ArticleStatusState &&
            state.article.url == widget.article.url) {
          setState(() {
            _isFavorite = state.isFavorite;
            _isSaved = state.isSaved;
          });
        } else if (state is FavoriteToggledState &&
            state.article.url == widget.article.url) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
          _newsCategoryNotifiSnackBar(
            context,
            state.isFavorite ? 'Added to favorites' : 'Removed from favorites',
            state.isFavorite ? Colors.green : Colors.orange,
            state,
          );
        } else if (state is SavedToggledState &&
            state.article.url == widget.article.url) {
          setState(() {
            _isSaved = state.isSaved;
          });
          _newsCategoryNotifiSnackBar(
            context,
            state.isSaved ? 'Article saved' : 'Article removed from saved',
            state.isSaved ? Colors.blue : Colors.orange,
            state,
          );
        } else if (state is FavoriteErrorState) {
          _newsCategoryNotifiSnackBar(
            context,
            state.errorMessage,
            Colors.red,
            state,
          );
        } else if (state is SavedErrorState) {
          _newsCategoryNotifiSnackBar(
            context,
            state.errorMessage,
            Colors.red,
            state,
          );
        } else if (state is FavoritesClearedState) {
          setState(() {
            _isFavorite = false;
          });
        } else if (state is SavedArticlesClearedState) {
          setState(() {
            _isSaved = false;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ).copyWith(top: 8.0, bottom: 12.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          // Try to launch the article URL in an external browser
                          final Uri url = Uri.parse(widget.article.url);
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            _newsCategoryNotifiSnackBar(
                              context,
                              'Could not open the article. Please check your internet connection.',
                              Colors.red,
                            );
                          }
                        }
                      },
                      child: Image.network(
                        widget.article.image == null ||
                                widget.article.image!.isEmpty
                            ? 'https://ichef.bbci.co.uk/news/1024/branded_arabic/c82a/live/98939210-432e-11f0-b6e6-4ddb91039da1.png'
                            : widget.article.image!,
                        fit: BoxFit.cover,
                        height: imageHeight,
                        // constrain width so it doesn't span the whole screen on web
                        width: (MediaQuery.of(context).size.width * 0.9).clamp(
                          300.0,
                          MediaQuery.of(context).size.width,
                        ),
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: imageHeight,
                              width: (MediaQuery.of(context).size.width * 0.9)
                                  .clamp(
                                    300.0,
                                    MediaQuery.of(context).size.width,
                                  ),
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: imageHeight,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Action buttons overlay
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    // Favorite button
                    ArticleActionWidget(
                      icon:
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                      onPressed: () {
                        context.read<ArticleActionCubit>().toggleFavorite(
                          widget.article,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Save button
                    ArticleActionWidget(
                      icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: _isSaved ? Colors.blue : Colors.white,
                      onPressed: () {
                        context.read<ArticleActionCubit>().toggleSaved(
                          widget.article,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(
              textAlign: TextAlign.center,
              widget.article.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              textAlign: TextAlign.center,
              widget.article.subTitle ?? "No subTitle available",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void _newsCategoryNotifiSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor, [
  ArticleActionState? state,
]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    ),
  );
}
