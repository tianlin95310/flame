import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleBoom extends PositionComponent with HasPaint {
  int? color;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (color != null) {
      paint.color = Color(color!);
    }
    Rect layout = Rect.fromLTWH(0, 0, width, height);
    // canvas.drawRect(layout, paint);
    double rwidth = width / 3;
    double rheight = height / 2;
    Rect block = Rect.fromLTWH(0, 0, rwidth, rheight);
    canvas.drawRect(block.translate((width - rwidth) / 2, 0), paint);
    canvas.drawRect(block.translate(0, rheight), paint);
    canvas.drawRect(block.translate(width - rwidth, rheight), paint);
  }

  CircleBoom({
    this.color,
    super.angle,
    super.position,
    super.size,
  }) : super(anchor: Anchor.center);

  List<Effect> effects = [
    ScaleEffect.to(
      Vector2.all(0),
      EffectController(
        duration: 0.5,
        infinite: false,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    ),
    RemoveEffect(delay: 0),
  ];
  void explodeEffect() {
    add(effects[0]..onComplete = () => removeFromParent());
  }
}
