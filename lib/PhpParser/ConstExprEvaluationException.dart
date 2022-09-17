part of '../php_parser.dart';

class ConstExprEvaluationException implements Exception {
  final dynamic message;

  ConstExprEvaluationException([this.message]);

  @override
  String toString() {
    if (message == null) return 'ConstExprEvaluationException';
    return 'ConstExprEvaluationException: $message';
  }
}
