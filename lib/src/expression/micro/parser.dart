// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_ast/angular_ast.dart';
import 'package:angular_ast/src/expression/micro/ast.dart';
import 'package:angular_ast/src/expression/micro/lexer.dart';
import 'package:angular_ast/src/expression/micro/token.dart';
import 'package:meta/meta.dart';

class NgMicroParser {
  @literal
  const factory NgMicroParser() = NgMicroParser._;

  const NgMicroParser._();

  NgMicroAst parse(
    String directive,
    String expression,
    int expressionOffset, {
    @required String sourceUrl,
  }) {
    var paddedExpression = ' ' * expressionOffset + expression;
    var tokens = const NgMicroLexer().tokenize(paddedExpression).iterator;
    return new _RecursiveMicroAstParser(
      directive,
      expressionOffset,
      expression.length,
      tokens,
    )
        .parse();
  }
}

class _RecursiveMicroAstParser {
  final String _directive;
  final int _expressionOffset;
  final int _expressionLength;
//  final String _sourceUrl;
  final Iterator<NgMicroToken> _tokens;

  final references = <ReferenceAst>[];
  final properties = <PropertyAst>[];

  _RecursiveMicroAstParser(
    this._directive,
    this._expressionOffset,
    this._expressionLength,
    this._tokens,
  );

  NgMicroAst parse() {
    while (_tokens.moveNext()) {
      var token = _tokens.current;
      if (token.type == NgMicroTokenType.letKeyword) {
        _parseLet();
      } else if (token.type == NgMicroTokenType.bindIdentifier) {
        _parseBind();
      } else if (token.type != NgMicroTokenType.endExpression) {
        throw _unexpected(token);
      }
    }
    return new NgMicroAst(assignments: references, properties: properties);
  }

  void _parseBind() {
    var name = _tokens.current.lexeme;
    if (!_tokens.moveNext() ||
        _tokens.current.type != NgMicroTokenType.bindExpressionBefore ||
        !_tokens.moveNext() ||
        _tokens.current.type != NgMicroTokenType.bindExpression) {
      throw _unexpected();
    }
    var value = _tokens.current.lexeme;
    properties.add(new PropertyAst(
      '${_directive}${name[0].toUpperCase()}${name.substring(1)}',
      value,
    ));
  }

  void _parseLet() {
    String identifier;
    if (!_tokens.moveNext() ||
        _tokens.current.type != NgMicroTokenType.letKeywordAfter ||
        !_tokens.moveNext() ||
        _tokens.current.type != NgMicroTokenType.letIdentifier) {
      throw _unexpected();
    }
    identifier = _tokens.current.lexeme;
    if (!_tokens.moveNext() ||
        !_tokens.moveNext() ||
        _tokens.current.type == NgMicroTokenType.endExpression) {
      references.add(new ReferenceAst(identifier));
      return;
    }
    if (_tokens.current.type == NgMicroTokenType.letAssignment) {
      references.add(new ReferenceAst(identifier, _tokens.current.lexeme));
    } else {
      references.add(new ReferenceAst(identifier));
      if (_tokens.current.type != NgMicroTokenType.bindIdentifier) {
        throw _unexpected();
      }
      var property = _tokens.current.lexeme;
      if (!_tokens.moveNext() ||
          _tokens.current.type != NgMicroTokenType.bindExpressionBefore ||
          !_tokens.moveNext() ||
          _tokens.current.type != NgMicroTokenType.bindExpression) {
        throw _unexpected();
      }
      var expression = _tokens.current.lexeme;
      properties.add(new PropertyAst(
        '${_directive}${property[0].toUpperCase()}${property.substring(1)}',
        expression,
      ));
    }
  }

  AngularParserException _unexpected([NgMicroToken token]) {
    token ??= _tokens.current;
    return new AngularParserException(
      NgParserWarningCode.INVALID_MICRO_EXPRESSION,
      _expressionOffset,
      _expressionLength,
    );
  }
}
