
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/painting.dart';

import 'model.dart';
import 'vo.dart';

class FightStage extends PositionComponent with ShapePaint {
  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels = [
    FightModelInfo('白骨精')
      ..currentJing = 90
      ..currentQi = 100
      ..currentShen = 100,
  ];

  FightStage(this.fightModels, {super.size, super.position});

  @override
  FutureOr<void> onLoad() async{
    enemyModels[0].model = await loadEnemyModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);
    int index = 0;
    addAll(fightModels.map((e) => e.model..position = e.model.size / 2 + Vector2(e.model.size.x / 4, e.model.size.y / 2) * (index++).toDouble()));

    addAll(enemyModels.map((e) => e.model..position = Vector2(size.x - e.model.size.x / 2, size.y / 2)));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);
  }
}
