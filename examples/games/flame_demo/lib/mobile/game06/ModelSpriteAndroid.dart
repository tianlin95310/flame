import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../game03/SkillLoadUtils.dart';
import 'ModelSprite.dart';

class JoystickAndroid {
  JoystickDirection direction = JoystickDirection.left;

  Vector2 delta = Vector2.zero();

  Vector2 get relativeDelta => delta / knobRadius;

  double knobRadius = 1;
}

class ModelSpriteAndroid extends SpriteAnimationGroupComponent<CharAction>
    with HasGameRef, CollisionCallbacks {
  ModelSpriteAndroid(Map<CharAction, SpriteAnimation> animations,
      {super.removeOnFinish})
      : super(
          animations: animations,
          size: Vector2.all(120),
          anchor: Anchor.center,
        );

  late JoystickDirection direction;

  JoystickAndroid joystick = JoystickAndroid();

  List<PositionComponent> skills = [];

  @override
  Future<void>? onLoad() async {
    current = CharAction.standRight;
    direction = JoystickDirection.right;
  }

  double maxSpeed = 300.0;

  bool isAttacking = false;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('ModelSpriteAndroid onCollisionStart intersectionPoints = ' +
        intersectionPoints.toString());
    print('ModelSpriteAndroid onCollisionStart other = ' + other.toString());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print(isAttacking);
    // print(current);
    // print(animation?.done());
    if ((current == CharAction.attackLeft ||
            current == CharAction.attackRight) &&
        (animation?.done() ?? false)) {
      isAttacking = false;
    }
    if (isAttacking) {
      return;
    }
    // print('joystick.direction = ' + joystick.direction.toString());
    // print('joystick.delta = ' + joystick.delta.toString());
    // print('direction = ' + direction.toString());
    if (joystick.direction != JoystickDirection.idle &&
        joystick.direction != direction) {
      if (joystick.direction == JoystickDirection.up ||
          joystick.direction == JoystickDirection.down) {
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
      // joystick idle
    }
    if (!joystick.delta.isZero()) {
      if (direction == JoystickDirection.right) {
        current = CharAction.runRight;
      } else if (direction == JoystickDirection.left) {
        current = CharAction.runLeft;
      }
      position.add(joystick.relativeDelta * maxSpeed * dt);
    } else {
      if (direction == JoystickDirection.right) {
        current = CharAction.standRight;
      } else if (direction == JoystickDirection.left) {
        current = CharAction.standLeft;
      }
    }
  }

  void onJinAttack() {
    print('onAttack direction = ' + direction.toString());
    isAttacking = true;
    if (direction == JoystickDirection.right) {
      current = CharAction.attackRight;
      animation?.reset();
    } else if (direction == JoystickDirection.left) {
      current = CharAction.attackLeft;
      animation?.reset();
    }
  }

  void onRunAttack() {
    isAttacking = true;
    double direction = 1.0;
    if (this.direction == JoystickDirection.right) {
      direction = 1;
      current = CharAction.runRight;
    } else if (this.direction == JoystickDirection.left) {
      direction = -1;
      current = CharAction.runLeft;
    }
    add(
      MoveEffect.to(
        position + Vector2(size.x * 2, 0) * direction,
        EffectController(duration: 0.2, repeatCount: 1),
      )..onComplete = () {
          print('MoveEffect finish');
          this.onJinAttack();
        },
    );
  }

  void onYuanAttack() async {
    this.onJinAttack();
    await Future.delayed(Duration(milliseconds: 400));
    PositionComponent skill = SkillLoadUtils.skillSingleFile(
        'sk061.png', 2, 5, 0, 7, 8, 192.0, 192.0,
        filterColor: 0xFF000000);
    double direction = 1.0;
    if (this.direction == JoystickDirection.right) {
      direction = 1;
    } else if (this.direction == JoystickDirection.left) {
      direction = -1;
    }
    if (skill.parent == null) {
      print('111111111111111111111 position = ' +
          position.toString() +
          ', skill = ' +
          skill.position.toString());
      add(skill
        ..add(MoveEffect.to(
          Vector2(size.x * 2, 0) * direction,
          EffectController(
            duration: 0.4,
            repeatCount: 1,
            curve: Curves.decelerate,
          ),
        )..onComplete = () {
            print('onYuanAttack onFinishCallback');
            remove(skill);
            skill.removeFromParent();
          }));
    } else {
      print('2222222222222222222222');
    }
  }
}
