import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/notifier/auth_notifier.dart';
import 'src/notifier/home_front_notifier.dart';
import 'src/notifier/home_popular_notifier.dart';
import 'src/notifier/search_notifier.dart';
import 'src/notifier/search_subreddits.dart';
import 'src/notifier/submission_loader_notifier.dart';
import 'src/notifier/subreddit_all_notifier.dart';
import 'src/notifier/subreddit_loader_notifier.dart';
import 'src/notifier/user_loader_notifier.dart';
import 'src/reddit_api/auth.dart';
import 'src/reddit_api/reddit_api.dart';
import 'src/reddit_api/reddit_api_fake.dart';
import 'src/reddit_api/reddit_api_impl.dart';
import 'src/submission_tile/media.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);
  initVideoPlayer();

  final redditApi = await createRedditApi();

  runApp(
    MultiProvider(
      providers: [
        Provider<CacheManager>(
          create: (context) => CacheManager(
            Config('flutter_reddit_cache'),
          ),
        ),
        ChangeNotifierProvider<SubmissionLoaderNotifier>(
          create: (context) => SubmissionLoaderNotifier(redditApi),
        ),
        ChangeNotifierProvider<SearchNotifier>(
          create: (context) => SearchNotifier(redditApi),
        ),
        ChangeNotifierProvider<SubredditLoaderNotifier>(
          create: (context) => SubredditLoaderNotifier(redditApi),
        ),
        ChangeNotifierProvider<UserLoaderNotifier>(
          create: (context) => UserLoaderNotifier(redditApi),
        ),
        ChangeNotifierProvider<HomeFrontNotifier>(
          create: (context) => HomeFrontNotifier(redditApi),
        ),
        ChangeNotifierProvider<HomePopularNotifier>(
          create: (context) => HomePopularNotifier(redditApi),
        ),
        ChangeNotifierProvider<SearchSubredditsQ>(
          create: (context) => SearchSubredditsQ(redditApi),
        ),
        ChangeNotifierProvider<SubredditAllNotifier>(
          create: (context) => SubredditAllNotifier(redditApi),
        ),
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) {
            final notifier = AuthNotifier(redditApi);
            return notifier
              ..addListener(() {
                if (notifier.user == null) {
                  context.read<SubmissionLoaderNotifier>().reset();
                  context.read<SearchNotifier>().reset();
                  context.read<SubredditLoaderNotifier>().reset();
                  context.read<UserLoaderNotifier>().reset();
                  context.read<HomeFrontNotifier>().reset();
                  context.read<HomePopularNotifier>().reset();
                  context.read<SearchSubredditsQ>().reset();
                  context.read<SubredditAllNotifier>().reset();
                }
              });
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<RedditApi> createRedditApi() async {
  final clientId = const String.fromEnvironment('CLIENT_ID');
  final redirectUri =
      Uri.tryParse(const String.fromEnvironment('REDIRECT_URI'));
  if (clientId != '' && redirectUri != null) {
    print('use reddit api');
    final credentials = Credentials(
        File((await getTemporaryDirectory()).path + '/credentials.json'));
    return RedditApiImpl(clientId, redirectUri, credentials);
  }

  print('use fake reddit api');
  return FakeRedditApi();
}

void configureLogger(bool debugMode) {
  baseConfigure();
  setLevel(debugMode ? Level.ALL : Level.WARNING);

  onLogRecord((LogRecord record) {
    // ignore: avoid_print
    print(
      '${record.level.name}: '
      '${record.time}: '
      '${record.loggerName}: '
      '${record.message} '
      '${record.error != null ? '${record.error} ' : ''}'
      '${record.stackTrace != null ? '${record.stackTrace}' : ''}',
    );
  });
}
