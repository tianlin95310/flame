import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../gameComponent/tank/PositionComponent_ABullet.dart';
import '../../gameComponent/tank/PositionComponent_Enemy.dart';
import '../../gameComponent/tank/TimerComponent_EnemyCreater.dart';
import '../../interface/game-component.dart';
import 'PositionComponent_ATank.dart';

class Game11 extends Component with HasGameRef, TapCallbacks implements GameComponent {
  late ATank _aTank;

  late EnemyCreater enemyCreater;

  late TextComponent banner;

  final _shaded = TextPaint(
    style: TextStyle(
      color: BasicPalette.white.color,
      fontSize: 20.0,
      shadows: const [
        Shadow(color: Colors.red, offset: Offset(2, 2), blurRadius: 2),
        Shadow(color: Colors.yellow, offset: Offset(4, 4), blurRadius: 4),
      ],
    ),
  );

  @override
  FutureOr<void> onLoad() async {
    print('DemoGame01 onLoad');
    await add(
      _aTank = ATank(
          position: gameRef.canvasSize / 2,
          size: Vector2(50, 50),
          anchor: Anchor.center, // 锚点是相对于自己的
          angle: 0),
    );
    add(enemyCreater = EnemyCreater());
    add(banner = TextComponent(
        text: 'Destroyed Enemies:${enemyCreater.totalCount}',
        textRenderer: _shaded)
      ..anchor = Anchor.topRight
      ..position = gameRef.canvasSize - Vector2(16, gameRef.canvasSize.y));
  }

  @override
  void onMount() {
    super.onMount();
    print('DemoGame01 onMount');
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    print('DemoGame01 onGameResize');
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints,
      PositionComponent other, PositionComponent main) {
    if (other is Enemy && main is ABullet) {
      main.removeFromParent();
      enemyCreater.reduce(other);
      banner.text = 'Destroyed Enemies:${enemyCreater.totalCount - 3}';
      other.takeHit();
    }
  }

  void onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _aTank?.onKeyEvent(event, keysPressed);
  }
}
