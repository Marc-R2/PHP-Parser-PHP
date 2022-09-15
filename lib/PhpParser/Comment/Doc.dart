part of '../../php_parser.dart';

class Doc extends Comment {
  Doc({
    required super.text,
    super.startLine = -1,
    super.startFilePos = -1,
    super.startTokenPos = -1,
    super.endLine = -1,
    super.endFilePos = -1,
    super.endTokenPos = -1,
  });
}
