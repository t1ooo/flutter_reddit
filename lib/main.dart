import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/app.dart';
import 'src/notifier/reddir_notifier.dart';
import 'src/provider.dart';
import 'src/reddit_api/reddir_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configureLogger(kDebugMode);

  runApp(
    MultiProvider(
      providers: [
        // _redditNotifierProvider,
        // _redditNotifierFrontProvider,
        await fakeRedditApiProvider(),
        redditNotifierProvider(),
        submissionTypeNotifierProvider(),
        sortNotifierProvider(),
        currentUserNotifierProvider(),
        // submissionNotifierProvider(),
        ChangeNotifierProvider<FrontSubmissionsNotifier>(
          create: (BuildContext context) =>
              FrontSubmissionsNotifier(context.read<RedditApi>()),
        ),
        ChangeNotifierProvider<PopularSubmissionsNotifier>(
          create: (BuildContext context) =>
              PopularSubmissionsNotifier(context.read<RedditApi>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}
