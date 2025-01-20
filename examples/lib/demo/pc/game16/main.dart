import 'dart:async';

import 'package:examples/demo/component/buttons.dart';
import 'package:examples/demo/pc/game21/main.dart';
import 'package:examples/demo/pc/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';
import 'package:flame/game.dart';

class Game16 extends RectangleComponent with HasGameRef<PCGameEntry> {
  @override
  FutureOr<void> onLoad() async {
    addAll([
      HudButtonComponent(
          button: TextComponent(text: 'OverlayRoute'),
          margin: const EdgeInsets.only(top: 50, left: 30),
          onPressed: () {
            gameRef.router.pushNamed('okOrNot');
          }),
      HudButtonComponent(
          button: TextComponent(text: 'pause'),
          margin: const EdgeInsets.only(top: 100, left: 30),
          onPressed: () {
            gameRef.router.pushNamed('pause');
          }),
      HudButtonComponent(
          button: TextComponent(text: 'RateRoute'),
          margin: const EdgeInsets.only(top: 150, left: 30),
          onPressed: () async {
            int value = await gameRef.router.pushAndWait(RateRoute());
            print('value = $value');
          })
    ]);
  }
}

class RateRoute extends ValueRoute<int> with HasGameReference<PCGameEntry> {
  RateRoute()
      : super(
          value: -1,
          transparent: true,
        );

  @override
  Component build() {
    final size = Vector2(250, 130);
    return RectangleComponent(
      position: game.size / 2,
      size: size,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xee858585),
      children: [
        RoundedButton(
          text: 'Ok',
          action: () {
            completeWith(1000);
          },
          color: const Color(0xFFFFFFFF),
          borderColor: const Color(0xFF000000),
        )..position = Vector2(size.x / 2, 100),
      ],
    );
  }
}

class BaseValueRoute extends ValueRoute<bool> with HasGameReference<PCGameEntry> {
  Game21 child;

  BaseValueRoute(this.child)
      : super(
          value: true,
          transparent: false,
        );

  @override
  Component build() {
    return child..completeWith = completeWith;
  }
}
