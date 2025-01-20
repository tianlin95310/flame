import 'dart:async';
import 'dart:math';

import 'package:examples/demo/constant/style.dart';
import 'package:examples/demo/mixins/paint.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

import 'main.dart';
import 'vo.dart';

class TurnsWho extends PositionComponent with ShapePaint {
  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  static Vector2 turnsSize = Vector2(Game21.viewportSize.x / 2, 20);

  TurnsWho(this.fightModels, this.enemyModels)
      : super(
          size: turnsSize,
          anchor: Anchor.center,
          position: Vector2(FightStage.stageSize.x / 2, turnsSize.y / 2),
        );

  List<MoveToEffect> moves = [];

  Game21? game;

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
          // size: miniRender.measureText(e.name),
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

class PositionStage extends PositionComponent with BgPaint {
  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  static Vector2 positionSize = Vector2(560, 210);

  PositionStage(this.fightModels, this.enemyModels) : super(size: positionSize, anchor: Anchor.center);

  late List<PolygonComponent> positions;

  @override
  FutureOr<void> onLoad() async {
    double a = 15 * pi / 180;
    List<Vector2> vlist = [
      Vector2(0, 0),
      Vector2(positionSize.y * tan(a), positionSize.y),
      Vector2(positionSize.x, positionSize.y),
      Vector2(positionSize.x - positionSize.y * tan(a), 0),
    ];
    add(PolygonComponent(vlist, paint: Paint()..color = const Color(0xff345600)));

    Vector2 edge1 = vlist[1] - vlist[0];
    Vector2 edge4 = vlist[3] - vlist[0];

    double distance1 = vlist[1].distanceTo(vlist[0]);
    double distance4 = vlist[3].distanceTo(vlist[0]);

    List<Offset> offsets = [
      const Offset(0, 0),
      const Offset(0, 1),
      const Offset(0, 2),
      const Offset(1, 0),
      const Offset(1, 1),
      const Offset(1, 2),
      const Offset(2, 0),
      const Offset(2, 1),
      const Offset(2, 2),
      const Offset(0, 5),
      const Offset(0, 6),
      const Offset(0, 7),
      const Offset(1, 5),
      const Offset(1, 6),
      const Offset(1, 7),
      const Offset(2, 5),
      const Offset(2, 6),
      const Offset(2, 7)
    ];
    List<Color> colors = [
      const Color(0x7f00ff00),
      const Color(0x7fff0000),
      const Color(0x7f0000ff),
      const Color(0x7fff0000),
      const Color(0x7f00ff00),
      const Color(0x7f0000ff),
      const Color(0x7f0000ff),
      const Color(0x7fff0000),
      const Color(0x7f00ff00),
    ];
    int ci = 0;
    addAll(positions = offsets
        .map((e) => PolygonComponent(
              [
                Vector2(0, 0) + (edge1 / 3.0) * e.dx + (edge4 / 8.0) * e.dy,
                edge1 / 3 + (edge1 / 3.0) * e.dx + (edge4 / 8.0) * e.dy,
                edge1 / 3 + Vector2(distance4 / 8, 0) + (edge1 / 3.0) * e.dx + (edge4 / 8.0) * e.dy,
                Vector2(0, 0) + Vector2(distance4 / 8, 0) + (edge1 / 3.0) * e.dx + (edge4 / 8.0) * e.dy,
              ],
              paint: Paint()..color = const Color(0x00000000),
              // paint: Paint()..color = colors[ci++ % colors.length],
            ))
        .toList());
    int index = 0;
    addAll(
      fightModels.map((e) {
        Vector2 position = positions[4 * index++].center;
        return e.model..position = position;
      }),
    );
    addAll(enemyModels.map((e) => e.model..position = positions[13].center));
  }

  @override
  void render(Canvas canvas) {}
}

class FightStage extends PositionComponent with ShapePaint {
  static Vector2 stageSize = Game21.viewportSize - Vector2(40, 60);

  Game21 game;

  List<FightModelInfo> fightModels;

  List<FightModelInfo> enemyModels;

  FightStage(this.game, this.fightModels, this.enemyModels)
      : super(
          position: Game21.viewportSize / 2 - stageSize / 2,
          size: stageSize,
        );

  late TextComponent indicator;

  late TurnsWho turnsWho;

  late PositionStage positionStage;

  @override
  FutureOr<void> onLoad() async {
    add(
      positionStage = PositionStage(
        fightModels,
        enemyModels,
      )..position = stageSize / 2,
    );
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
          Vector2 position = e.model.position - Vector2(-e.model.x / 2, 0) ;
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
