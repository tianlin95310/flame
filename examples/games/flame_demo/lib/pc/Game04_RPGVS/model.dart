import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import 'skill.dart';

/// 校色模型
class BaseModel extends PositionComponent with ShapePaint, BgPaint {

  Color? color;

  BaseModel({this.color})
      : super(size: Vector2(40, 60), anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    canvas.drawCircle((Vector2(width / 2, 10)).toOffset(), 7, shapePaint);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: center.toOffset(), width: 20, height: 25),
            const Radius.circular(5)),
        shapePaint);
    canvas.drawLine(const Offset(15, 40), const Offset(15, 55), shapePaint);
    canvas.drawLine(const Offset(25, 40), const Offset(25, 55), shapePaint);

    canvas.drawLine(const Offset(10, 20), const Offset(3, 36), shapePaint);
    canvas.drawLine(const Offset(30, 20), const Offset(37, 36), shapePaint);

    canvas.drawCircle(center.toOffset(), 2, bgPaint);
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

typedef BasicSkill = FutureOr Function();

abstract class RPGModelSkill {
  Map<String, BasicSkill> skills = {};

  FutureOr<void> startSkill(List<String> actions) => null;
}

class RPGModel extends SpriteAnimationGroupComponent<RPGBasicAction> with HasGameRef, RPGModelSkill, ShapePaint {
  double maxSpeed = 300.0;

  bool keepCurrentAnim = false;

  RPGModel({super.animations, super.removeOnFinish}) : super(size: Vector2.all(120), anchor: Anchor.center) {
    skills = {
      'wait': () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      'attack': () async {
        Completer completer = Completer();
        keepCurrentAnim = true;
        current = RPGBasicAction.attackRight;
        animation?.onComplete = () {
          completer.complete();
        };
        animation?.reset();
        return completer.future;
      },
      'stand': () {
        current = RPGBasicAction.standRight;
      },
      'run': () {
        current = RPGBasicAction.runRight;
      },
      'rush': () async {
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
      'skill1': () async {
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

  void onJinAttack() {
    startSkill(['attack']);
  }

  void onRunAttack() {
    startSkill(['run', 'rush', 'attack']);
  }

  void onYuanAttack() {
    startSkill(['attack', 'skill1']);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), shapePaint);
  }

  @override
  FutureOr<void> startSkill(List<String> actions) async {
    List<BasicSkill> singleSkills = actions.map((e) => skills[e] ?? () {}).toList();
    for (int i = 0; i < singleSkills.length; i++) {
      var action = singleSkills[i];
      await action();
    }
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
      startSkill(['stand']);
    }
  }

  @override
  Future<void> onLoad() async {
    current = RPGBasicAction.standRight;
  }
}

class EnemyRPGModel extends RPGModel {
  EnemyRPGModel({super.animations}){
    skills = {
      'wait': () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      'attack': () async {
        Completer completer = Completer();
        keepCurrentAnim = true;
        current = RPGBasicAction.attackLeft;
        animation?.onComplete = () {
          completer.complete();
        };
        animation?.reset();
        return completer.future;
      },
      'stand': () {
        current = RPGBasicAction.standLeft;
      },
      'run': () {
        current = RPGBasicAction.runLeft;
      },
      'rush': () async {
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
      'skill1': () async {
        Completer completer = Completer();
        PositionComponent skill = skillSingleFile('sk061.png', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000)..position = size / 2;

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

Future<RPGModel> loadModel(name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async {
  final spriteSheetStand =
      SpriteSheet(image: await Flame.images.load('models/singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetRun =
      SpriteSheet(image: await Flame.images.load('models/singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetAttack =
      SpriteSheet(image: await Flame.images.load('models/singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));
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

Future<EnemyRPGModel> loadEnemyModel(name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async {
  final spriteSheetStand =
  SpriteSheet(image: await Flame.images.load('models/singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetRun =
  SpriteSheet(image: await Flame.images.load('models/singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
  final spriteSheetAttack =
  SpriteSheet(image: await Flame.images.load('models/singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));
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