import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/app.dart';
import 'src/notifier/reddir_notifier.v4_2.dart';
import 'src/reddit_api/auth.dart';
import 'src/reddit_api/reddir_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configureLogger(kDebugMode);

  // move to env
  // final credentials = Credentials(File((await getTemporaryDirectory()).path + '/credentials.json'));
  // final clientId = 'Qg2iboouRpvW_CrGzfxprA';
  // final redirectUri = Uri.parse('http://127.0.0.1:6565/flutter_app_callback');
  // final redditApi = RedditApiImpl(clientId, redirectUri, credentials);
  // await redditApi.loginSilently('', '');
  final redditApi = FakeRedditApi();

  runApp(
    MultiProvider(
      providers: [
        Provider<CacheManager>(
          create: (context) => CacheManager(
            Config('flutter_reddit_cache'),
          ),
        ),
        ChangeNotifierProvider<SubmissionLoaderNotifierQ>(
          create: (context) => SubmissionLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<SearchNotifierQ>(
          create: (context) => SearchNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<SubredditLoaderNotifierQ>(
          create: (context) => SubredditLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<UserLoaderNotifierQ>(
          create: (context) => UserLoaderNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<UserAuth>(
          create: (context) => UserAuth(redditApi),
        ),
        ChangeNotifierProvider<HomeFrontNotifierQ>(
          create: (context) => HomeFrontNotifierQ(redditApi),
        ),
        ChangeNotifierProvider<HomePopularNotifierQ>(
          create: (context) => HomePopularNotifierQ(redditApi),
        ),
      ],
      child: MyApp(),
    ),
  );
}
