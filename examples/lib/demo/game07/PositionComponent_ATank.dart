import 'dart:async';

import 'package:examples/demo/component/tank/PositionComponent_ABullet.dart';
import 'package:examples/demo/utils/interface/game-component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ATank<T extends GameComponent> extends PositionComponent with HasPaint {
  late TimerComponent _bulletCreate;

  final JoystickComponent joystick;

  T? component;

  double maxSpeed = 300.0;

  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    add(
      _bulletCreate = TimerComponent(
        period: 0.2,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
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

  @override
  void onMount() {
    super.onMount();
    component = findParent<T>();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Rect layout = Rect.fromLTWH(0, 0, width, height);

    double rwidth = width / 3;
    double rheight = height / 2;
    Rect block = Rect.fromLTWH(0, 0, rwidth, rheight);

    canvas.drawRect(block.translate((width - rwidth) / 2, 0), paint);
    canvas.drawRect(block.translate(0, rheight), paint);
    canvas.drawRect(block.translate(width - rwidth, rheight), paint);
  }

  ATank(this.joystick, {super.size, super.angle, super.position, super.anchor})
      : super();

  _createBullet() {
    component?.add(ABullet(position: position, angle: angle, color: 0xFFFFFFFF));
  }

  void attack() {
    _bulletCreate.timer.start();
  }

  void pause() {
    _bulletCreate.timer.pause();
  }
}
