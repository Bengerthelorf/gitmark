import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:logging/logging.dart';

final _mathLogger = Logger('MathRenderer');

/// 尝试渲染数学公式，并记录任何错误
Widget tryRenderMath(
  String texString, {
  TextStyle? textStyle,
  MathStyle mathStyle = MathStyle.text,
}) {
  try {
    return Math.tex(
      texString,
      textStyle: textStyle,
      mathStyle: mathStyle,
      onErrorFallback: (exception) {
        _mathLogger.warning('Failed to render math: $texString, Error: $exception');
        return Text(
          texString,
          style: textStyle?.copyWith(
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        );
      },
    );
  } catch (e) {
    _mathLogger.severe('Exception in math renderer: $e');
    return Text(
      texString,
      style: textStyle?.copyWith(
        color: Colors.red,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

/// 分析Markdown文件中的数学公式并记录
void analyzeMathFormulas(String markdownText) {
  // 查找内联公式 ($...$)
  final inlinePattern = RegExp(r'\$(.*?)\$', dotAll: true);
  final inlineMatches = inlinePattern.allMatches(markdownText);
  
  _mathLogger.info('Found ${inlineMatches.length} inline math formulas');
  for (final match in inlineMatches.take(5)) {
    _mathLogger.info('Inline formula: ${match.group(1)}');
  }
  
  // 查找块级公式 ($$...$$)
  final blockPattern = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
  final blockMatches = blockPattern.allMatches(markdownText);
  
  _mathLogger.info('Found ${blockMatches.length} block math formulas');
  for (final match in blockMatches.take(5)) {
    _mathLogger.info('Block formula: ${match.group(1)}');
  }
  
  // 查找方括号公式 ([...])
  final bracketPattern = RegExp(r'\[(.*?)\]', dotAll: true);
  final bracketMatches = bracketPattern.allMatches(markdownText);
  
  _mathLogger.info('Found ${bracketMatches.length} potential bracket formulas');
  for (final match in bracketMatches.take(5)) {
    _mathLogger.info('Bracket content: ${match.group(1)}');
  }
}