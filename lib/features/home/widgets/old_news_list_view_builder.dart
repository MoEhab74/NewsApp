// List<ArticleModel> articleNewsList = [];
//   bool isLoading = true;
// @override
  // void initState() {
  //   super.initState();
  //   getGeneralNews(); // Trigger the API call to fetch news
  // }

  // This function is used to get the news from the API
  // You can use it in the initState() method to get the news when the widget is created

  // Future<void> getGeneralNews() async {
  //   articleNewsList = await NewsServices(Dio()).getNews();

  //   isLoading = false; // Set loading to false after fetching the news

  //   // Rebuild the widget to show the news
  //   // setState is used to notify the flutter that the state of the widget has changed

  //   setState(() {});
  // }


// return isLoading
    //     ? SliverFillRemaining(
    //       hasScrollBody: false, // Prevents scrolling when loading
    //       child: Center(child: const CircularProgressIndicator()),
    //     )
    //     : articleNewsList.isNotEmpty
    //     ? NewsListView(articleNewsList: articleNewsList)
    //     : SliverFillRemaining(
    //       hasScrollBody: false,
    //       child: Center(
    //         child: Text(
    //           'No news available',
    //           style: TextStyle(fontSize: 18, color: Colors.grey[600]),
    //         ),
    //       ),
    //     );