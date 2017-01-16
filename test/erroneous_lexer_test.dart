// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_ast/angular_ast.dart';
import 'package:test/test.dart';

void main() {
  // Returns the html parsed as a series of tokens.
  Iterable<NgToken> tokenize(String html) =>
      const NgLexer().tokenize(html, recoverErrors: true);

  // Returns the html parsed as a series of tokens, then back to html.
  String untokenize(Iterable<NgToken> tokens) => tokens
      .fold(new StringBuffer(), (buffer, token) => buffer..write(token.lexeme))
      .toString();

  test('should tokenize: EOF in elementIdentifier', () {
    expect(tokenize('<div'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.syntheticOpenElementEnd(4)
    ]);
  });

  test('should tokenize: new tag in elementIdentifier', () {
    expect(
      tokenize('<div<div></div>'),
      [
        new NgToken.openElementStart(0),
        new NgToken.elementIdentifier(1, "div"),
        new NgToken.syntheticOpenElementEnd(4),
        new NgToken.openElementStart(4),
        new NgToken.elementIdentifier(5, "div"),
        new NgToken.openElementEnd(8),
        new NgToken.closeElementStart(9),
        new NgToken.elementIdentifier(11, "div"),
        new NgToken.closeElementEnd(14)
      ],
    );
  });

  test('should tokenize: EOF in beforeElementDecorator', () {
    expect(tokenize('<div '), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.syntheticElementDecorator(5, ""),
      new NgToken.syntheticOpenElementEnd(5)
    ]);
  });

  test('should tokenize: new tag in beforeElementDecorator', () {
    expect(tokenize('<div <div></div>'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.syntheticElementDecorator(5, ""),
      new NgToken.syntheticOpenElementEnd(5),
      new NgToken.openElementStart(5),
      new NgToken.elementIdentifier(6, "div"),
      new NgToken.openElementEnd(9),
      new NgToken.closeElementStart(10),
      new NgToken.elementIdentifier(12, "div"),
      new NgToken.closeElementEnd(15)
    ]);
  });

  test('should tokenize: EOF in elementDecorator', () {
    expect(tokenize('<div someAttr'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.syntheticOpenElementEnd(13),
    ]);
  });

  test('should tokenize: new tag in elementDecorator', () {
    expect(tokenize('<div someAttr<div></div>'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.syntheticOpenElementEnd(13),
      new NgToken.openElementStart(13),
      new NgToken.elementIdentifier(14, "div"),
      new NgToken.openElementEnd(17),
      new NgToken.closeElementStart(18),
      new NgToken.elementIdentifier(20, "div"),
      new NgToken.closeElementEnd(23)
    ]);
  });

  test('should tokenize: EOF in beforeElementDecoratorValue 1', () {
    expect(tokenize('<div someAttr ='), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.syntheticBeforeElementDecoratorValue(13),
      new NgToken.syntheticOpenElementEnd(15),
    ]);
  });

  test('should tokenize: EOF in beforeElementDecoratorValue 2', () {
    expect(tokenize('<div someAttr = '), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.syntheticBeforeElementDecoratorValue(13),
      new NgToken.beforeElementDecorator(15, " "),
      new NgToken.syntheticElementDecorator(16, ""),
      new NgToken.syntheticOpenElementEnd(16),
    ]);
  });

  test('should tokenize: new tag in beforeElementDecoratorValue 1', () {
    expect(tokenize('<div someAttr =<div></div>'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.syntheticBeforeElementDecoratorValue(13),
      new NgToken.syntheticOpenElementEnd(15),
      new NgToken.openElementStart(15),
      new NgToken.elementIdentifier(16, "div"),
      new NgToken.openElementEnd(19),
      new NgToken.closeElementStart(20),
      new NgToken.elementIdentifier(22, "div"),
      new NgToken.closeElementEnd(25),
    ]);
  });

  test('should tokenize: new tag in beforeElementDecoratorValue 2', () {
    expect(tokenize('<div someAttr = <div></div>'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.syntheticBeforeElementDecoratorValue(13),
      new NgToken.beforeElementDecorator(15, " "),
      new NgToken.syntheticElementDecorator(16, ""),
      new NgToken.syntheticOpenElementEnd(16),
      new NgToken.openElementStart(16),
      new NgToken.elementIdentifier(17, "div"),
      new NgToken.openElementEnd(20),
      new NgToken.closeElementStart(21),
      new NgToken.elementIdentifier(23, "div"),
      new NgToken.closeElementEnd(26),
    ]);
  });

  test('should tokenize: EOF in afterElementDecorator', () {
    expect(tokenize('<div someAttr = "blah"'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.beforeElementDecoratorValue(13),
      new NgToken.elementDecoratorValue(17, "blah"),
      new NgToken.afterElementDecoratorValue(21),
      new NgToken.syntheticOpenElementEnd(22)
    ]);
  });

  test('should tokenize: new tag in afterElementDecorator', () {
    expect(tokenize('<div someAttr = "blah"<div></div>'), [
      new NgToken.openElementStart(0),
      new NgToken.elementIdentifier(1, "div"),
      new NgToken.beforeElementDecorator(4, " "),
      new NgToken.elementDecorator(5, "someAttr"),
      new NgToken.beforeElementDecoratorValue(13),
      new NgToken.elementDecoratorValue(17, "blah"),
      new NgToken.afterElementDecoratorValue(21),
      new NgToken.syntheticOpenElementEnd(22),
      new NgToken.openElementStart(22),
      new NgToken.elementIdentifier(23, "div"),
      new NgToken.openElementEnd(26),
      new NgToken.closeElementStart(27),
      new NgToken.elementIdentifier(29, "div"),
      new NgToken.closeElementEnd(32)
    ]);
  });
}
