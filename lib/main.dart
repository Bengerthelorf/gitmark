import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:logging/logging.dart';
import 'providers/repository_provider.dart';
import 'services/github_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // This sends logs to the console but you can customize this
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
  
  // 初始化服务
  final storageService = StorageService();
  await storageService.init();
  
  final githubService = GitHubService();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryProvider(
            githubService: githubService,
            storageService: storageService,
          ),
        ),
      ],
      child: const GitHubMarkdownApp(),
    ),
  );
}