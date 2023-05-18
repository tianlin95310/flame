import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShapeSprite extends PositionComponent with HasPaint {
  static final Vector2 initSize = Vector2(50, 50);

  Color? color;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(isSolid: true));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    paint.color = color ?? Colors.lightBlue;
    double rwidth = width / 3;
    double rheight = height / 2;
    Rect block = Rect.fromLTWH(0, 0, rwidth, rheight);

    canvas.drawRect(block.translate((width - rwidth) / 2, 0), paint);
    canvas.drawRect(block.translate(0, rheight), paint);
    canvas.drawRect(block.translate(width - rwidth, rheight), paint);

    super.render(canvas);
  }

  ShapeSprite({this.color, super.angle, super.position}) : super(size: Vector2(50, 50), anchor: Anchor.center);
}
