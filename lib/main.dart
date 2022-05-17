import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/notifier/reddir_notifier.v4_2.dart';
import 'src/reddit_api/reddir_api.dart';
import 'src/submission_tile/media.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);
  initVideoPlayer();

  // TODO: move to env
  // final credentials = Credentials(
  //     File((await getTemporaryDirectory()).path + '/credentials.json'));
  // final clientId = 'Qg2iboouRpvW_CrGzfxprA';
  // final redirectUri = Uri.parse('http://127.0.0.1:6565/flutter_app_callback');
  // final redditApi = RedditApiImpl(clientId, redirectUri, credentials);

  final redditApi = FakeRedditApi();

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
        ChangeNotifierProvider<UserAuth>(
          create: (context) {
            final notifier = UserAuth(redditApi);
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
                }
              });
          },
        ),
      ],
      child: MyApp(),
    ),
  );
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
