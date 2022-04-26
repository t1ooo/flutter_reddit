import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/app.dart';
// import 'src/notifier/reddir_notifier.dart';
import 'src/notifier/reddir_notifier.v4_2.dart';
// import 'src/provider.dart';
import 'src/reddit_api/reddir_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configureLogger(kDebugMode);

  final redditApi = FakeRedditApi();

  runApp(
    MultiProvider(
      providers: [
        // _redditNotifierProvider,
        // _redditNotifierFrontProvider,
        // await fakeRedditApiProvider(),
        // redditNotifierProvider(),
        // submissionTypeNotifierProvider(),
        // sortNotifierProvider(),
        // currentUserNotifierProvider(),
        // submissionNotifierProvider(),
        // ChangeNotifierProvider<FrontSubmissionsNotifier>(
        //   create: (BuildContext context) =>
        //       FrontSubmissionsNotifier(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<PopularSubmissionsNotifier>(
        //   create: (BuildContext context) =>
        //       PopularSubmissionsNotifier(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<SearchSubmissionsNotifier>(
        //   create: (BuildContext context) =>
        //       SearchSubmissionsNotifier(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<UserSubmissionsNotifier>(
        //   create: (BuildContext context) =>
        //       UserSubmissionsNotifier(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<UserCommentsNotifier>(
        //   create: (BuildContext context) =>
        //       UserCommentsNotifier(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<UserNotifier>(
        //   create: (BuildContext context) =>
        //       UserNotifier(context.read<RedditApi>()),
        // ),
        
        
        // Provider.value(value: redditApi),
        // ChangeNotifierProvider<SubmissionLoaderNotifierQ>(
        //   create: (BuildContext context) =>
        //       SubmissionLoaderNotifierQ(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<SearchNotifierQ>(
        //   create: (BuildContext context) =>
        //       SearchNotifierQ(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<SubredditLoaderNotifierQ>(
        //   create: (BuildContext context) =>
        //       SubredditLoaderNotifierQ(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<UserNotifierQ>(
        //   create: (BuildContext context) =>
        //       UserNotifierQ(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<CurrentUserNotifierQ>(
        //   create: (BuildContext context) =>
        //       CurrentUserNotifierQ(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<HomeFrontNotifierQ>(
        //   create: (BuildContext context) =>
        //       HomeFrontNotifierQ(context.read<RedditApi>()),
        // ),
        // ChangeNotifierProvider<HomePopularNotifierQ>(
        //   create: (BuildContext context) =>
        //       HomePopularNotifierQ(context.read<RedditApi>()),
        // ),

 
        ChangeNotifierProvider<SubmissionLoaderNotifierQ>(
          create: (BuildContext context) =>
              SubmissionLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<SearchNotifierQ>(
          create: (BuildContext context) =>
              SearchNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<SubredditLoaderNotifierQ>(
          create: (BuildContext context) =>
              SubredditLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<UserLoaderNotifierQ>(
          create: (BuildContext context) =>
              UserLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<UserAuth>(
          create: (BuildContext context) =>
              UserAuth(redditApi),
        ),
        ChangeNotifierProvider<HomeFrontNotifierQ>(
          create: (BuildContext context) =>
              HomeFrontNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<HomePopularNotifierQ>(
          create: (BuildContext context) =>
              HomePopularNotifierQ(redditApi),
        ),

      ],
      child: MyApp(),
    ),
  );
}
