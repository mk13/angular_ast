// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library angular_ast.src.token.tokens;

import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

part 'lexeme.dart';
part 'token_types.dart';

abstract class NgBaseToken {
  int get offset;
  int get end;
  int get length;
  String get lexeme;
  NgBaseTokenType get type;
  bool get errorSynthetic;
}

/// Represents string tokens that are of interest to the parser.
///
/// Clients should not extend, implement, or mix-in this class.
class NgSimpleToken implements NgBaseToken {
  static final Map<NgSimpleTokenType, String> _syntheticLexemeMap = {
    NgSimpleTokenType.bang: "!",
    NgSimpleTokenType.closeBracket: "]",
    NgSimpleTokenType.closeParen: ")",
    NgSimpleTokenType.commentBegin: "<!--",
    NgSimpleTokenType.commentEnd: "-->",
    NgSimpleTokenType.dash: "-",
    NgSimpleTokenType.tagStart: "<",
    NgSimpleTokenType.tagEnd: ">",
    NgSimpleTokenType.EOF: "",
    NgSimpleTokenType.equalSign: "=",
    NgSimpleTokenType.forwardSlash: "/",
    NgSimpleTokenType.hash: "#",
    NgSimpleTokenType.identifier: "",
    NgSimpleTokenType.mustacheBegin: "{{",
    NgSimpleTokenType.mustacheEnd: "}}",
    NgSimpleTokenType.openBracket: "[",
    NgSimpleTokenType.openParen: "(",
    NgSimpleTokenType.period: ".",
    NgSimpleTokenType.star: "*",
    NgSimpleTokenType.text: "",
    NgSimpleTokenType.unexpectedChar: "",
    NgSimpleTokenType.voidCloseTag: "/>",
    NgSimpleTokenType.whitespace: ""
  };

  factory NgSimpleToken.generateErrorSynthetic(
      int offset, NgSimpleTokenType type) {
    return new NgSimpleToken._(type, offset, _syntheticLexemeMap[type] ?? "",
        errorSynthetic: true);
  }

  factory NgSimpleToken.bang(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.bang, offset, '!');
  }

  factory NgSimpleToken.closeBracket(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.closeBracket, offset, ']');
  }

  factory NgSimpleToken.closeParen(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.closeParen, offset, ')');
  }

  factory NgSimpleToken.commentBegin(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.commentBegin, offset, '<!--');
  }

  factory NgSimpleToken.commentEnd(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.commentEnd, offset, '-->');
  }

  factory NgSimpleToken.dash(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.dash, offset, '-');
  }

  factory NgSimpleToken.tagStart(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.tagStart, offset, '<');
  }

  factory NgSimpleToken.tagEnd(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.tagEnd, offset, '>');
  }

  factory NgSimpleToken.EOF(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.EOF, offset, '');
  }

  factory NgSimpleToken.equalSign(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.equalSign, offset, '=');
  }

  factory NgSimpleToken.forwardSlash(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.forwardSlash, offset, '/');
  }

  factory NgSimpleToken.hash(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.hash, offset, '#');
  }

  factory NgSimpleToken.identifier(int offset, String lexeme) {
    return new NgSimpleToken(NgSimpleTokenType.identifier, offset, lexeme);
  }

  factory NgSimpleToken.mustacheBegin(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.mustacheBegin, offset, "{{");
  }

  factory NgSimpleToken.mustacheEnd(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.mustacheEnd, offset, "}}");
  }

  factory NgSimpleToken.openBracket(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.openBracket, offset, '[');
  }

  factory NgSimpleToken.openParen(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.openParen, offset, '(');
  }

  factory NgSimpleToken.period(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.period, offset, '.');
  }

  factory NgSimpleToken.star(int offset) {
    return new NgSimpleToken._(NgSimpleTokenType.star, offset, '*');
  }

  factory NgSimpleToken.text(int offset, String lexeme) {
    return new NgSimpleToken(NgSimpleTokenType.text, offset, lexeme);
  }

  factory NgSimpleToken.unexpectedChar(int offset, String lexeme) {
    return new NgSimpleToken(NgSimpleTokenType.unexpectedChar, offset, lexeme);
  }

  factory NgSimpleToken.voidCloseTag(int offset) {
    return new NgSimpleToken(NgSimpleTokenType.voidCloseTag, offset, "/>");
  }

  factory NgSimpleToken.whitespace(int offset, String lexeme) {
    return new NgSimpleToken(NgSimpleTokenType.whitespace, offset, lexeme);
  }

  const NgSimpleToken._(
    this.type,
    this.offset,
    this.lexeme, {
    bool errorSynthetic: false,
  })
      : errorSynthetic = errorSynthetic;

  NgSimpleToken(
    this.type,
    this.offset,
    this.lexeme, {
    bool errorSynthetic: false,
  })
      : errorSynthetic = errorSynthetic;

  @override
  bool operator ==(Object o) {
    if (o is NgSimpleToken) {
      return o.offset == offset && o.type == type;
    }
    return false;
  }

  @override
  int get hashCode => hash2(offset, type);
  @override
  int get end => offset + length;
  @override
  int get length => errorSynthetic ? 0 : lexeme.length;

  @override
  final int offset;
  @override
  final NgSimpleTokenType type;
  @override
  final String lexeme;
  @override
  final bool errorSynthetic;

  @override
  String toString() => '#$NgSimpleToken(${type.name}) {$offset:$lexeme}';
}

