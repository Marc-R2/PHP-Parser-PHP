part of '../php_parser.dart';

abstract class Node {
  /// Gets the type of the [Node].
  ///
  /// return [String] Type of the [Node].
  String getType();

  /// Gets the names of the sub nodes.
  ///
  /// return List<String> Names of sub nodes
  List<String> getSubNodeNames();

  /// Gets line the node started in (alias of getStartLine).
  ///
  /// return [int] Start line (or -1 if not available)
  int getLine();

  /// Gets line the node started in.
  ///
  /// Requires the 'startLine' attribute to be
  /// enabled in the lexer (enabled by default).
  ///
  /// return [int] Start line (or -1 if not available)
  int getStartLine();

  /// Gets line the node ended in.
  ///
  /// Requires the 'endLine' attribute to be
  /// enabled in the lexer (enabled by default).
  ///
  /// return [int] End line (or -1 if not available)
  int getEndLine();

  /// Gets the token offset of the first token that is part of this node.
  ///
  /// The offset is an index into the array returned by Lexer::getTokens().
  ///
  /// Requires the 'startTokenPos' attribute to be enabled in the lexer
  /// (DISABLED by default).
  ///
  /// return int Token start position (or -1 if not available)
  int getStartTokenPos();

  /// Gets the token offset of the last token that is part of this node.
  ///
  /// The offset is an index into the array returned by Lexer::getTokens().
  ///
  /// Requires the 'endTokenPos' attribute to be enabled in the lexer
  /// (DISABLED by default).
  ///
  /// return [int] Token end position (or -1 if not available)
  int getEndTokenPos();

  /// Gets the file offset of the first character that is part of this node.
  ///
  /// Requires the 'startFilePos' attribute to be enabled in the lexer
  /// (DISABLED by default).
  ///
  /// return [int] File start position (or -1 if not available)
  int getStartFilePos();

  int getEndFilePos();

  List<Comment> getComments();

  List<Comment> getDocComments();

  void setDocComment(Comment docComment);

  /// Sets an attribute on a node.
  void setAttribute(String key, dynamic value);

  bool hasAttribute(String key);

  dynamic getAttribute(String key, dynamic defaultValue);

  Map<String, dynamic> getAttributes();

  void setAttributes(Map<String, dynamic> attributes);
}
