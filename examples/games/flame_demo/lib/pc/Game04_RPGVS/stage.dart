import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flame_demo/pc/Game04_RPGVS/main.dart';
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

  RPGModel? rpgModel;

  late TextComponent indicator;

  int current = 0;

  @override
  FutureOr<void> onLoad() async {
    enemyModels[0].model = await loadEnemyModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);
    int index = 0;
    addAll(
        fightModels.map((e) => e.model..position = e.model.size / 2 + Vector2(e.model.size.x / 3, e.model.size.y) * (index++).toDouble()));

    addAll(enemyModels.map((e) => e.model..position = Vector2(size.x - e.model.size.x / 2, size.y / 2)));
    add(indicator = TextComponent(text: '→', anchor: Anchor.center)..position = Vector2(0, 0));

    rpgModel = fightModels[current].model;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);
    for (var e in fightModels) {
     if (e.model == rpgModel) {
       Vector2 position = e.model.position - Vector2(e.model.size.y / 2, 0);
       indicator.position = position;
     }
    }
  }

  void onModelSelect(RPGModel rpgModel) {
    this.rpgModel = rpgModel;
  }

  void onMenuClick(int menu) {
    print('onMenuClick = $menu');
    if (menu == 0) {
      FutureOr futureOr = rpgModel?.oAttack(enemyModels[0].model);
      if (futureOr is Future) {
        futureOr.then((value) {
          rpgModel = fightModels[++current % fightModels.length].model;
          DemoGame04? game = findParent();
          game?.resetMenu();
        });
      }
    }
  }
}