class NgSimpleQuoteToken extends NgSimpleToken {
  factory NgSimpleQuoteToken.generateErrorSynthetic(
    int offset,
  ) {
    return new NgSimpleQuoteToken(
        NgSimpleTokenType.doubleQuote, offset, "", true,
        isErrorSynthetic: true);
  }

  factory NgSimpleQuoteToken.doubleQuotedText(
    int offset,
    String lexeme,
    bool isClosed,
  ) {
    return new NgSimpleQuoteToken(
        NgSimpleTokenType.doubleQuote, offset, lexeme, isClosed);
  }

  factory NgSimpleQuoteToken.singleQuotedText(
    int offset,
    String lexeme,
    bool isClosed, {
    bool errorSynthetic: false,
  }) {
    return new NgSimpleQuoteToken(
        NgSimpleTokenType.singleQuote, offset, lexeme, isClosed);
  }

  /// Offset of left quote.
  final int quoteOffset;

  /// Offset of right quote; may be `null` to indicate unclosed.
  final int quoteEndOffset;
  String _quotedLexeme;

  NgSimpleQuoteToken(
      NgSimpleTokenType type, this.quoteOffset, String lexeme, bool isClosed,
      {bool isErrorSynthetic: false})
      : quoteEndOffset = (isClosed ? quoteOffset + lexeme.length : null),
        super(
          type,
          isErrorSynthetic ? quoteOffset : quoteOffset + 1,
          lexeme.isEmpty
              ? lexeme
              : lexeme.substring(
                  1, (isClosed ? lexeme.length - 1 : lexeme.length)),
          errorSynthetic: isErrorSynthetic,
        ) {
    _quotedLexeme = lexeme;
  }

  @override
  bool operator ==(Object o) {
    if (o is NgSimpleQuoteToken) {
      return o.offset == offset &&
          o.type == type &&
          o.quoteOffset == quoteOffset &&
          o.quoteEndOffset == quoteEndOffset;
    }
    return false;
  }

  /// Lexeme including quotes.
  String get quotedLexeme => _quotedLexeme;
  bool get isClosed => quoteEndOffset != null;
  int get quotedLength => errorSynthetic ? 0 : _quotedLexeme.length;

  @override
  int get hashCode => hash4(super.hashCode, lexeme, quoteOffset, end);

  @override
  String toString() =>
      '#$NgSimpleQuoteToken(${type.name}) {$quoteOffset:$quotedLexeme}';
}

/// Represents a Angular text/token entities.
///
/// Clients should not extend, implement, or mix-in this class.
class NgToken implements NgBaseToken {
  factory NgToken.generateErrorSynthetic(int offset, NgTokenType type,
      {String lexeme: ""}) {
    if (type == NgTokenType.beforeElementDecorator ||
        type == NgTokenType.elementDecoratorValue ||
        type == NgTokenType.elementDecorator ||
        type == NgTokenType.elementIdentifier ||
        type == NgTokenType.interpolationValue ||
        type == NgTokenType.text ||
        type == NgTokenType.whitespace ||
        type == NgTokenType.commentValue) {
      return new _LexemeNgToken(offset, lexeme, type, errorSynthetic: true);
    }
    return new NgToken._(type, offset, errorSynthetic: true);
  }

