import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/painting.dart';

import 'main.dart';
import 'model.dart';
import 'vo.dart';

class FightStage extends PositionComponent with ShapePaint {
  DemoGame04 game;

  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  FightStage(this.game, this.fightModels, this.enemyModels, {super.size, super.position});

  late TextComponent indicator;

  @override
  FutureOr<void> onLoad() async {
    int index = 0;
    addAll(
      fightModels.map((e) {
        if (index == 0) {
          e.model.position = e.model.size / 2;
        } else {
          BaseRPGModel pre = fightModels[index - 1].model;
          e.model.position = pre.position + Vector2(e.model.size.x / 3, e.model.size.y / 2 + pre.size.y / 2);
        }
        index++;
        return e.model;
      }),
    );
    addAll(enemyModels.map((e) => e.model..position = Vector2(size.x - e.model.size.x / 2, size.y / 2)));
    add(indicator = TextComponent(text: '→', anchor: Anchor.center)..position = Vector2(0, 0));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);
    for (var e in fightModels) {
      if (e.model == game.currentModel) {
        Vector2 position = e.model.position - Vector2(e.model.size.y / 2, 0);
        indicator.position = position;
      }
    }
  }
}
