// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_ast/src/ast.dart';
import 'package:angular_ast/src/visitor.dart';
import 'package:meta/meta.dart';

/// A visitor that desugars banana and template nodes
/// within a given AST. Ignores non-desugarable nodes.
/// This modifies the structure, and the original version of
/// each desugared node can be accessed by 'origin'.
class DesugarVisitor extends TemplateAstVisitor<TemplateAst, DesugarFlag> {
  const DesugarVisitor();

  @override
  TemplateAst visitAttribute(AttributeAst astNode, [_]) => astNode;

  @override
  TemplateAst visitBanana(BananaAst astNode, [DesugarFlag flag]) {
    if (flag == DesugarFlag.event) {
      return new EventAst.from(
          astNode,
          astNode.name + 'Changed',
          new ExpressionAst.parse('${astNode.value} = \$event',
              sourceUrl: astNode.sourceUrl));
    }
    if (flag == DesugarFlag.property) {
      return new PropertyAst.from(astNode, astNode.name,
          new ExpressionAst.parse(astNode.value, sourceUrl: astNode.sourceUrl));
    }
    return astNode;
  }

  @override
  TemplateAst visitComment(CommentAst astNode, [_]) => astNode;

  @override
  TemplateAst visitElement(ElementAst astNode, [_]) {
    if (astNode.bananas.isNotEmpty) {
      for (BananaAst bananaAst in astNode.bananas) {
        TemplateAst toAddProperty =
            bananaAst.accept(this, DesugarFlag.property);
        TemplateAst toAddEvent = bananaAst.accept(this, DesugarFlag.event);
        astNode.properties.add(toAddProperty);
        astNode.events.add(toAddEvent);
      }
      astNode.bananas = const [];
    }

    return astNode;
  }

  @override
  TemplateAst visitEmbeddedContent(EmbeddedContentAst astNode, [_]) => astNode;

  @override
  TemplateAst visitEmbeddedTemplate(EmbeddedTemplateAst astNode, [_]) =>
      astNode;

  @override
  TemplateAst visitEvent(EventAst astNode, [_]) => astNode;

  @override
  TemplateAst visitExpression(ExpressionAst astNode, [_]) => astNode;

  @override
  TemplateAst visitInterpolation(InterpolationAst astNode, [_]) => astNode;

  @override
  TemplateAst visitProperty(PropertyAst astNode, [_]) => astNode;

  @override
  TemplateAst visitReference(ReferenceAst astNode, [_]) => astNode;

  @override
  TemplateAst visitStar(StarAst astNode, [_]) => astNode;

  @override
  TemplateAst visitText(TextAst astNode, [_]) => astNode;
}

enum DesugarFlag { event, property }