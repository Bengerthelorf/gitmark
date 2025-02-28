import 'package:flutter/material.dart';
import '../utils/github_parser.dart';

class PathNavigator extends StatelessWidget {
  final String path;
  final Function(String) onNavigate;
  final VoidCallback onNavigateUp;

  const PathNavigator({
    super.key,
    required this.path,
    required this.onNavigate,
    required this.onNavigateUp,
  });

  @override
  Widget build(BuildContext context) {
    final pathSegments = GitHubParser.buildPathSegments(path);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: '根目录',
            onPressed: path.isEmpty
                ? null
                : () => onNavigate(''),
          ),
          if (path.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              tooltip: '上级目录',
              onPressed: onNavigateUp,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '/',
                    style: TextStyle(
                      fontWeight: pathSegments.isEmpty
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  ...List.generate(pathSegments.length, (index) {
                    final segment = pathSegments[index];
                    final currentPath = pathSegments
                        .sublist(0, index + 1)
                        .join('/');
                    
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: index == pathSegments.length - 1
                              ? null
                              : () => onNavigate(currentPath),
                          child: Text(
                            segment,
                            style: TextStyle(
                              fontWeight: index == pathSegments.length - 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (index < pathSegments.length - 1)
                          const Text('/'),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}