import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/app.dart';
import 'src/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);

  final _redditNotifierProvider = await redditNotifierProvider();
  // final _redditNotifierFrontProvider = await redditNotifierFrontProvider();
  runApp(
    MultiProvider(
      providers: [
        _redditNotifierProvider,
        // _redditNotifierFrontProvider,
        submissionTypeNotifierProvider(),
      ],
      child: MyApp(),
    ),
  );
}
