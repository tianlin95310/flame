import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flame_demo/pc/common/style.dart';
import 'package:flutter/painting.dart';

import 'main.dart';
import 'model.dart';
import 'vo.dart';

class TurnsWho extends PositionComponent with ShapePaint {
  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  static Vector2 turnsSize = Vector2(DemoGame04.viewportSize.x / 2, 20);

  TurnsWho(this.fightModels, this.enemyModels)
      : super(
          size: turnsSize,
          anchor: Anchor.center,
          position: Vector2(FightStage.stageSize.x / 2, turnsSize.y / 2),
        );

  List<MoveToEffect> moves = [];

  DemoGame04? game;

  @override
  void onMount() {
    super.onMount();
    game = findParent();
  }

  @override
  FutureOr<void> onLoad() async {
    List<FightModelInfo> allModels = [];
    allModels.addAll(fightModels);
    allModels.addAll(enemyModels);
    addAll(
      allModels.map((e) {
        MoveToEffect moveToEffect;
        TextComponent textComponent = TextComponent(
          text: e.name,
          size: miniRender.measureText(e.name),
          anchor: Anchor.center,
          textRenderer: miniRender,
          position: Vector2(0, size.y / 2),
        );
        textComponent.add(moveToEffect = MoveToEffect(
          Vector2(size.x, size.y / 2),
          EffectController(
            infinite: true,
            speed: e.speed,
            atMaxDuration: 0.1,
            onMax: () {
              print('onMax = ${e.name}');
              pause();
              game?.onTurnsWho(e);
            },
          ),
        ));
        moves.add(moveToEffect);
        return textComponent;
      }),
    );
  }

  pause() {
    for (var element in moves) {
      element.pause();
    }
  }

  resume() {
    for (var element in moves) {
      element.resume();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);
  }
}

class FightStage extends PositionComponent with ShapePaint {
  static Vector2 stageSize = DemoGame04.viewportSize - Vector2.all(40);

  DemoGame04 game;

  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  FightStage(this.game, this.fightModels, this.enemyModels)
      : super(
          position: DemoGame04.viewportSize / 2 - stageSize / 2,
          size: stageSize,
        );

  late TextComponent indicator;

  late TurnsWho turnsWho;

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
    add(indicator = TextComponent(text: '→', anchor: Anchor.center));
    hideIndicator();
    add(turnsWho = TurnsWho(fightModels, enemyModels));
  }

  hideIndicator() {
    indicator.position = -stageSize;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);
    if (game.currentModel == null) {
      hideIndicator();
    } else {
      for (var e in fightModels) {
        if (e == game.currentModel) {
          Vector2 position = e.model.position - Vector2(e.model.size.y / 2, 0);
          indicator.position = position;
        }
      }
    }
  }

  pause() {
    turnsWho.pause();
  }

  resume() {
    turnsWho.resume();
  }
}
