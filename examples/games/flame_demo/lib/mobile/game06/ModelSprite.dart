import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../game03/SkillLoadUtils.dart';

enum CharBasicAnimation {
  standLeft,
  standRight,
  runLeft,
  runRight,
  attackLeft,
  attackRight,
}

typedef SingleSkill = FutureOr Function();

abstract class ModelSkill {
  Map<String, SingleSkill> skills = {};
  FutureOr<void> startSkill(List<String> actions) => null;
}

class ModelSprite extends SpriteAnimationGroupComponent<CharBasicAnimation>
    with HasGameRef, CollisionCallbacks, ModelSkill {
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
        animation?.onComplete = () {
          completer.complete();
        };
        animation?.reset();
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
        PositionComponent skill = SkillLoadUtils.skillSingleFile(
            'sk061.png', 2, 5, 0, 7, 8, 192.0, 192.0,
            filterColor: 0xFF000000)
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
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
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
