import 'dart:async';

import 'package:examples/demo/component/tank/PositionComponent_ABullet.dart';
import 'package:examples/demo/component/tank/PositionComponent_Enemy.dart';
import 'package:examples/demo/component/tank/TimerComponent_EnemyCreater.dart';
import 'package:examples/demo/utils/interface/game-component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'PositionComponent_ATank.dart';

class Game07 extends PositionComponent with HasGameRef, TapCallbacks implements GameComponent {
  Game07() : super(size: Vector2(640, 360));
  late ATank _aTank;

  late EnemyCreater enemyCreater;

  late TextComponent banner;

  late JoystickComponent joystick;

  final _shaded = TextPaint(
    style: TextStyle(
      color: BasicPalette.white.color,
      fontSize: 28.0,
      shadows: const [
        Shadow(color: Colors.red, offset: Offset(1, 1), blurRadius: 1),
        Shadow(color: Colors.yellow, offset: Offset(2, 2), blurRadius: 2),
      ],
    ),
  );

  @override
  FutureOr<void> onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    add(joystick = JoystickComponent(
      priority: 100,
      size: 60,
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(bottom: 20, left: 20),
    ));

    add(
      _aTank = ATank(joystick,
          position: gameRef.canvasSize / 2,
          size: Vector2(50, 50),
          anchor: Anchor.center, // 锚点是相对于自己的
          angle: 0),
    );
    add(enemyCreater = EnemyCreater());
    add(banner = TextComponent(text: 'Destroyed Enemies:${enemyCreater.totalCount}', textRenderer: _shaded)
      ..anchor = Anchor.bottomRight
      ..position = gameRef.canvasSize);
    add(HudButtonComponent(
      priority: 100,
      button: TextComponent(
        text: '攻击',
        priority: 100,
      ),
      onPressed: () {
        _aTank.attack();
      },
      onReleased: () {
        _aTank.pause();
      },
      onCancelled: () {
        _aTank.pause();
      },
      margin: const EdgeInsets.only(right: 60, bottom: 60),
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xff456700));
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    print('Game07 onGameResize, Enemy length1 = ${checkEnemyChild()}, length2 = ${children.length}');
    super.onGameResize(canvasSize);
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    print('Game07 onChildrenChanged, Enemy length1 = ${checkEnemyChild()}, length2 = ${children.length}');
    super.onChildrenChanged(child, type);
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('Game07 onParentResize, Enemy length1 = ${checkEnemyChild()}, length2 = ${children.length}');
    super.onParentResize(maxSize);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other, PositionComponent main) {
    if (other is Enemy && main is ABullet) {
      main.removeFromParent();
      enemyCreater.reduce(other);
      banner.text = 'Destroyed Enemies:${enemyCreater.totalCount - 3}';
      other.takeHit();
    }
  }

  int checkEnemyChild() {
    int count = 0;
    children.forEach((element) {
      if (element is Enemy) {
        count++;
      }
    });
    return count;
  }
}
