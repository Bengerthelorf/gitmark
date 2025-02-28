class Repository {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String defaultBranch;
  final String htmlUrl;
  final bool private;

  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.defaultBranch,
    required this.htmlUrl,
    required this.private,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      defaultBranch: json['default_branch'],
      htmlUrl: json['html_url'],
      private: json['private'],
    );
  }

  // 从URL中提取所有者和仓库名
  static Map<String, String> parseUrl(String url) {
    // 移除尾部的斜杠
    url = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    
    // GitHub URL格式: https://github.com/owner/repo
    Uri uri = Uri.parse(url);
    List<String> pathSegments = uri.pathSegments;
    
    if (pathSegments.length < 2) {
      throw Exception('Invalid GitHub URL');
    }
    
    return {
      'owner': pathSegments[0],
      'repo': pathSegments[1],
    };
  }
}