  factory NgToken.afterElementDecoratorValue(int offset) {
    return new NgToken._(NgTokenType.afterElementDecoratorValue, offset);
  }

  factory NgToken.bananaPrefix(int offset) {
    return new NgToken._(NgTokenType.bananaPrefix, offset);
  }

  factory NgToken.bananaSuffix(int offset) {
    return new NgToken._(NgTokenType.bananaSuffix, offset);
  }

  factory NgToken.beforeElementDecorator(int offset, String string) {
    return new _LexemeNgToken(
      offset,
      string,
      NgTokenType.beforeElementDecorator,
    );
  }

  factory NgToken.beforeElementDecoratorValue(int offset) {
    return new NgToken._(NgTokenType.beforeElementDecoratorValue, offset);
  }

  factory NgToken.closeElementEnd(int offset) {
    return new NgToken._(NgTokenType.closeElementEnd, offset);
  }

  factory NgToken.closeElementStart(int offset) {
    return new NgToken._(NgTokenType.closeElementStart, offset);
  }

  factory NgToken.commentEnd(int offset) {
    return new NgToken._(NgTokenType.commentEnd, offset);
  }

  factory NgToken.commentStart(int offset) {
    return new NgToken._(NgTokenType.commentStart, offset);
  }

  factory NgToken.commentValue(int offset, String string) {
    return new _LexemeNgToken(offset, string, NgTokenType.commentValue);
  }

  factory NgToken.doubleQuote(int offset) {
    return new NgToken._(NgTokenType.doubleQuote, offset);
  }

  factory NgToken.elementDecorator(int offset, String string) {
    return new _LexemeNgToken(offset, string, NgTokenType.elementDecorator);
  }

  factory NgToken.elementDecoratorValue(int offset, String string) {
    return new _LexemeNgToken(
      offset,
      string,
      NgTokenType.elementDecoratorValue,
    );
  }

  factory NgToken.elementIdentifier(int offset, String string) {
    return new _LexemeNgToken(offset, string, NgTokenType.elementIdentifier);
  }

  factory NgToken.eventPrefix(int offset) {
    return new NgToken._(NgTokenType.eventPrefix, offset);
  }

  factory NgToken.eventSuffix(int offset) {
    return new NgToken._(NgTokenType.eventSuffix, offset);
  }

  factory NgToken.interpolationEnd(int offset) {
    return new NgToken._(NgTokenType.interpolationEnd, offset);
  }

  factory NgToken.interpolationStart(int offset) {
    return new NgToken._(NgTokenType.interpolationStart, offset);
  }

  factory NgToken.interpolationValue(int offset, String string) {
    return new _LexemeNgToken(offset, string, NgTokenType.interpolationValue);
  }

  factory NgToken.openElementEnd(int offset) {
    return new NgToken._(NgTokenType.openElementEnd, offset);
  }

  factory NgToken.openElementEndVoid(int offset) {
    return new NgToken._(NgTokenType.openElementEndVoid, offset);
  }

  factory NgToken.openElementStart(int offset) {
    return new NgToken._(NgTokenType.openElementStart, offset);
  }

  factory NgToken.propertyPrefix(int offset) {
    return new NgToken._(NgTokenType.propertyPrefix, offset);
  }

  factory NgToken.propertySuffix(int offset) {
    return new NgToken._(NgTokenType.propertySuffix, offset);
  }

  factory NgToken.referencePrefix(int offset) {
    return new NgToken._(NgTokenType.referencePrefix, offset);
  }

  factory NgToken.singleQuote(int offset) {
    return new NgToken._(NgTokenType.singleQuote, offset);
  }

  factory NgToken.templatePrefix(int offset) {
    return new NgToken._(NgTokenType.templatePrefix, offset);
  }

  factory NgToken.text(int offset, String string) {
    return new _LexemeNgToken(offset, string, NgTokenType.text);
  }

  factory NgToken.whitespace(int offset, String string) {
    return new _LexemeNgToken(offset, string, NgTokenType.whitespace);
  }

