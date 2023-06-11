import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';

class DemoGame06 extends Component {
  late SpriteComponent component;
  double angleX = 0;
  double angleY = 0;

  @override
  FutureOr<void> onLoad() async {
    add(HudButtonComponent(
        button: TextComponent(text: 'X加'),
        margin: const EdgeInsets.only(top: 50, right: 30),
        onPressed: () {
          double cu = ++angleX;
          component.transformMatrix.rotateX(cu * (pi / 180));
        }));
    add(HudButtonComponent(
        button: TextComponent(text: 'X减'),
        margin: const EdgeInsets.only(top: 50, right: 80),
        onPressed: () {
          double cu = --angleX;
          component.transformMatrix.rotateX(cu * (pi / 180));
        }));

    add(HudButtonComponent(
        button: TextComponent(text: 'Y加'),
        margin: const EdgeInsets.only(top: 100, right: 30),
        onPressed: () {
          double cu = ++angleY;
          component.transformMatrix.rotateY(cu * (pi / 180));
        }));
    add(HudButtonComponent(
        button: TextComponent(text: 'Y减'),
        margin: const EdgeInsets.only(top: 100, right: 80),
        onPressed: () {
          double cu = --angleY;
          component.transformMatrix.rotateY(cu * (pi / 180));
        }));
    add(component = SpriteComponent(
        sprite: Sprite(await Flame.images.load('icons/hudie.png')),
        size: Vector2(200, 200),
        anchor: Anchor.center,
        children: [RectangleComponent(size: Vector2(200, 200), paint: Paint()..color = const Color(0x7fcccc00))])
      ..position = Vector2(200, 200));
  }
}
