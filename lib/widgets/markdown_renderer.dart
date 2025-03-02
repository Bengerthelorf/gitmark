import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart'; // 添加LaTeX支持
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';

class MarkdownRenderer extends StatelessWidget {
  final String markdown;
  final bool enableImages; // 添加控制图片加载的选项

  static final _logger = Logger('MarkdownRenderer');

  const MarkdownRenderer({
    super.key,
    required this.markdown,
    this.enableImages = true, // 默认启用图片
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdown,
      selectable: true,
      imageDirectory: 'https://raw.githubusercontent.com',
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        h1: Theme.of(context).textTheme.headlineMedium,
        h2: Theme.of(context).textTheme.headlineSmall,
        h3: Theme.of(context).textTheme.titleLarge,
        h4: Theme.of(context).textTheme.titleMedium,
        h5: Theme.of(context).textTheme.titleSmall,
        h6: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        p: Theme.of(context).textTheme.bodyMedium,
        code: Theme.of(context).textTheme.bodySmall?.copyWith(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          fontFamily: 'monospace',
          fontSize: 14,
        ),
        codeblockDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 4,
            ),
          ),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
      ),
      // 使用LaTeX扩展集
      extensionSet: md.ExtensionSet(
        [
          const md.FencedCodeBlockSyntax(),
          const md.TableSyntax(),
          LatexBlockSyntax(), // 添加块级LaTeX语法
        ],
        [
          md.InlineHtmlSyntax(),
          md.EmojiSyntax(),
          md.StrikethroughSyntax(),
          LatexInlineSyntax(), // 添加内联LaTeX语法
        ],
      ),
      builders: {
        'inlineMath': InlineMathBuilder(),
        'math': MathBuilder(),
        'latex': LatexElementBuilder(
          textStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        'img': SafeImageBuilder(
          // 添加安全的图片构建器
          enableImages: enableImages,
          context: context,
        ),
      },
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}

// 内联数学公式构建器
class InlineMathBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String texContent = element.textContent;

    return Math.tex(
      texContent,
      textStyle: preferredStyle,
      mathStyle: MathStyle.text,
    );
  }
}

// 块级数学公式构建器
class MathBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String texContent = element.textContent;

    // 删除所有换行符
    final cleanedTexContent = texContent.replaceAll('\n', ' ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OverflowBox(
        maxWidth: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Math.tex(
            cleanedTexContent,
            textStyle: preferredStyle,
            mathStyle: MathStyle.display,
          ),
        ),
      ),
    );
  }
}

/// 添加安全的图片构建器，能够处理加载错误和禁用图片
class SafeImageBuilder extends MarkdownElementBuilder {
  final bool enableImages;
  final BuildContext context;
  static final _logger = Logger('SafeImageBuilder');

  SafeImageBuilder({required this.enableImages, required this.context});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? textStyle) {
    final String? src = element.attributes['src'];
    final String? alt = element.attributes['alt'];

    if (src == null) {
      return Text('Missing image source', style: TextStyle(color: Colors.red));
    }

    // 如果禁用了图片加载，显示占位符
    if (!enableImages) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image, color: Colors.grey),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(alt ?? 'Image loading disabled', style: textStyle),
            ),
          ],
        ),
      );
    }

    // 尝试修复相对路径
    String imageUrl = src;
    if (!imageUrl.startsWith('http')) {
      _logger.info('Fixed relative image path: $src');
    }

    return Image.network(
      imageUrl,
      semanticLabel: alt,
      errorBuilder: (context, error, stackTrace) {
        _logger.warning('Failed to load image: $imageUrl, Error: $error');
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.red.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.broken_image, color: Colors.red.shade300),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Image failed to load',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (alt != null) ...[
                const SizedBox(height: 4.0),
                Text('Alt text: $alt', style: textStyle),
              ],
              const SizedBox(height: 4.0),
              Text(
                'Source: $imageUrl',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                  strokeWidth: 2.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(alt ?? 'Loading image...', style: textStyle),
              ),
            ],
          ),
        );
      },
    );
  }
}
