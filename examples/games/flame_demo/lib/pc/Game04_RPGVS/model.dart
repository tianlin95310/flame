import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import 'skill.dart';
import 'stage.dart';

/// 校色模型
class BaseRPGModel extends PositionComponent with ShapePaint, BgPaint, RPGModelSkill, TapCallbacks {
  static final Vector2 modelSize = Vector2(60, 60);
  Color? color;

  bool keepCurrentAnim = false;

  BaseRPGModel({this.color, Vector2? size}) : super(anchor: Anchor.center) {
    super.size = (size ?? modelSize);
    skills = {
      'attack': ({Map? argument}) async {},
      'stand': ({Map? argument}) {},
      'run': ({Map? argument}) {},
      'rush': ({Map? argument}) async {
        Vector2 to = argument?['to'];
        keepCurrentAnim = true;
        Completer completer = Completer();
        // Vector2 toPosition = position + Vector2(size.x, 0) * direction;
        Vector2 toPosition = to;
        add(
          MoveEffect.to(
            toPosition,
            EffectController(duration: 0.3, repeatCount: 1, curve: Curves.fastOutSlowIn),
          )..onComplete = () {
              keepCurrentAnim = false;
              completer.complete();
            },
        );
        return completer.future;
      },
    };
  }
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);

    // draw body
    Rect bodyRect = Rect.fromCenter(center: (size / 2).toOffset(), width: width / 3.5, height: height /3);
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(5)), shapePaint);

    // draw head
    canvas.drawCircle(bodyRect.topCenter - Offset(0, bodyRect.height / 2), bodyRect.height / 2, shapePaint);

    // draw hands
    canvas.drawLine(bodyRect.topLeft, bodyRect.bottomLeft - Offset(bodyRect.width / 2, 0), shapePaint);
    canvas.drawLine(bodyRect.topRight, bodyRect.bottomRight + Offset(bodyRect.width / 2, 0), shapePaint);

    // draw legs
    canvas.drawLine(bodyRect.bottomLeft, bodyRect.bottomLeft + Offset(0, bodyRect.height), shapePaint);
    canvas.drawLine(bodyRect.bottomRight, bodyRect.bottomRight + Offset(0, bodyRect.height), shapePaint);
  }

  @override
  FutureOr<void> oAttack(RPGModelSkill enemy) {
    print('oAttack = $enemy');
    Vector2 currentPosition = position.clone();
    return startSkill([
      Action('run'),
      Action('rush', argument: {'to': enemy.position - Vector2(size.x / 2, 0)}),
      Action('attack'),
      Action('rush', argument: {'to': currentPosition})
    ]);
  }

  @override
  void onTapUp(TapUpEvent event) {
    FightStage? stage = findParent();
    stage?.onModelSelect(this);
  }
}

enum RPGBasicAction {
  standLeft,
  standRight,
  runLeft,
  runRight,
  attackLeft,
  attackRight,
}

typedef BasicSkill = FutureOr Function({Map? argument});

BasicSkill defaultBasicSkill = ({Map? argument}) {};

mixin RPGModelSkill on PositionComponent {
  Map<String, BasicSkill> skills = {};

  FutureOr<void> oAttack(RPGModelSkill enemy);

  FutureOr<void> startSkill(List<Action> actions) async {
    List<BasicSkill> singleSkills = actions.map((e) => skills[e.name] ?? defaultBasicSkill).toList();
    List<Map?> arguments = actions.map((e) => e.argument).toList();
    for (int i = 0; i < singleSkills.length; i++) {
      var action = singleSkills[i];
      if (arguments[i] != null) {
        await action(argument: arguments[i]);
      } else {
        await action();
      }
    }
  }
}

class Action {
  String name;
  Map? argument;

  Action(this.name, {this.argument});
}

class RPGModel extends SpriteAnimationGroupComponent<RPGBasicAction>
    with HasGameRef, RPGModelSkill, ShapePaint, TapCallbacks {
  bool keepCurrentAnim = false;

  RPGModel({super.animations, super.removeOnFinish}) : super(size: Vector2.all(100), anchor: Anchor.center) {
    skills = {
      'attack': ({Map? argument}) async {
        Completer completer = Completer();
        keepCurrentAnim = true;
        current = RPGBasicAction.attackRight;
        animation?.onComplete = () {
          completer.complete();
        };
        animation?.reset();
        return completer.future;
      },
      'stand': ({Map? argument}) {
        current = RPGBasicAction.standRight;
      },
      'run': ({Map? argument}) {
        current = RPGBasicAction.runRight;
      },
      'rush': ({Map? argument}) async {
        Vector2 to = argument?['to'];
        keepCurrentAnim = true;
        Completer completer = Completer();
        // Vector2 toPosition = position + Vector2(size.x, 0) * direction;
        Vector2 toPosition = to;
        add(
          MoveEffect.to(
            toPosition,
            EffectController(duration: 0.3, repeatCount: 1, curve: Curves.fastOutSlowIn),
          )..onComplete = () {
              keepCurrentAnim = false;
              completer.complete();
            },
        );
        return completer.future;
      },
    };
  }
  @override
  FutureOr oAttack(RPGModelSkill enemy) {
    Vector2 currentPosition = position.clone();
    return startSkill([
      Action('run'),
      Action('rush', argument: {'to': enemy.position - Vector2(size.x / 2, 0)}),
      Action('attack'),
      Action('rush', argument: {'to': currentPosition})
    ]);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), shapePaint);
  }

  @override
  void onTapUp(TapUpEvent event) {
    FightStage? stage = findParent();
    stage?.onModelSelect(this);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (animation == null) {
      return;
    }
    if (keepCurrentAnim) {
      if (!animation!.done()) {
        return;
      }
      if (animation!.done()) {
        keepCurrentAnim = false;
      }
    }
    if (keepCurrentAnim) {
    } else {
      startSkill([Action('stand')]);
    }
  }

  @override
  Future<void> onLoad() async {
    current = RPGBasicAction.standRight;
  }
}

