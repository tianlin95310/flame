import 'dart:async';
import 'dart:ui';

import 'package:examples/demo/utils/interface/game-component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ABullet<T extends GameComponent> extends PositionComponent with HasPaint, HasGameRef, CollisionCallbacks {

  double speed = 500;
  late final Vector2 v;
  final Vector2 deltaPosition = Vector2.zero();

  int? color;

  T? component;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    v = Vector2(0, -1)..rotate(angle)..scale(speed);
    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    component = findParent<T>();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('ABullet onCollisionStart = $intersectionPoints, Enemy other = $other');
    component?.onCollisionStart(intersectionPoints, other, this);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (color != null) {
      paint.color = Color(color!);
    }
    Rect layout = Rect.fromLTWH(0, 0, width, height);
    canvas.drawCircle(layout.center, width / 2, paint);
  }

  ABullet({this.color, super.angle, super.position})
      : super(size: Vector2(5, 5), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    deltaPosition..setFrom(v)..scale(dt);
    position += deltaPosition;

    if (position.y < 0 ||
        position.x > gameRef.size.x ||
        position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
