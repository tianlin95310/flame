import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'ShapeSprite.dart';

class PathSpriteWithJoystick extends ShapeSprite {
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

  PathSpriteWithJoystick(this.joystick, {super.angle, super.position});
}
