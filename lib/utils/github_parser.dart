class GitHubParser {
  // 检查URL是否是有效的GitHub仓库链接
  static bool isValidRepositoryUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host != 'github.com') return false;
      
      final pathSegments = uri.pathSegments;
      return pathSegments.length >= 2;
    } catch (e) {
      return false;
    }
  }

  // 从URL获取所有者和仓库名
  static Map<String, String> parseRepositoryUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    
    if (pathSegments.length < 2) {
      throw Exception('Invalid GitHub repository URL');
    }
    
    return {
      'owner': pathSegments[0],
      'repo': pathSegments[1],
    };
  }

  // 构建文件路径
  static List<String> buildPathSegments(String path) {
    if (path.isEmpty) return [];
    return path.split('/');
  }
}