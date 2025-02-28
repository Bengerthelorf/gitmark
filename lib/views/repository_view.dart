import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_item.dart';
import '../providers/repository_provider.dart';
// import '../utils/github_parser.dart';
import '../widgets/branch_selector.dart';
import '../widgets/path_navigator.dart';
import 'markdown_view.dart';

class RepositoryView extends StatelessWidget {
  const RepositoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepositoryProvider>(context);
    final repository = provider.repository;
    
    if (repository == null) {
      return const Scaffold(
        body: Center(child: Text('仓库未加载')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        actions: [
          BranchSelector(
            branches: provider.branches,
            currentBranch: provider.currentBranch,
            onBranchSelected: (branch) {
              provider.switchBranch(branch);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 路径导航
          PathNavigator(
            path: provider.currentPath,
            onNavigate: (path) {
              provider.navigateToDirectory(path);
            },
            onNavigateUp: () {
              provider.navigateUp();
            },
          ),
          // 内容列表
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                    ? Center(
                        child: Text(
                          '错误: ${provider.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.contents.length,
                        itemBuilder: (context, index) {
                          final item = provider.contents[index];
                          return ListTile(
                            leading: Icon(
                              item.type == ContentType.dir
                                  ? Icons.folder
                                  : item.isMarkdown
                                      ? Icons.description
                                      : Icons.insert_drive_file,
                              color: item.type == ContentType.dir
                                  ? Colors.amber
                                  : item.isMarkdown
                                      ? Colors.blue
                                      : Colors.grey,
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: item.type == ContentType.dir
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () async {
                              if (item.type == ContentType.dir) {
                                provider.navigateToDirectory(item.path);
                              } else if (item.isMarkdown && item.downloadUrl != null) {
                                // 导航到Markdown查看器
                                final content = await provider.getFileContent(
                                  item.downloadUrl!,
                                );
                                
                                if (!context.mounted) return;
                                
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MarkdownView(
                                      title: item.name,
                                      content: content,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}