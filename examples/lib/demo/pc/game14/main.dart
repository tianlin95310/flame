import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:flutter/cupertino.dart';

class Game14 extends RectangleComponent {
  late SpriteComponent component;

  late SpriteComponent component2;
  double angleX = 5;
  double angleY = 5;

  double totalX = 0;
  double totalY = 0;

  late RectangleComponent point;

  @override
  FutureOr<void> onLoad() async {
    Vector2 size = Vector2(200, 300);

    add(HudButtonComponent(
        button: TextComponent(text: 'X加'),
        margin: const EdgeInsets.only(top: 50, right: 30),
        onPressed: () {
          double cu = angleX;
          totalX += angleX;
          component.transformMatrix.rotateX(cu * (pi / 180));
          component2.transformMatrix.rotateX(cu * (pi / 180));
          updatePosition(size);
        }));
    add(HudButtonComponent(
        button: TextComponent(text: 'X减'),
        margin: const EdgeInsets.only(top: 50, right: 80),
        size: Vector2(100, 100),
        onPressed: () {
          double cu = -angleX;
          totalX -= angleX;
          component.transformMatrix.rotateX(cu * (pi / 180));
          component2.transformMatrix.rotateX(cu * (pi / 180));
          updatePosition(size);
        }));

    add(HudButtonComponent(
        button: TextComponent(text: 'Y加'),
        margin: const EdgeInsets.only(top: 100, right: 30),
        onPressed: () {
          double cu = angleY;
          totalY += angleY;
          component.transformMatrix.rotateY(cu * (pi / 180));
          component2.transformMatrix.rotateY(cu * (pi / 180));
          updatePosition(size);
        }));
    add(HudButtonComponent(
        button: TextComponent(text: 'Y减'),
        margin: const EdgeInsets.only(top: 100, right: 80),
        onPressed: () {
          double cu = -angleY;
          totalY -= angleY;
          component.transformMatrix.rotateY(cu * (pi / 180));
          component2.transformMatrix.rotateY(cu * (pi / 180));
          updatePosition(size);
        }));

    add(component = SpriteComponent(
        sprite: Sprite(await Flame.images.load('flame.png')),
        size: size,
        anchor: Anchor.center,
        children: [RectangleComponent(size: size, paint: Paint()..color = const Color(0x7fcccc00))])
      ..position = size / 2);

    Vector2 dot = Vector2(5, 5);
    add(component2 = SpriteComponent(
      sprite: Sprite(await Flame.images.load('flame.png')),
      size: size,
      anchor: Anchor.topLeft,
      children: [
        AlignComponent(
            child: RectangleComponent(size: dot, paint: Paint()..color = const Color(0xffcccc00)),
            alignment: Anchor.center)
      ],
    )
      ..position = size * 2
      ..y = 100);
    add(
      point = RectangleComponent(
          size: dot,
          paint: Paint()..color = const Color(0xffcc0000),
          position: Vector2(size.x * 2 + size.x / 2, 100 + size.y / 2)),
    );
  }

  updatePosition(Vector2 size) {
    point.position = Vector2(
      400 + size.x / 2 * cos(totalY * (pi / 180)),
      100 + size.y / 2 * cos(totalX * (pi / 180)),
    );
  }
}
