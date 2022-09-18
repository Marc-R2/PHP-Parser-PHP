part of '../php_parser.dart';

class ConstExprEvaluator {
  late Function(Expr expr) _fallbackEvaluator;

  ConstExprEvaluator(Function(Expr expr)? fallbackEvaluator) {
    _fallbackEvaluator = fallbackEvaluator ?? _defaultFallbackEvaluator;
  }

  dynamic _defaultFallbackEvaluator(Expr expr) {
    throw ConstExprEvaluationException(
        'Cannot evaluate constant expression of type ${expr.runtimeType}');
  }

  dynamic evaluateSilently(Expr expr) {
    // TODO(Marc-R2): set_error_handler !?
    try {
      return evaluate(expr);
    } catch (e) {
      return null;
    }
  }

  dynamic evaluateDirectly(Expr expr) => _evaluate(expr);

  dynamic _evaluate(Expr expr) {
    if (expr is ScalarInt || expr is ScalarFloat || ScalarString) {
      return expr.value;
    }
    if (expr is ExprArray) return evaluateArray(expr);
    // Unary operators
    // TODO(Marc-R2): This might fail
    if (expr is ExprUnaryPlus) return +_evaluate(expr.expr);
    if (expr is ExprUnaryMinus) return -_evaluate(expr.expr);
    if (expr is ExprBooleanNot) return !(_evaluate(expr.expr) as bool);
    if (expr is ExprBitwiseNot) return ~_evaluate(expr.expr);

    if (expr is ExprBinaryOp) return evaluateBinaryOp(expr);
    if (expr is ExprTernary) return evaluateTernary(expr);

    if (expr is ExprArrayDimFetch && expr.dim != null) {
      return _evaluate(expr.variable)[_evaluate(expr.dim)];
    }

    if (expr is ExprConstFetch) return evaluateConstFetch(expr);

    return _fallbackEvaluator(expr);
  }

  List<dynamic> evaluateArray(ExprArray expr) {
    var array = Array();
    for (final item in expr.items) {
      if (item.key != null) {
        array.setKey(_evaluate(item.key), _evaluate(item.value));
      }
      elseif(item.unpack) {
        array = array_merge(array, _evaluate(item.value));
      } else {
    array.add(_evaluate(item.value));
    }
  }
    return
    array;
  }

  dynamic evaluateTernary(ExprTernary expr) {
    if (expr.ifClause == null) {
      return _evaluate(expr.cond) ? _evaluate(expr.elseClause) : null;
    }
    return _evaluate(expr.cond) ? _evaluate(expr.ifClause) : _evaluate(
        expr.elseClause);
  }

  dynamic evaluateBinaryOp(ExprBinaryOp expr) {
    if (expr is ExprBinaryOpCoalesce && expr.left is ExprArrayDimFetch) {
      return _evaluate(expr.left.variable)[_evaluate(expr.left.dim)] ??
          _evaluate(expr.right);
    }

    final left = expr.left;
    final right = expr.right;

    switch (expr.operatorSigil) {
      case '&': return _evaluate(left) & _evaluate(right);
      case '|': return _evaluate(left) | _evaluate(right);
      case '^': return _evaluate(left) ^ _evaluate(right);
      case '&&': return _evaluate(left) as bool && _evaluate(right) as bool;
      case '||': return _evaluate(left) as bool || _evaluate(right) as bool;
      case '??': return _evaluate(left) ?? _evaluate(right);
      case '.': return _evaluate(left).toString() + _evaluate(right).toString();
      case '/': return _evaluate(left) / _evaluate(right);
      case '==': return _evaluate(left) == _evaluate(right);
      case '>': return _evaluate(left) > _evaluate(right);
      case '>=': return _evaluate(left) >= _evaluate(right);
      // TODO(Marc-R2): Copy === behavior from PHP
      case '===': return _evaluate(left) == _evaluate(right);
      case 'and': return _evaluate(left) as bool && _evaluate(right) as bool;
      case 'or': return _evaluate(left) as bool || _evaluate(right) as bool;
      case 'xor': return _evaluate(left) ^ _evaluate(right);
      case '-': return _evaluate(left) - _evaluate(right);
      case '%': return _evaluate(left) % _evaluate(right);
      case '*': return _evaluate(left) * _evaluate(right);
      case '!=': return _evaluate(left) != _evaluate(right);
      // TODO(Marc-R2): Copy !== behavior from PHP
      case '!==': return _evaluate(left) != _evaluate(right);
      case '+': return _evaluate(left) + _evaluate(right);
      case '**': return pow(_evaluate(left) as num, _evaluate(right) as num);
      case '<<': return _evaluate(left) << _evaluate(right);
      case '>>': return _evaluate(left) >> _evaluate(right);
      case '<': return _evaluate(left) < _evaluate(right);
      case '<=': return _evaluate(left) <= _evaluate(right);
      // TODO(Marc-R2): Copy <=> behavior from PHP
      // case '<=>': return _evaluate(left) <=> _evaluate(right);
    }
    throw Exception('Unknown operator ${expr.operatorSigil}');
  }

  dynamic evaluateConstFetch(ExprConstFetch expr) {
    final name = expr.name.toLowerCase();
    switch (name) {
      case 'null': return null;
      case 'false': return false;
      case 'true': return true;
    }
    return _fallbackEvaluator(expr);
  }
}
