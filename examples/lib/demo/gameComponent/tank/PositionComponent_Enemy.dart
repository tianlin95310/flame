import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../interface/game-component.dart';
import 'PositionComponent_ABullet.dart';
import 'PositionComponent_CircleBoom.dart';

class Enemy<T extends GameComponent> extends PositionComponent
    with HasPaint, CollisionCallbacks {
  T? component;
  static final Vector2 initSize = Vector2(50, 50);

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(isSolid: true));
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    print('Enemy onGameResize');
    super.onGameResize(size);
  }
  @override
  void onParentResize(Vector2 maxSize) {
    print('Enemy onParentResize');
    super.onParentResize(maxSize);
  }
  @override
  void onMount() {
    print('Enemy onMount');
    super.onMount();
    component = findParent<T>();
  }
  @override
  void onRemove() {
    print('Enemy onRemove');
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    paint.color = Colors.red;
    double rwidth = width / 3;
    double rheight = height / 2;
    Rect block = Rect.fromLTWH(0, 0, rwidth, rheight);

    canvas.drawRect(block.translate((width - rwidth) / 2, 0), paint);
    canvas.drawRect(block.translate(0, rheight), paint);
    canvas.drawRect(block.translate(width - rwidth, rheight), paint);

    super.render(canvas);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // print('Enemy onCollisionStart = $intersectionPoints, Enemy other = $other');
  }

  void attack() {
    component?.add(ABullet(position: position, angle: angle, color: 0xFFFF0000));
  }

  Enemy({super.size, super.angle, super.position, super.anchor}) : super();

  void takeHit() {
    removeFromParent();
    component?.add(
      CircleBoom(
        color: 0xFFFF0000,
        size: size,
        position: position,
      )..explodeEffect()
    );
  }
}
