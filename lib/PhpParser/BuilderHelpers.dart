part of '../php_parser.dart';

class BuilderHelpers {
  static Node normalizeNode(dynamic node) {
    if (node is Builder) return node.getNode();
    if (node is Node) return node;
    throw Exception('Expected node or builder object');
  }

  static Stmt normalizeStmt(dynamic node) {
    node = normalizeNode(node);
    if (node is Stmt) return node;
    if (node is NodeExpr) return Expression(node);
    throw Exception('Expected statement or expression node');
  }

  static Identifier normalizeIdentifier(dynamic name) {
    if (name is Identifier) return name;
    if (name is String) return Identifier(name);
    throw Exception(r'Expected string or instance of Node\Identifier');
  }

  // TODO(Marc-R2): normalizeIdentifierOrExpr
  static dynamic normalizeIdentifierOrExpr(dynamic name) {
    if (name is Identifier || name is NodeExpr) return name;
    if (name is String) return Identifier(name);
    throw Exception(
        r'Expected string or instance of Node\Identifier or Node\Expr');
  }

  static Name normalizeName(dynamic name) {
    if (name is Name) return name;

    if (name is String) {
      if (name.isEmpty) {
        throw Exception('Name cannot be empty');
      }

      if (name[0] == r'\') {
        return NameFullyQualified(name.substring(1));
      }

      return Name(name);
    }
    throw Exception(r'Name must be a string or an instance of Node\Name');
  }

  // TODO(Marc-R2): normalizeNameOrExpr
  static dynamic normalizeNameOrExpr(dynamic name) {
    if (name is NodeExpr) return name;
    if (name is! String && name is! Name) {
      throw Exception(
        r'Name must be a string or an instance of Node\Name or Node\Expr',
      );
    }
    return normalizeName(name);
  }

  // TODO(Marc-R2): normalizeType
  static dynamic normalizeType(dynamic type) {
    if (type is! String) {
      if (type is! Name && type is! Identifier && type is! ComplexType) {
        throw Exception(
          'Type must be a string, or an instance of Name, '
          'Identifier or ComplexType',
        );
      }
      return type;
    }

    if (type is String) {
      var nullable = false;
      if (type.isNotEmpty && type[0] == '?') {
        nullable = true;
        type = type.substring(1);
      }

      const builtinTypes = [
        'array',
        'callable',
        'bool',
        'int',
        'float',
        'string',
        'iterable',
        'void',
        'object',
        'null',
        'false',
        'mixed',
        'never',
        'true',
      ];

      const notNullableTypes = ['void', 'mixed', 'never'];

      final lowerType = type.toLowerCase();
      if (builtinTypes.contains(lowerType)) {
        type = Identifier(lowerType);
      } else {
        type = normalizeName(type);
      }

      if (nullable && notNullableTypes.contains(type)) {
        throw Exception('$type type cannot be nullable');
      }

      return nullable ? NullableType(type) : type;
    }
  }

  static NodeExpr normalizeValue(value) {
    if (value is NodeExpr) return value;
    if (value == null) return ExprConstFetch(Name('null'));
    if (value is bool) return ExprConstFetch(Name(value ? 'true' : 'false'));
    if (value is int) return ScalarInt(value);
    if (value is double) return ScalarFloat(value);
    if (value is String) return ScalarString(value);
    if (value is List || value is Map) {
      final items = <NodeArrayItem>[];
      int? lastKey = -1;
      if (value is List) value = value.asMap();
      (value as Map).forEach((key, value) {
        if (lastKey != null && lastKey! + 1 == key) {
          lastKey = lastKey! + 1;
          items.add(NodeArrayItem(normalizeValue(value)));
        } else {
          lastKey = null;
          items.add(NodeArrayItem(normalizeValue(value), normalizeValue(key)));
        }
      });
      return ExprArray(items);
    }
    throw Exception('Invalid value');
  }

  static Doc normalizeDocComment(dynamic docComment) {
    if (docComment is Doc) return docComment;
    if (docComment is String) return Doc(text: docComment);
    throw Exception(
      r'Doc comment must be a string or an instance of PhpParser\Comment\Doc',
    );
  }

  static NodeAttributeGroup normalizeAttribute(dynamic attribute) {
    if (attribute is NodeAttributeGroup) return attribute;
    if (attribute is! NodeAttribute) {
      throw Exception(
        'Attribute must be an instance of '
        r'PhpParser\Node\Attribute or PhpParser\Node\AttributeGroup',
      );
    }
    return NodeAttributeGroup([attribute]);
  }

  static int addModifier(int modifiers, int modifier) {
    Modifiers.verifyModifier(modifiers, modifier);
    return modifiers | modifier;
  }

  static int addClassModifier(int existingModifiers, int modifierToSet) {
    Modifiers.verifyClassModifier(existingModifiers, modifierToSet);
    return existingModifiers | modifierToSet;
  }
}