  const NgToken._(this.type, this.offset, {bool errorSynthetic: false})
      : errorSynthetic = errorSynthetic;

  @override
  bool operator ==(Object o) {
    if (o is NgToken) {
      if (this.errorSynthetic || o.errorSynthetic) {
        return o.offset == offset && o.type.name == type.name;
      }
      return o.offset == offset &&
          o.type.name == type.name &&
          o.type.lexeme == type.lexeme;
    }
    return false;
  }

  @override
  int get hashCode => hash2(offset, type);

  /// Indexed location where the token ends in the original source text.
  @override
  int get end => offset + length;

  /// Number of characters in this token.
  @override
  int get length => errorSynthetic ? 0 : lexeme.length;

  /// What characters were scanned and represent this token.
  @override
  String get lexeme => type.lexeme;

  /// Indexed location where the token begins in the original source text.
  @override
  final int offset;

  /// Type of token scanned.
  @override
  final NgTokenType type;

  /// Indicates synthetic token generated from error.
  @override
  final bool errorSynthetic;

  @override
  String toString() => '#$NgToken(${type.name}) {$offset:$lexeme}';
}

class NgAttributeValueToken extends NgToken {
  factory NgAttributeValueToken.generate(
      NgToken leftQuote, NgToken innerValue, NgToken rightQuote) {
    return new NgAttributeValueToken._(
        leftQuote.offset, leftQuote, innerValue, rightQuote);
  }

  final NgToken leftQuote;
  final NgToken innerValue;
  final NgToken rightQuote;

  const NgAttributeValueToken._(
      offset, this.leftQuote, this.innerValue, this.rightQuote)
      : super._(NgTokenType.elementDecoratorValue, offset);

  @override
  bool operator ==(Object o) {
    if (o is NgAttributeValueToken) {
      return leftQuote == o.leftQuote &&
          rightQuote == o.rightQuote &&
          innerValue == o.innerValue;
    }
    return false;
  }

  @override
  int get hashCode => hash3(leftQuote, innerValue, rightQuote);

  @override
  int get end => rightQuote.end;

  @override
  int get length => leftQuote.length + innerValue.length + rightQuote.length;

  @override
  String get lexeme => leftQuote.lexeme + innerValue.lexeme + rightQuote.lexeme;

  @override
  String toString() =>
      '#$NgAttributeValueToken(${type.name}) {$offset:$lexeme} '
      '[\n\t$leftQuote,\n\t$innerValue,\n\t$rightQuote]';

  bool get isDoubleQuote => leftQuote.type == NgTokenType.doubleQuote;
  bool get isSingleQuote => leftQuote.type == NgTokenType.singleQuote;
}

class NgSpecialAttributeToken extends NgToken {
  factory NgSpecialAttributeToken.generate(
      NgToken prefixToken, NgToken identifier, NgToken suffixToken) {
    return new NgSpecialAttributeToken._(
        prefixToken.offset, prefixToken, identifier, suffixToken);
  }

  final NgToken prefixToken;
  final NgToken identifierToken;
  final NgToken suffixToken;

  bool get isReference => suffixToken == null;

  const NgSpecialAttributeToken._(
      offset, this.prefixToken, this.identifierToken, this.suffixToken)
      : super._(NgTokenType.elementDecorator, offset);

  @override
  bool operator ==(Object o) {
    if (o is NgSpecialAttributeToken) {
      return prefixToken == o.prefixToken &&
          suffixToken == o.suffixToken &&
          identifierToken == o.identifierToken;
    }
    return false;
  }

  @override
  int get hashCode => hash3(prefixToken, identifierToken, suffixToken);

  @override
  int get end => isReference ? identifierToken.end : suffixToken.end;

  @override
  int get length =>
      prefixToken.length +
      identifierToken.length +
      (isReference ? 0 : suffixToken.length);

  @override
  String get lexeme =>
      prefixToken.lexeme +
      identifierToken.lexeme +
      (isReference ? '' : suffixToken.lexeme);

  @override
  String toString() =>
      '#$NgSpecialAttributeToken(${type.name}) {$offset:$lexeme} '
      '[\n\t$prefixToken,\n\t$identifierToken,\n\t$suffixToken]';
}
