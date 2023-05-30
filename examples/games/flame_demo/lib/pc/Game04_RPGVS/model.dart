import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flame_demo/pc/Game04_RPGVS/main.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import 'stage.dart';

enum RPGBasicAction {
  standLeft,
  standRight,
  runLeft,
  runRight,
  attackLeft,
  attackRight,
}

typedef BasicModelAction = FutureOr Function({Map? argument});

BasicModelAction defaultAction = ({Map? argument}) {};

class Action {
  String name;
  Map? argument;

  // translate other to argument
  Function? translate;

  Action(this.name, {this.argument, this.translate});
}

class Skill {
  String name;
  List<Action> actions;

  Skill(this.name, this.actions);
}

mixin BaseRPGModel on PositionComponent {
  // 基本动作
  Map<String, BasicModelAction> basicActions = {};

  // 法术动作
  Map<String, BasicModelAction> spellActions = {};

  // 普通攻击
  late Skill basic;

  // 技能
  List<Skill> skills = [];

  // 普通攻击
  // FutureOr<void> basicAttack(BaseRPGModel enemy);

  // 普通攻击
  // FutureOr<void> skillAttack(String name, BaseRPGModel enemy);

  FutureOr<void> doAction(List<Action> actions) async {
    List<BasicModelAction> singleSkills =
        actions.map((Action action) => basicActions[action.name] ?? defaultAction).toList();
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

  FutureOr<void> basicAttack(BaseRPGModel enemy) {
    for (var element in basic.actions) {
      if (element.translate != null) {
        element.argument = element.translate!(this, enemy);
      }
    }
    return doAction(basic.actions);
  }

  FutureOr<void> skillAttack(String name, BaseRPGModel enemy) {
    Skill skill = skills.firstWhere((element) => name == element.name);
    for (var element in skill.actions) {
      if (element.translate != null) {
        element.argument = element.translate!(this, enemy);
      }
    }
    return doAction(skill.actions);
  }
}

class RPGModel extends SpriteAnimationGroupComponent<RPGBasicAction> with BaseRPGModel, ShapePaint, TapCallbacks {
  bool keepCurrentAnim = false;

  RPGModel({super.animations, super.removeOnFinish}) : super(size: Vector2.all(100), anchor: Anchor.center) {
    basicActions = {
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
        Vector2 toPosition = to;
        add(
          MoveEffect.to(toPosition, EffectController(duration: 0.3, repeatCount: 1, curve: Curves.fastOutSlowIn))
            ..onComplete = () {
              keepCurrentAnim = false;
              completer.complete();
            },
        );
        return completer.future;
      },
    };
    basic = Skill('普通攻击', [
      Action('run'),
      Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(size.x / 2, 0)};
      }),
      Action('attack'),
      Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]);
    skills = [
      Skill('横扫千军', [
        Action('run'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': takeHit.position - Vector2(size.x / 2, 0)};
        }),
        Action('attack'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': hit.position.clone()};
        }),
      ])
    ];
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), shapePaint);
  }

  @override
  void onTapUp(TapUpEvent event) {
    DemoGame04? game = findParent();
    game?.onModelSelect(this);
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
      doAction([Action('stand')]);
    }
  }

  @override
  Future<void> onLoad() async {
    current = RPGBasicAction.standRight;
  }
}

/// 校色模型
class SimpleRPGModel extends PositionComponent with ShapePaint, BgPaint, BaseRPGModel, TapCallbacks {
  static final Vector2 modelSize = Vector2(60, 60);
  Color? color;

  bool keepCurrentAnim = false;

  SimpleRPGModel({List<Skill>? skills, this.color, Vector2? size}) : super(anchor: Anchor.center) {
    super.size = (size ?? modelSize);
    basicActions = {
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
    basic = Skill('普通攻击', [
      Action('run'),
      Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(this.size.x / 2, 0)};
      }),
      Action('attack'),
      Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]);
    this.skills = (skills ?? [
      Skill('普通攻击', [
        Action('run'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': takeHit.position - Vector2(this.size.x / 2, 0)};
        }),
        Action('attack'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': hit.position.clone()};
        }),
      ])
    ]);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);

    // draw body
    Rect bodyRect = Rect.fromCenter(center: (size / 2).toOffset(), width: width / 3.5, height: height / 3);
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
  void onTapUp(TapUpEvent event) {
    DemoGame04? game = findParent();
    game?.onModelSelect(this);
  }
}

class EnemyRPGModel extends RPGModel {
  EnemyRPGModel({super.animations}) {
    basicActions = {
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
