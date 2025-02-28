import 'package:markdown/markdown.dart' as md;

// 定义内联数学公式语法
class InlineMathSyntax extends md.InlineSyntax {
  InlineMathSyntax() : super(r'\$(.*?)\$');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element('inlineMath', [md.Text(match[1]!)]));
    return true;
  }
}

// 获取扩展集的方法
md.ExtensionSet getMathExtensionSet() {
  // 使用标准的扩展集并添加我们的内联语法
  return md.ExtensionSet(
    [
      const md.FencedCodeBlockSyntax(),
      const md.TableSyntax(),
    ],
    [
      md.InlineHtmlSyntax(),
      md.EmojiSyntax(), 
      md.StrikethroughSyntax(),
      InlineMathSyntax(),
    ],
  );
}