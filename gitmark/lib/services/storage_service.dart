import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 保存最近访问的仓库
  Future<void> saveRecentRepository(String url) async {
    List<String> recentRepos = getRecentRepositories();
    
    // 如果已存在，先移除
    recentRepos.remove(url);
    
    // 添加到列表开头
    recentRepos.insert(0, url);
    
    // 限制保存的数量
    if (recentRepos.length > 10) {
      recentRepos = recentRepos.sublist(0, 10);
    }
    
    await _prefs.setStringList('recent_repos', recentRepos);
  }

  // 获取最近访问的仓库
  List<String> getRecentRepositories() {
    return _prefs.getStringList('recent_repos') ?? [];
  }

  // 保存上次选择的分支
  Future<void> saveLastBranch(String repoUrl, String branch) async {
    await _prefs.setString('branch_$repoUrl', branch);
  }

  // 获取上次选择的分支
  String? getLastBranch(String repoUrl) {
    return _prefs.getString('branch_$repoUrl');
  }
}