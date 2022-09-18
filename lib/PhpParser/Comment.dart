part of '../php_parser.dart';

@JsonSerializable()
class Comment {
  /// Constructs a comment node.
  ///
  /// [text] Comment text (including comment delimiters like /*)
  ///
  /// [startLine] Line the comment started in
  ///
  /// [startFilePos] File offset the comment started in
  ///
  /// [startTokenPos] Token offset the comment started in
  ///
  /// [endLine] Line the comment ended in
  ///
  /// [endFilePos] File offset the comment ended in
  ///
  /// [endTokenPos] Token offset the comment ended in
  Comment({
    required String text,
    int startLine = -1,
    int startFilePos = -1,
    int startTokenPos = -1,
    int endLine = -1,
    int endFilePos = -1,
    int endTokenPos = -1,
  }) {
    this._text = text;
    this._startLine = startLine;
    this._startFilePos = startFilePos;
    this._startTokenPos = startTokenPos;
    this._endLine = endLine;
    this._endFilePos = endFilePos;
    this._endTokenPos = endTokenPos;
  }

  late String _text;
  late int _startLine;
  late int _startFilePos;
  late int _startTokenPos;
  late int _endLine;
  late int _endFilePos;
  late int _endTokenPos;

  String get text => _text;

  int get startLine => _startLine;

  int get startFilePos => _startFilePos;

  int get startTokenPos => _startTokenPos;

  int get endLine => _endLine;

  int get endFilePos => _endFilePos;

  int get endTokenPos => _endTokenPos;

  int get line => _startLine;

  int get filePos => _startFilePos;

  int get tokenPos => _startTokenPos;

  @override
  String toString() => _text;

  String getReformattedText() {
    final text = _text;
    final newlinePos = text.indexOf('\n');
    if (newlinePos == -1) return text;
    if (text.contains(r'((*BSR_ANYCRLF)(*ANYCRLF)^.*(?:\R\s+\*.*)+$)')) {
      // Multi line comment of the type
      //
      //     /*
      //      * Some text.
      //      * Some more text.
      //      */
      //
      // is handled by replacing the whitespace sequences before the * by a single space
      return text.replaceAll(r'(^\s+\*)m', ' *');
    }
    if (text.contains(r'(^/\*\*?\s*[\r\n])') &&
        text.contains(r'(\n(\s*)\*/$)')) {
      final matches = text.allMatches(r'(\n(\s*)\*/$)').toList();
      // '(^' . preg_quote($matches[1]) . ')m'
      final pattern = '(^ ${matches[1].toString()})m';
      return text.replaceAll(pattern, '');
    }
    if (text.contains(r'(^/\*\*?\s*(?!\s))')) {
      final matches = text.allMatches(r'(^/\*\*?\s*(?!\s))').toList();
      final prefixLen =
          _getShortestWhitespacePrefixLen(text.substring(newlinePos + 1));
      final removeLen = prefixLen - matches[0].toString().length;
      return text.replaceAll(r'(^\s{' '$removeLen})m', '');
    }
    return text;
  }

  int _getShortestWhitespacePrefixLen(String text) {
    final lines = text.split('\n');
    var shortestPrefixLen = double.infinity;
    for (final line in lines) {
      final matches = line.allMatches(r'(^\s*)').toList();
      final prefixLen = matches[0].toString().length;
      if (prefixLen < shortestPrefixLen) {
        shortestPrefixLen = prefixLen.toDouble();
      }
    }
    return shortestPrefixLen.toInt();
  }

  @override
  Map<String, dynamic> toJson() => {
        'nodeType': this is DocComment ? 'DocComment' : 'Comment',
        'text': _text,
        'startLine': _startLine,
        'startFilePos': _startFilePos,
        'startTokenPos': _startTokenPos,
        'endLine': _endLine,
        'endFilePos': _endFilePos,
        'endTokenPos': _endTokenPos,
      };
}
