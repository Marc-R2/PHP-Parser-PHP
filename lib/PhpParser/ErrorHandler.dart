part of '../php_parser.dart';

abstract class ErrorHandler {
  /// Handle an error generated during lexing, parsing or some other operation.
  ///
  /// [error] The error that nedds to be handled
  void handleError(Error error);
}
