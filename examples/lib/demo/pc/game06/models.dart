import 'dart:async';
import 'dart:ui';

import 'package:examples/demo/mixins/paint.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/animation.dart';

import '../game03/skills.dart';

enum CharBasicAnimation {
  standLeft,
  standRight,
  runLeft,
  runRight,
  attackLeft,
  attackRight,
}

typedef SingleSkill = FutureOr Function();

mixin class ModelSkill {
  Map<String, SingleSkill> skills = {};
  FutureOr<void> startSkill(List<String> actions) => null;
}

class ModelSprite extends SpriteAnimationGroupComponent<CharBasicAnimation>
    with HasGameRef, CollisionCallbacks, ModelSkill, ShapePaint {
  late JoystickComponent joystick;

  late JoystickDirection direction;

  double maxSpeed = 300.0;

  bool keepCurrentAnim = false;

  ModelSprite({super.animations, super.removeOnFinish})
      : super(size: Vector2.all(120), anchor: Anchor.center) {
    skills = {
      'wait': () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      'attack': () async {
        Completer completer = Completer();
        keepCurrentAnim = true;
        if (direction == JoystickDirection.right) {
          current = CharBasicAnimation.attackRight;
        } else if (direction == JoystickDirection.left) {
          current = CharBasicAnimation.attackLeft;
        }
        animationTicker?.onComplete = () {
          completer.complete();
        };
        animationTicker?.reset();
        return completer.future;
      },
      'stand': () {
        if (direction == JoystickDirection.right) {
          current = CharBasicAnimation.standRight;
        } else if (direction == JoystickDirection.left) {
          current = CharBasicAnimation.standLeft;
        }
      },
      'run': () {
        if (direction == JoystickDirection.right) {
          current = CharBasicAnimation.runRight;
        } else if (direction == JoystickDirection.left) {
          current = CharBasicAnimation.runLeft;
        }
      },
      'rush': () async {
        keepCurrentAnim = true;
        double direction = 1.0;
        if (this.direction == JoystickDirection.right) {
          direction = 1;
        } else if (this.direction == JoystickDirection.left) {
          direction = -1;
        }
        Completer completer = Completer();
        add(
          MoveEffect.to(
            position + Vector2(size.x, 0) * direction,
            EffectController(
                duration: 0.3,
                repeatCount: 1,
                curve: Curves.fastOutSlowIn
            ),
          )..onComplete = () {
            keepCurrentAnim = false;
            completer.complete();
          },
        );
        return completer.future;
      },
      'skill1': () async {
        Completer completer = Completer();
        PositionComponent skill = SkillLoadUtils.skillSingleFile('sk061.png', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000)
          ..position = size / 2;

        double direction = 1.0;
        if (this.direction == JoystickDirection.right) {
          direction = 1;
        } else if (this.direction == JoystickDirection.left) {
          direction = -1;
        }
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
    List<SingleSkill> singleSkills =
    actions.map((e) => skills[e] ?? () {}).toList();
    for (int i = 0; i < singleSkills.length; i++) {
      var action = singleSkills[i];
      await action();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (keepCurrentAnim) {
      if (!animationTicker!.done()) {
        return;
      }
      if (animationTicker!.done()) {
        keepCurrentAnim = false;
      }
    }
    if (joystick.direction != JoystickDirection.idle) {
      if (joystick.direction != direction) {
        if (joystick.direction == JoystickDirection.up ||
            joystick.direction == JoystickDirection.down) {
          // up and down
        } else if (joystick.direction == JoystickDirection.upRight ||
            joystick.direction == JoystickDirection.downRight) {
          direction = JoystickDirection.right;
        } else if (joystick.direction == JoystickDirection.upLeft ||
            joystick.direction == JoystickDirection.downLeft) {
          direction = JoystickDirection.left;
        } else {
          direction = joystick.direction;
        }
      } else {
        // direction repeat
      }
    } else {
      // joystick idle
    }

    if (!joystick.delta.isZero()) {
      if (keepCurrentAnim) {
      } else {
        startSkill(['run']);
      }
      position.add(joystick.relativeDelta * maxSpeed * dt);
    } else {
      if (keepCurrentAnim) {
      } else {
        startSkill(['stand']);
      }
    }
  }

  @override
  Future<void> onLoad() async {
    current = CharBasicAnimation.standRight;
    direction = JoystickDirection.right;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }
}

class ModelSpriteAndroid extends ModelSprite {
  ModelSpriteAndroid({super.animations});

  @override
  Future<void> onLoad() async {
    current = CharBasicAnimation.standLeft;
    direction = JoystickDirection.right;
    joystick = JoystickComponent(size: 0, position: Vector2.all(0));
  }
}

class ModelLoadUtils {
  static Future<List<ModelSprite>> loadAllModels() async {
    return [
      // await loadModel('fe_bian01', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      // await loadModel('fe_dao01', 3, 8, 16, 23, 8, 1320.0 / 8, 1320.0 / 8),
      // await loadModel('fe_fashi01', 3, 8, 16, 23, 8, 1200.0 / 8, 1200.0 / 8),
      // await loadModel('fe_fashi02', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      // await loadModel('fe_jian02', 3, 8, 16, 23, 8, 1360.0 / 8, 1360.0 / 8),
      //
      // await loadModel('fe_jian03', 3, 8, 16, 23, 8, 1280.0 / 8, 1280.0 / 8),
      // await loadModel('fe_jian05', 3, 8, 16, 23, 8, 1200.0 / 8, 1200.0 / 8),
      // await loadModel('fe_kongshou01', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      // await loadModel('fe_kongshou02', 3, 8, 16, 23, 8, 1280.0 / 8, 1280.0 / 8),
      // await loadModel('fe_kongshou03', 3, 8, 16, 23, 8, 1600.0 / 8, 1600.0 / 8),
      //
      // await loadModel('fe_kongshou04', 3, 8, 16, 23, 8, 1280.0 / 8, 1280.0 / 8),
      // await loadModel('fe_kongshou05', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8),
      // await loadModel('fe_kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      // await loadModel('fe_kongshou08', 3, 8, 16, 23, 8, 1320.0 / 8, 1320.0 / 8),
      // await loadModel('fe_qin02', 3, 8, 16, 23, 8, 1280.0 / 8, 1280.0 / 8),
      //
      // await loadModel('fe_shanzi01', 3, 8, 16, 23, 8, 1219.0 / 8, 1219.0 / 8),
      // await loadModel('fe_shanzi02', 3, 8, 16, 23, 8, 1150.0 / 8, 1150.0 / 8),
      // await loadModel('fe_wandao01', 3, 8, 16, 23, 8, 1600.0 / 8, 1600.0 / 8),
      // await loadModel('jian01', 3, 8, 16, 23, 8, 1280.0 / 8, 1280.0 / 8),
      await loadModel('jian02', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8),
      //
      // await loadModel('jian03', 3, 8, 16, 23, 8, 1600.0 / 8, 1600.0 / 8),
      // await loadModel('jian04', 3, 8, 16, 23, 8, 1600.0 / 8, 1600.0 / 8),
      // await loadModel('jian05', 3, 8, 16, 23, 8, 1320.0 / 8, 1320.0 / 8),
      // await loadModel('jian08', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      await loadModel('jian10', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      //
      // await loadModel('jujian01', 3, 8, 16, 23, 8, 1480.0 / 8, 1480.0 / 8),
      // await loadModel('jujian02', 3, 8, 16, 23, 8, 1520.0 / 8, 1520.0 / 8),
      // await loadModel('jujian03', 3, 8, 16, 23, 8, 1480.0 / 8, 1480.0 / 8),
      // await loadModel('kongshou01', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8),
      // await loadModel('kongshou04', 3, 8, 16, 23, 8, 1560.0 / 8, 1560.0 / 8),
      //
      // await loadModel('kongshou05', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      // await loadModel('kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
      // await loadModel('kongshou07', 3, 8, 16, 23, 8, 1520.0 / 8, 1520.0 / 8),
      // await loadModel('shanzi01', 3, 8, 16, 23, 8, 1200.0 / 8, 1200.0 / 8),
      // await loadModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8),
    ];
  }

  static Future<ModelSprite> loadModel(name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async{

    final spriteSheetStand = SpriteSheet(image: await Flame.images.load('singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetRun = SpriteSheet(image: await Flame.images.load('singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetAttack = SpriteSheet(image: await Flame.images.load('singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));
    Map<CharBasicAnimation, SpriteAnimation> sprites = {
      CharBasicAnimation.standLeft: spriteSheetStand.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.standRight: spriteSheetStand.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.runLeft: spriteSheetRun.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.runRight: spriteSheetRun.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.attackLeft: spriteSheetAttack.createAnimation(row: 1, to: 7, stepTime: 0.1, loop: false) ,
      CharBasicAnimation.attackRight: spriteSheetAttack.createAnimation(row: 2, to: 7, stepTime: 0.1, loop: false),
    };
    ModelSprite model = ModelSprite(animations: sprites);
    return model;
  }

  static Future<ModelSpriteAndroid> loadAndroidModel(name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async{

    final spriteSheetStand = SpriteSheet(image: await Flame.images.load('singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetRun = SpriteSheet(image: await Flame.images.load('singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetAttack = SpriteSheet(image: await Flame.images.load('singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));

    Map<CharBasicAnimation, SpriteAnimation> sprites = {
      CharBasicAnimation.standLeft: spriteSheetStand.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.standRight: spriteSheetStand.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.runLeft: spriteSheetRun.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.runRight: spriteSheetRun.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.attackLeft: spriteSheetAttack.createAnimation(row: 1, to: 7, stepTime: 0.1, loop: false) ,
      CharBasicAnimation.attackRight: spriteSheetAttack.createAnimation(row: 2, to: 7, stepTime: 0.1, loop: false),
    };
    ModelSpriteAndroid model = ModelSpriteAndroid(animations: sprites);

    return model;
  }
}
