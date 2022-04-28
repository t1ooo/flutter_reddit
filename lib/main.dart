import 'package:draw/draw.dart';
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

  const clientId = 'JmK31vyAOebqCsKrwUticg';
  const secret = 'l2b3p-Ldfm_6rs4qvX16bm9W_0XdPw';
  const username = 'graibn';
  const password = '5"u/#sAJh%=aGo^k(2Kh*&A8ft<l9=29';
  final anonymousReddit = await Reddit.createReadOnlyInstance(
    clientId: clientId,
    clientSecret: secret,
    userAgent: 'Flutter Client',
  );
  final redditApi = RedditApiImpl(anonymousReddit);

  // final redditApi = FakeRedditApi();

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
