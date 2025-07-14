import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
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

class ShapeSpriteDraggable extends ShapeSprite with DragCallbacks {
  late Vector2 start;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    start = event.canvasPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2 diff = event.canvasEndPosition - start;
    position += diff;
    start = event.canvasEndPosition;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    paint.color = Colors.lightBlue;
    double rwidth = width / 3;
    double rheight = height / 2;
    Rect block = Rect.fromLTWH(0, 0, rwidth, rheight);

    canvas.drawRect(block.translate((width - rwidth) / 2, 0), paint);
    canvas.drawRect(block.translate(0, rheight), paint);
    canvas.drawRect(block.translate(width - rwidth, rheight), paint);

    super.render(canvas);
  }

  ShapeSpriteDraggable({super.angle, super.position});
}

class PathSpriteJoystick extends ShapeSprite {
  final JoystickComponent joystick;

  double maxSpeed = 300.0;

  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(isSolid: true));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }

  PathSpriteJoystick(this.joystick, {super.angle, super.position});
}
