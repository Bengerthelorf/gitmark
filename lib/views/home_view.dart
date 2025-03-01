import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/repository_provider.dart';
import '../utils/github_parser.dart';
import 'repository_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadRepository() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 先检查网络连接
        final repositoryProvider = Provider.of<RepositoryProvider>(
          context, 
          listen: false,
        );
        
        // 尝试加载仓库
        await repositoryProvider.loadRepository(_urlController.text);
        
        if (!mounted) return;
        
        if (repositoryProvider.errorMessage == null) {
          // 导航到仓库视图
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RepositoryView(),
            ),
          );
        } else {
          // 显示详细错误信息
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('加载错误'),
              content: Text(repositoryProvider.errorMessage!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('错误'),
              content: Text('无法加载仓库: ${e.toString()}\n\n请确保应用有网络访问权限'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentRepos = Provider.of<RepositoryProvider>(context)
        .getRecentRepositories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Markdown Reader'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: '输入GitHub仓库链接',
                      hintText: 'https://github.com/username/repository',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.link_outlined,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入GitHub仓库链接';
                      }
                      if (!GitHubParser.isValidRepositoryUrl(value)) {
                        return '请输入有效的GitHub仓库链接';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loadRepository,
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              // 确保加载指示器颜色与文本颜色匹配
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
                            Icons.search_outlined,
                            // 确保图标颜色与文本颜色匹配
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    label: Text(
                      '打开仓库',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      // 添加一点视觉效果
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
            if (recentRepos.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Text(
                '最近访问',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: recentRepos.length,
                  itemBuilder: (context, index) {
                    final repo = recentRepos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          repo.replaceFirst('https://github.com/', ''),
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Icon(Icons.history_outlined, 
                            color: Theme.of(context).colorScheme.secondary),
                        trailing: Icon(Icons.arrow_forward_ios, 
                            size: 16, 
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                        onTap: () {
                          _urlController.text = repo;
                          _loadRepository();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}