import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import '../utils/markdown_extensions.dart';

class MarkdownRenderer extends StatelessWidget {
  final String markdown;

  const MarkdownRenderer({
    super.key,  // 修复 super parameter
    required this.markdown,
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
        h6: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        p: Theme.of(context).textTheme.bodyMedium,
        code: Theme.of(context).textTheme.bodySmall?.copyWith(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,  // 修复弃用属性
          fontFamily: 'monospace',
          fontSize: 14,
        ),
        codeblockDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,  // 修复弃用属性
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
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
        ),
      ),
      extensionSet: getMathExtensionSet(), // 使用自定义的方法
      builders: {
        'math': MathBuilder(),
        'inlineMath': InlineMathBuilder(),
      },
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}

class MathBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {  // 修复参数名
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
            textStyle: preferredStyle,  // 修复参数名
            mathStyle: MathStyle.display,
          ),
        ),
      ),
    );
  }
}

class InlineMathBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {  // 修复参数名
    final String texContent = element.textContent;
    
    return Math.tex(
      texContent,
      textStyle: preferredStyle,  // 修复参数名
      mathStyle: MathStyle.text,
    );
  }
}