part of '../php_parser.dart';

class BuilderFactory {
  NodeAttribute attribute(dynamic name, [Array args = const Array()]) {
    return NodeAttribute(
      BuilderHelpers.normalizeName(name),
      this.args(args),
    );
  }

  BuilderNamespace namespace(dynamic name) => BuilderNamespace(name);

  BuilderClass classClass(String name) => BuilderClass(name);

  BuilderInterface interface(String name) => BuilderInterface(name);

  BuilderTrait trait(String name) => BuilderTrait(name);

  BuilderEnum enumClass(String name) => BuilderEnum(name);

  BuilderTraitUse useTrait(List<dynamic> traits) => BuilderTraitUse(traits);

  BuilderTraitUseAdaptation traitUseAdaptation(dynamic trait, dynamic method) {
    if (method == null) {
      method = trait;
      trait = null;
    }
    return BuilderTraitUseAdaptation(trait, method);
  }

  BuilderMethod method(String name) => BuilderMethod(name);

  BuilderParam param(String name) => BuilderParam(name);

  BuilderProperty property(String name) => BuilderProperty(name);

  BuilderFunction function(String name) => BuilderFunction(name);

  BuilderUse use(dynamic name) => BuilderUse(name, Use.TYPE_NORMAL);

  BuilderUse useFunction(dynamic name) => BuilderUse(name, Use.TYPE_FUNCTION)

  BuilderUse useConst(dynamic name) => BuilderUse(name, Use.TYPE_CONSTANT);

  BuilderClassConst classConst(dynamic name, dynamic value) {
    return BuilderClassConst(name, value);
  }

  BuilderEnumCase enumCase(dynamic name) => BuilderEnumCase(name);

  Expr val(dynamic value) => BuilderHelpers.normalizeValue(value);

  ExprVariable variable(dynamic name) {
    if (name is! String && name is! Expr) {
      throw Exception('Variable name must be string or Expr');
    }
    return ExprVariable(name);
  }

  List<Arg> args(Array args) {
    final normalizedArgs = <Arg>[];
    args.array.forEach((key, arg) {
      if (arg is! Arg) {
        arg = Arg(BuilderHelpers.normalizeValue(arg));
      }
      if (key is String) {
        arg.name = BuilderHelpers.normalizeIdentifier(key);
      }
      normalizedArgs.add(arg);
    });
    return normalizedArgs;
  }

  ExprFuncCall funcCall(dynamic name, [Array args = const Array()]) {
    return ExprFuncCall(
      BuilderHelpers.normalizeNameOrExpr(name),
      this.args(args),
    );
  }

  ExprMethodCall methodCall(Expr variable, dynamic name,
      [Array args = const Array(),]) {
    return ExprMethodCall(
      variable,
      BuilderHelpers.normalizeIdentifierOrExpr(name),
      this.args(args),
    );
  }

  ExprStaticCall staticCall(dynamic className, dynamic name,
      [Array args = const Array(),]) {
    return ExprStaticCall(
      BuilderHelpers.normalizeNameOrExpr(className),
      BuilderHelpers.normalizeIdentifierOrExpr(name),
      this.args(args),
    );
  }

  ExprNew newExpr(dynamic className, [Array args = const Array()]) {
    return ExprNew(
      BuilderHelpers.normalizeNameOrExpr(className),
      this.args(args),
    );
  }

  ExprConstFetch constFetch(dynamic name) {
    return ExprConstFetch(BuilderHelpers.normalizeName(name));
  }

  ExprPropertyFetch propertyFetch(Expr variable, dynamic name) {
    return ExprPropertyFetch(
      variable,
      BuilderHelpers.normalizeIdentifierOrExpr(name),
    );
  }

  ExprClassConstFetch classConstFetch(dynamic className, dynamic name) {
    return ExprClassConstFetch(
      BuilderHelpers.normalizeNameOrExpr(className),
      BuilderHelpers.normalizeIdentifier(name),
    );
  }

  Concat concat(List<dynamic> exprs) {
    final numExprs = exprs.length;
    if (numExprs < 2) throw Exception('Expected at least two expressions');
    var lastConcat = normalizeStringExpr(exprs.first);
    for (int i = 1; i < numExprs; i++) {
      lastConcat = Concat(lastConcat, normalizeStringExpr(exprs[i]));
    }
    return lastConcat;
  }

  Expr normalizeStringExpr(expr) {
    if (expr is Expr) return expr;
    if (expr is String) return PString(expr);
    throw Exception('Expected string or Expr');
  }


}

class Array {
  const Array({this.array = const {}});

  Array.fromList(List<dynamic> list) : array = list.asMap();

  final Map array;

  void setKey(key, value) => array[key] = value;

  dynamic getKey(key) => array[key];
}
