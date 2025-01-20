import 'dart:math';

import 'package:flame/components.dart';

import '../../interface/game-component.dart';
import 'PositionComponent_Enemy.dart';

class EnemyCreater<T extends GameComponent> extends TimerComponent with HasGameRef {
  final Random _random = Random();

  final int currentMaxCount = 4;
  int totalCount = 0;
  int currentCount = 0;

  T? component;

  EnemyCreater() : super(period: 1, repeat: true);

  List<Enemy> enemys = [];

  @override
  void onMount() {
    super.onMount();
    component = findParent<T>();
  }

  @override
  void onTick() {
    // print('totalCount = $totalCount， currentCount = $currentCount');
    for (int i = currentCount; i < currentMaxCount; i++) {
      Enemy enemy = Enemy(
        position: Vector2(
          Enemy.initSize.x / 2 +
              (gameRef.size.x - Enemy.initSize.x) * _random.nextDouble(),
          Enemy.initSize.y / 2 +
              (gameRef.size.y - Enemy.initSize.y) * _random.nextDouble(),
        ),
        size: Enemy.initSize,
        anchor: Anchor.center,
        angle: 0,
      );
      totalCount++;
      currentCount++;
      component?.add(enemy);
    }
  }

  void reduce(Enemy other) {
    currentCount--;
  }
}
