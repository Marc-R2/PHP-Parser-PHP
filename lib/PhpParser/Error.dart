part of '../php_parser.dart';

class Error implements Exception {
  String message = '';

  String _rawMessage;

  Map<String, dynamic> _attributes;

  Error(String message, [Map<String, dynamic> attributes = const {}])
      : _rawMessage = message,
        _attributes = attributes {
    updateMessage();
  }

  String get rawMessage => _rawMessage;

  int get startLine => (_attributes['startLine'] as int?) ?? -1;

  int get endLine => (_attributes['endLine'] as int?) ?? -1;

  Map<String, dynamic> get attributes => _attributes;

  set attributes(Map<String, dynamic> attributes) {
    _attributes = attributes;
    updateMessage();
  }

  set rawMessage(String message) {
    _rawMessage = message;
    updateMessage();
  }

  set startLine(int line) {
    _attributes['startLine'] = line;
    updateMessage();
  }

  bool get hasColumnInfo =>
      _attributes.containsKey('startFilePos') &&
      _attributes.containsKey('endFilePos');

  int getStartColumn(String code) {
    if (!hasColumnInfo) {
      throw Exception('Error does not have column information');
    }
    return toColumn(code, _attributes['startFilePos'] as int);
  }

  int getEndColumn(String code) {
    if (!hasColumnInfo) {
      throw Exception('Error does not have column information');
    }

    return toColumn(code, _attributes['endFilePos'] as int);
  }

  String getMessageWithColumnInfo(String code) => '$rawMessage from '
      '$startLine:${getStartColumn(code)} to '
      '$endLine:${getEndColumn(code)}';

  int toColumn(String code, int pos) {
    if (pos > code.length) throw Exception('Invalid position information');
    final lineStartPos = code.lastIndexOf('\n', pos - code.length);
    return pos - lineStartPos;
  }

  void updateMessage() {
    message = rawMessage;
    message += startLine == -1 ? ' on unknown line' : ' on line $startLine';
  }
}
