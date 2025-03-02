import 'package:markdown/markdown.dart' as md;

// 定义内联数学公式语法 - 改进匹配正则表达式
class InlineMathSyntax extends md.InlineSyntax {
  // 匹配$...$形式的内联公式，但排除某些误匹配情况
  InlineMathSyntax() : super(r'(?<!\\\$)\$((?:[^\$]|\\\$)+?)\$(?!\$)');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final content = match[1]!.trim();
    parser.addNode(md.Element('inlineMath', [md.Text(content)]));
    return true;
  }
}

// 块级数学公式语法 - 使用自定义的块语法解析器
class BlockMathSyntax extends md.BlockSyntax {
  // 匹配$$ ... $$ 形式的块级公式
  @override
  RegExp get pattern => RegExp(r'^\s*\$\$(.*?)\$\$\s*$', dotAll: true, multiLine: true);

  const BlockMathSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content);
    return match != null;
  }

  @override
  md.Node parse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content);
    if (match == null) {
      return md.Element('p', [md.Text(parser.current.content)]);
    }
    
    final content = match.group(1)?.trim() ?? '';
    parser.advance();
    
    return md.Element('math', [md.Text(content)]);
  }
}

// Markdown语法中使用的传统数学表示法 [...]
class BracketMathSyntax extends md.InlineSyntax {
  BracketMathSyntax() : super(r'\[(.*?)\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final content = match[1]!;
    
    // 检查内容是否为数学表达式
    if (_isMathExpression(content)) {
      parser.addNode(md.Element('inlineMath', [md.Text(content)]));
      return true;
    }
    
    // 不是数学表达式，让其他语法处理
    return false;
  }
  
  // 简单检查是否可能是数学表达式
  bool _isMathExpression(String content) {
    // 检查是否包含常见的数学符号
    final mathSymbols = RegExp(r'\\[a-zA-Z]+|[+\-*/=<>\{\}\[\]\(\)]|\\left|\\right|\\frac|\\int|\\sum|\\lim');
    if (mathSymbols.hasMatch(content)) {
      return true;
    }
    
    // 检查是否包含 \math 开头的命令
    if (content.contains(r'\math')) {
      return true;
    }
    
    // 检查Lambda等特殊符号
    if (content.contains(r'\lambda') || content.contains(r'\Delta')) {
      return true;
    }
    
    return false;
  }
}

// 获取包含数学公式支持的扩展集
md.ExtensionSet getMathExtensionSet() {
  return md.ExtensionSet(
    [
      const md.FencedCodeBlockSyntax(),
      const md.TableSyntax(),
      const BlockMathSyntax(), // 块级数学公式
    ],
    [
      md.InlineHtmlSyntax(),
      md.EmojiSyntax(),
      md.StrikethroughSyntax(),
      InlineMathSyntax(),    // 内联数学公式
      BracketMathSyntax(),   // 括号数学表达式
    ],
  );
}