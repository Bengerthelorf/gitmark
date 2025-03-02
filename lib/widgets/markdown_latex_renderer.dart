import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownLatexRenderer extends StatelessWidget {
  final String markdown;

  const MarkdownLatexRenderer({super.key, required this.markdown});

  @override
  Widget build(BuildContext context) {
    // 预处理markdown来适应不同的公式格式
    final processedMarkdown = _preprocessMarkdown(markdown);

    return Markdown(
      data: processedMarkdown,
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
      // 使用flutter_markdown_latex提供的扩展集
      extensionSet: md.ExtensionSet(
        [
          const md.FencedCodeBlockSyntax(),
          const md.TableSyntax(),
          LatexBlockSyntax(), // 块级LaTeX语法
        ],
        [
          md.InlineHtmlSyntax(),
          md.EmojiSyntax(),
          md.StrikethroughSyntax(),
          LatexInlineSyntax(), // 内联LaTeX语法
          _CustomBracketLatexSyntax(), // 自定义方括号LaTeX语法
        ],
      ),
      builders: {
        'latex': LatexElementBuilder(
          textStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      },
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  // 预处理markdown以适应不同的公式格式
  String _preprocessMarkdown(String text) {
    // 1. 替换方括号公式为LaTeX格式
    text = _convertBracketLatexToStandard(text);

    // 2. 确保所有行内的$符号都有正确的空格
    text = _ensureSpacingForInlineMath(text);

    return text;
  }

  // 转换[...] 格式的LaTeX公式为标准格式 $...$
  String _convertBracketLatexToStandard(String text) {
    final bracketPattern = RegExp(r'\[(.*?)\]', dotAll: true);

    return text.replaceAllMapped(bracketPattern, (match) {
      final content = match.group(1)!;

      // 检查内容是否包含LaTeX符号
      if (_containsLatexCommands(content)) {
        // 转换为标准内联LaTeX格式
        return '$content';
      }

      // 不是LaTeX公式，保持原样
      return match.group(0)!;
    });
  }

  // 确保内联公式周围有适当的空格分隔
  String _ensureSpacingForInlineMath(String text) {
    // 确保$符号前后有空格，以便于解析
    return text
        .replaceAllMapped(
          RegExp(r'([^\s])\$(\S)'),
          (match) => '${match.group(1)!} \$${match.group(2)!}',
        )
        .replaceAllMapped(
          RegExp(r'(\S)\$([^\s])'),
          (match) => '${match.group(1)!}\$ ${match.group(2)!}',
        );
  }

  // 检查文本是否包含LaTeX命令
  bool _containsLatexCommands(String text) {
    final latexCommands = [
      r'\lambda',
      r'\alpha',
      r'\beta',
      r'\gamma',
      r'\Delta',
      r'\sum',
      r'\int',
      r'\frac',
      r'\sqrt',
      r'\lim',
      r'\mathbf',
      r'\mathrm',
      r'\cdot',
      r'\infty',
      r'\leq',
      r'\geq',
      r'\mid',
      r'\text',
      r'\quad',
    ];

    for (final cmd in latexCommands) {
      if (text.contains(cmd)) {
        return true;
      }
    }

    return false;
  }
}

// 自定义方括号LaTeX语法，用于解析[...]格式的公式
class _CustomBracketLatexSyntax extends md.InlineSyntax {
  _CustomBracketLatexSyntax() : super(r'\[(.*?)\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final content = match.group(1)!;

    // 检查内容是否包含LaTeX命令
    if (_containsLatexCommands(content)) {
      // 创建LaTeX元素
      parser.addNode(md.Element('latex', [md.Text(content)]));
      return true;
    }

    // 不是LaTeX，让其他语法处理
    return false;
  }

  // 检查内容是否包含LaTeX命令
  bool _containsLatexCommands(String text) {
    final latexCommands = [
      r'\lambda',
      r'\alpha',
      r'\beta',
      r'\gamma',
      r'\Delta',
      r'\sum',
      r'\int',
      r'\frac',
      r'\sqrt',
      r'\lim',
      r'\mathbf',
      r'\mathrm',
      r'\cdot',
      r'\infty',
      r'\leq',
      r'\geq',
      r'\mid',
      r'\text',
      r'\quad',
    ];

    for (final cmd in latexCommands) {
      if (text.contains(cmd)) {
        return true;
      }
    }

    return false;
  }
}
