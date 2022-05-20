import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/notifier/auth_notifier.dart';
import 'src/notifier/collapse_mixin.dart';
import 'src/notifier/comment_notifier.dart';
import 'src/notifier/current_user_notifier.dart';
import 'src/notifier/home_front_notifier.dart';
import 'src/notifier/home_popular_notifier.dart';
import 'src/notifier/iterable_sum.dart';
import 'src/notifier/likable.dart';
import 'src/notifier/limit.dart';
import 'src/notifier/list_notifier.dart';
import 'src/notifier/message_notifier.dart';
import 'src/notifier/property_listener.dart';
import 'src/notifier/replyable.dart';
import 'src/notifier/reportable.dart';
import 'src/notifier/rule_notifier.dart';
import 'src/notifier/savable.dart';
import 'src/notifier/score.dart';
import 'src/notifier/search_notifier.dart';
import 'src/notifier/search_subreddits.dart';
import 'src/notifier/submission_loader_notifier.dart';
import 'src/notifier/submission_notifier.dart';
import 'src/notifier/submissions_notifier.dart';
import 'src/notifier/subreddit_loader_notifier.dart';
import 'src/notifier/subreddit_notifier.dart';
import 'src/notifier/try_mixin.dart';
import 'src/notifier/user_loader_notifier.dart';
import 'src/notifier/user_notifier.dart';
import 'src/reddit_api/reddit_api_fake.dart';
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
