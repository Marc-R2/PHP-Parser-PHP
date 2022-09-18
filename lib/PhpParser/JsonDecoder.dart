part of '../php_parser.dart';

class JsonDecode {
  Map<String, ReflectionClass> reflectionClassCache = {};

  dynamic decode(String json) {
    final value = jsonDecode(source);
    // TODO(Marc-R2): Throw
    return decodeRecursive(value);
  }

  dynamic decodeRecursive(dynamic value) {
    if (value is Map) {
      if (value.containsKey('nodeType')) {
        final nodeType = value['nodeType'];
        if (nodeType == 'Comment' || nodeType == 'Comment_Doc') {
          return decodeComment(value);
        }
        return decodeNode(value);
      }
      return decodeArray(value);
    }
    return value;
  }

  Array decodeArray(Array array) {
    final decodeArray = Array();
    array.array.forEach((key, value) {
      decodeArray.setKey(key, decodeRecursive(value));
    });
    return decodeArray;
  }

  Node decodeNode(Array value) {
    final nodeType = value.getKey('nodeType');
    if (nodeType is! String) throw Exception('Node type must be String');
    final reflectionClass = reflectionClassFromNodeType(nodeType);
    final node = reflectionClass.newInstanceWithoutConstructor();

    if (value.array.containsKey('attributes')) {
      final attributes = value.getKey('attributes');
      if (attributes is! Array) throw Exception('Attributes must be Array');
      node.setAttributes(decodeArray(attributes));
    }

    value.array.forEach((name, subNode) {
      if (name == 'nodeType' || name == 'attributes') {
      } else {
        node.name = decodeRecursive(subNode);
      }
    });

    return node;
  }

  Comment decodeComment(Array value) {
    // true is Comment and false CommentDoc
    final classType = value.getKey('nodeType') == 'Comment';
    if (!value.array.containsKey('text')) {
      throw Exception('Comment must have a text');
    }

    if (classType) {
      return Comment(
        text: value.getKey('text').toString(),
        startLine: (value.getKey('line') as int?) ?? -1,
        startFilePos: (value.getKey('filePos') as int?) ?? -1,
        startTokenPos: (value.getKey('tokenPos') as int?) ?? -1,
        endLine: (value.getKey('endLine') as int?) ?? -1,
        endFilePos: (value.getKey('endFilePos') as int?) ?? -1,
        endTokenPos: (value.getKey('endTokenPos') as int?) ?? -1,
      );
    }
    return DocComment(
      text: value.getKey('text').toString(),
      startLine: (value.getKey('line') as int?) ?? -1,
      startFilePos: (value.getKey('filePos') as int?) ?? -1,
      startTokenPos: (value.getKey('tokenPos') as int?) ?? -1,
      endLine: (value.getKey('endLine') as int?) ?? -1,
      endFilePos: (value.getKey('endFilePos') as int?) ?? -1,
      endTokenPos: (value.getKey('endTokenPos') as int?) ?? -1,
    );
  }

  ReflectionClass reflectionClassFromNodeType(String nodeType) {
    if (!reflectionClassCache.containsKey(nodeType)) {
      final className = classNameFromNodeType(nodeType);
      reflectionClassCache[nodeType] = ReflectionClass(className);
    }
    return reflectionClassCache[nodeType];
  }

  String classNameFromNodeType(String nodeType) {
    // TODO(Marc-R2): This probably need some more love later
    return 'Node$nodeType';
  }
}
