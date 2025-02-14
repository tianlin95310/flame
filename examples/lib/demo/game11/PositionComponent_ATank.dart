import 'dart:async';
import 'dart:math';

import 'package:examples/demo/component/tank/PositionComponent_ABullet.dart';
import 'package:examples/demo/utils/interface/game-component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ATank<T extends GameComponent> extends PositionComponent with HasPaint {
  late TimerComponent _bulletCreate;

  final Vector2 _direction = Vector2.zero();

  double _speed = 200.0;

  double _angle = 0.0;

  Set<LogicalKeyboardKey>? curKeysPressed = null;

  T? component;

  final List<LogicalKeyboardKey> _directions = [
    LogicalKeyboardKey.keyS,
    LogicalKeyboardKey.keyW,
    LogicalKeyboardKey.keyD,
    LogicalKeyboardKey.keyA
  ];

  double lastTime = 0;

  @override
  FutureOr<void> onLoad() {
    // add(RectangleHitbox());
    add(_bulletCreate = TimerComponent(
        period: 0.2, repeat: true, autoStart: false, onTick: _createBullet));
    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    component = findParent<T>();
  }

  @override
  void onRemove() {
    super.onRemove();
  }

  @override
  void update(double dt) {
    final displacement = _direction.normalized() * _speed * dt;
    position.add(displacement);
    if (curKeysPressed != null && getDirectionKeyCount(curKeysPressed!) == 1) {
      lastTime += dt;
      // print('lastTime = $lastTime');
      // 在释放阶段，在只有一个方向键的情况下，只有超过两帧的时间，就认为不是同时释放，否则认为同时释放，不更新方向
      if (lastTime >= dt * 2) {
        judgeAngle(curKeysPressed!);
      } else {}
    }
    angle = _angle;
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

  ATank({super.size, super.angle, super.position, super.anchor}) : super();

  _createBullet() {
    component
        ?.add(ABullet(position: position, angle: angle, color: 0xFFFFFFFF));
  }

  void onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event is RawKeyDownEvent && !event.synthesized) {
      if (keysPressed.contains(LogicalKeyboardKey.keyJ)) {
        _createBullet();
        _bulletCreate.timer.start();
      }
    }
    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyJ) {
        _bulletCreate.timer.pause();
      }
    }

    // Avoiding repeat event as we are interested only in
    // key up and key down event.
    if (!event.synthesized) {
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        _direction.x += isKeyDown ? -1 : 1;
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
        _direction.x += isKeyDown ? 1 : -1;
      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        _direction.y += isKeyDown ? -1 : 1;
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        _direction.y += isKeyDown ? 1 : -1;
      }
    }
    if (isKeyDown) {
      // 出现两个方向的情况，方向立即响应
      if (getDirectionKeyCount(keysPressed) == 2) {
        lastTime = 0;
        curKeysPressed = null;
      }
      judgeAngle(keysPressed, dealTwoKey: true);
    }
    if (!isKeyDown) {
      // 释放第一个按键，只剩下一个按键，开始计时
      if (getDirectionKeyCount(keysPressed) == 1) {
        curKeysPressed = keysPressed;
        lastTime = 0;
      }
      // 两个按键全部释放
      else if (keysPressed.isEmpty || getDirectionKeyCount(keysPressed) == 0) {
        lastTime = 0;
        curKeysPressed = null;
      }
    }
  }

  int getDirectionKeyCount(Set<LogicalKeyboardKey> keysPressed) {
    int count = 0;
    for (var element in _directions) {
      if (keysPressed.contains(element)) {
        count++;
      }
    }
    return count;
  }

  judgeAngle(Set<LogicalKeyboardKey> keysPressed, {bool dealTwoKey = false}) {
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      _angle = -pi / 2;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      _angle = pi / 2;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      _angle = 0;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      _angle = pi;
    }
    if (dealTwoKey) {
      if (keysPressed.contains(LogicalKeyboardKey.keyA) &&
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        _angle = -pi / 4;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyA) &&
          keysPressed.contains(LogicalKeyboardKey.keyS)) {
        _angle = -pi / 4 * 3;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyW) &&
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        _angle = pi / 4;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyD) &&
          keysPressed.contains(LogicalKeyboardKey.keyS)) {
        _angle = pi / 4 * 3;
      }
    }
  }
}
