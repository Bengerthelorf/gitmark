import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../widgets/markdown_renderer.dart';

class MarkdownView extends StatefulWidget {
  final String title;
  final String content;

  const MarkdownView({super.key, required this.title, required this.content});

  @override
  State<MarkdownView> createState() => _MarkdownViewState();
}

class _MarkdownViewState extends State<MarkdownView> {
  final _logger = Logger('MarkdownView');
  bool _debugMode = false;
  bool _imagesEnabled = true; // 默认启用图片

  @override
  void initState() {
    super.initState();
    _logger.info('Loading markdown with title: ${widget.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // 添加图片开关按钮
          IconButton(
            icon: Icon(
              _imagesEnabled ? Icons.image : Icons.image_not_supported,
            ),
            tooltip: _imagesEnabled ? '禁用图片' : '启用图片',
            onPressed: () {
              setState(() {
                _imagesEnabled = !_imagesEnabled;
                _logger.info(
                  'Images ${_imagesEnabled ? "enabled" : "disabled"}',
                );
              });
            },
          ),
          // 调试按钮
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: '切换调试模式',
            onPressed: () {
              setState(() {
                _debugMode = !_debugMode;
                _logger.info('Debug mode: $_debugMode');

                if (_debugMode) {
                  // 输出更多调试信息
                  _logger.info(
                    'Document content length: ${widget.content.length}',
                  );
                  final previewLength =
                      widget.content.length > 100 ? 100 : widget.content.length;
                  _logger.info(
                    'First $previewLength chars: ${widget.content.substring(0, previewLength)}',
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 使用修改后的MarkdownRenderer，传入图片启用状态
          MarkdownRenderer(
            markdown: widget.content,
            enableImages: _imagesEnabled,
          ),

          // 调试信息覆盖层
          if (_debugMode)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.withOpacity(0.7),
                child: const Text(
                  'DEBUG',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // 图片禁用提示
          if (!_imagesEnabled)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '图片加载已禁用',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
