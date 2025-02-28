enum ContentType { file, dir }

class ContentItem {
  final String name;
  final String path;
  final ContentType type;
  final String? downloadUrl;
  final String? htmlUrl;

  ContentItem({
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
    this.htmlUrl,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    ContentType type;
    if (json['type'] == 'file') {
      type = ContentType.file;
    } else {
      type = ContentType.dir;
    }

    return ContentItem(
      name: json['name'],
      path: json['path'],
      type: type,
      downloadUrl: json['download_url'],
      htmlUrl: json['html_url'],
    );
  }

  bool get isMarkdown => 
      type == ContentType.file && 
      (name.toLowerCase().endsWith('.md') || 
       name.toLowerCase().endsWith('.markdown'));
}