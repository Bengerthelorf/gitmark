import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/repository_provider.dart';
import 'services/github_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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