class EnemyRPGModel extends RPGModel {
  EnemyRPGModel({super.animations}) {
    skills = {
      'wait': ({Map? argument}) async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      'attack': ({Map? argument}) async {
        Completer completer = Completer();
        keepCurrentAnim = true;
        current = RPGBasicAction.attackLeft;
        animation?.onComplete = () {
          completer.complete();
        };
        animation?.reset();
        return completer.future;
      },
      'stand': ({Map? argument}) {
        current = RPGBasicAction.standLeft;
      },
      'run': ({Map? argument}) {
        current = RPGBasicAction.runLeft;
      },
      'rush': ({Map? argument}) async {
        keepCurrentAnim = true;
        double direction = 1.0;
        direction = 1;
        Completer completer = Completer();
        add(
          MoveEffect.to(
            position + Vector2(size.x, 0) * direction,
            EffectController(duration: 0.3, repeatCount: 1, curve: Curves.fastOutSlowIn),
          )..onComplete = () {
              keepCurrentAnim = false;
              completer.complete();
            },
        );
        return completer.future;
      },
      'skill1': ({Map? argument}) async {
        Completer completer = Completer();
        PositionComponent skill = skillSingleFile('sk061.png', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000)
          ..position = size / 2;

        double direction = 1.0;
        // if (this.direction == JoystickDirection.right) {
        //   direction = 1;
        // } else if (this.direction == JoystickDirection.left) {
        //   direction = -1;
        // }
        if (skill.parent == null) {
          add(skill
            ..add(MoveEffect.by(
              Vector2(size.x * direction, 0),
              EffectController(
                duration: 0.4,
                repeatCount: 1,
                curve: Curves.decelerate,
              ),
            )..onComplete = () {
                skill.removeFromParent();
                completer.complete();
              }));
        }
        return completer.future;
      }
    };
  }

  @override
  Future<void> onLoad() async {
    current = RPGBasicAction.standLeft;
  }
}

Future<RPGModel> loadModel(
    name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async {
  final spriteSheetStand = SpriteSheet(
      image: await Flame.images.load('models/singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetRun = SpriteSheet(
      image: await Flame.images.load('models/singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetAttack = SpriteSheet(
      image: await Flame.images.load('models/singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));
  Map<RPGBasicAction, SpriteAnimation> sprites = {
    RPGBasicAction.standLeft: spriteSheetStand.createAnimation(row: 1, to: 7, stepTime: 0.1),
    RPGBasicAction.standRight: spriteSheetStand.createAnimation(row: 2, to: 7, stepTime: 0.1),
    RPGBasicAction.runLeft: spriteSheetRun.createAnimation(row: 1, to: 7, stepTime: 0.1),
    RPGBasicAction.runRight: spriteSheetRun.createAnimation(row: 2, to: 7, stepTime: 0.1),
    RPGBasicAction.attackLeft: spriteSheetAttack.createAnimation(row: 1, to: 7, stepTime: 0.1, loop: false),
    RPGBasicAction.attackRight: spriteSheetAttack.createAnimation(row: 2, to: 7, stepTime: 0.1, loop: false),
  };
  RPGModel model = RPGModel(animations: sprites);
  return model;
}

Future<EnemyRPGModel> loadEnemyModel(
    name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async {
  final spriteSheetStand = SpriteSheet(
      image: await Flame.images.load('models/singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetRun = SpriteSheet(
      image: await Flame.images.load('models/singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetAttack = SpriteSheet(
      image: await Flame.images.load('models/singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));
  Map<RPGBasicAction, SpriteAnimation> sprites = {
    RPGBasicAction.standLeft: spriteSheetStand.createAnimation(row: 1, to: 7, stepTime: 0.1),
    RPGBasicAction.standRight: spriteSheetStand.createAnimation(row: 2, to: 7, stepTime: 0.1),
    RPGBasicAction.runLeft: spriteSheetRun.createAnimation(row: 1, to: 7, stepTime: 0.1),
    RPGBasicAction.runRight: spriteSheetRun.createAnimation(row: 2, to: 7, stepTime: 0.1),
    RPGBasicAction.attackLeft: spriteSheetAttack.createAnimation(row: 1, to: 7, stepTime: 0.1, loop: false),
    RPGBasicAction.attackRight: spriteSheetAttack.createAnimation(row: 2, to: 7, stepTime: 0.1, loop: false),
  };
  EnemyRPGModel model = EnemyRPGModel(animations: sprites);
  return model;
}
