// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
part of angular2_template_parser.src.ast;

/// A parsed binding AST.
class NgBinding extends NgAstNode with NgAstSourceTokenMixin {
  /// Name of the binding.
  final String name;

  /// Create a new [NgBinding] with a [name].
  NgBinding(this.name) : super._(const []);

  /// Create a new [NgBinding] from tokenized HTML.
  NgBinding.fromTokens(
    NgToken before,
    NgToken start,
    NgToken name,
    NgToken end,
  )
      : this.name = name.text,
        super._([before, start, name, end]);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object o) {
    if (o is NgBinding) {
      return o.name == name;
    }
    return false;
  }

  @override
  String toString() => '$NgBinding #$name';

  @override
  void visit(Visitor visitor) => visitor.visitBinding(this);
}
