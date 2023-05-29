import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/painting.dart';

import 'model.dart';
import 'vo.dart';

class FightStage extends PositionComponent with ShapePaint {
  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  FightStage(this.fightModels, this.enemyModels, {super.size, super.position});

  RPGModelSkill? rpgModel;

  late TextComponent indicator;

  int current = 0;

  @override
  FutureOr<void> onLoad() async {
    int index = 0;
    addAll(
      fightModels.map((e) {
        if (index == 0) {
          e.model.position = e.model.size / 2;
        } else {
          RPGModelSkill pre = fightModels[index - 1].model;
          e.model.position = pre.position + Vector2(e.model.size.x / 3, e.model.size.y / 2 + pre.size.y / 2);
        }
        index++;
        return e.model;
      }),
    );

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

  void onModelSelect(RPGModelSkill rpgModel) {
    this.rpgModel = rpgModel;
  }

  FutureOr<void> onMenuClick(int menu) {
    print('onMenuClick = $menu');
    if (menu == 0) {
      return rpgModel?.oAttack(enemyModels[0].model);
    }
  }

  void changeActor() {
    rpgModel = fightModels[++current % fightModels.length].model;
  }
}
