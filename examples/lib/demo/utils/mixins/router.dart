
import 'package:examples/demo/component/buttons.dart';
import 'package:examples/demo/game.dart';
import 'package:examples/demo/game21/main.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';
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