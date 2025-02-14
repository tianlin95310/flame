import 'dart:async';

import 'package:examples/demo/game.dart';
import 'package:examples/demo/utils/mixins/router.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';

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

