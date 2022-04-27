import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/app.dart';
import 'src/notifier/reddir_notifier.v4_2.dart';
import 'src/reddit_api/reddir_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);

  final redditApi = FakeRedditApi();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SubmissionLoaderNotifierQ>(
          create: (BuildContext context) =>
              SubmissionLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<SearchNotifierQ>(
          create: (BuildContext context) => SearchNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<SubredditLoaderNotifierQ>(
          create: (BuildContext context) => SubredditLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<UserLoaderNotifierQ>(
          create: (BuildContext context) => UserLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<UserAuth>(
          create: (BuildContext context) => UserAuth(redditApi),
        ),
        ChangeNotifierProvider<HomeFrontNotifierQ>(
          create: (BuildContext context) => HomeFrontNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<HomePopularNotifierQ>(
          create: (BuildContext context) => HomePopularNotifierQ(redditApi),
        ),
      ],
      child: MyApp(),
    ),
  );
}
