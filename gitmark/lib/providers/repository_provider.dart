import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../models/content_item.dart';
import '../services/github_service.dart';
import '../services/storage_service.dart';

class RepositoryProvider extends ChangeNotifier {
  final GitHubService githubService;
  final StorageService storageService;

  RepositoryProvider({
    required this.githubService,
    required this.storageService,
  });

  Repository? _repository;
  Repository? get repository => _repository;

  String _currentBranch = '';
  String get currentBranch => _currentBranch;

  List<String> _branches = [];
  List<String> get branches => _branches;

  String _currentPath = '';
  String get currentPath => _currentPath;

  List<ContentItem> _contents = [];
  List<ContentItem> get contents => _contents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 获取最近访问的仓库
  List<String> getRecentRepositories() {
    return storageService.getRecentRepositories();
  }

  // 加载仓库
  Future<void> loadRepository(String url) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final parsed = Repository.parseUrl(url);
      final owner = parsed['owner']!;
      final repo = parsed['repo']!;

      _repository = await githubService.getRepository(owner, repo);
      _branches = await githubService.getBranches(owner, repo);
      
      // 使用默认分支或上次选择的分支
      String? lastBranch = storageService.getLastBranch(url);
      _currentBranch = lastBranch ?? _repository!.defaultBranch;
      
      // 重置当前路径
      _currentPath = '';
      
      // 加载根目录内容
      await loadContents();
      
      // 保存到最近访问
      await storageService.saveRecentRepository(url);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 切换分支
  Future<void> switchBranch(String branch) async {
    if (_repository != null && branch != _currentBranch) {
      try {
        _isLoading = true;
        _currentBranch = branch;
        notifyListeners();
        
        // 保存所选分支
        await storageService.saveLastBranch(_repository!.htmlUrl, branch);
        
        // 重置当前路径并重新加载内容
        _currentPath = '';
        await loadContents();
        
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // 加载目录内容
  Future<void> loadContents() async {
    if (_repository == null) return;
    
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final parsed = Repository.parseUrl(_repository!.htmlUrl);
      final owner = parsed['owner']!;
      final repo = parsed['repo']!;

      _contents = await githubService.getContents(
        owner,
        repo,
        _currentPath,
        _currentBranch,
      );
      
      // 按类型和名称排序
      _contents.sort((a, b) {
        if (a.type != b.type) {
          return a.type == ContentType.dir ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 导航到目录
  Future<void> navigateToDirectory(String path) async {
    _currentPath = path;
    await loadContents();
  }

  // 导航到上级目录
  Future<void> navigateUp() async {
    if (_currentPath.isEmpty) return;
    
    final lastSlashIndex = _currentPath.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      _currentPath = '';
    } else {
      _currentPath = _currentPath.substring(0, lastSlashIndex);
    }
    
    await loadContents();
  }

  // 获取文件内容
  Future<String> getFileContent(String downloadUrl) async {
    return await githubService.getFileContent(downloadUrl);
  }
}