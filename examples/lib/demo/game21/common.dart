import 'dart:async';

import 'package:examples/demo/component/progress.dart';
import 'package:examples/demo/utils/constant/style.dart';
import 'package:examples/demo/utils/mixins/paint.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'main.dart';
import 'vo.dart';

/// 头像
class Header extends PositionComponent with BgPaint {
  Header({super.size}) : super();

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), bgPaint);
  }
}

class Background extends PositionComponent with BgPaint {
  Background({super.size, super.position}) {
    bgPaint.color = const Color(0xff9f9f5f);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), bgPaint);
  }
}

class CharInfo extends PositionComponent {
  List<FightModelInfo> fightModels;

  static Vector2 infoSize = Vector2((headWidth + proWidth) * 3 + dividerWidth * 2, headHeight);

  static double headWidth = 60;
  static double headHeight = 60;
  static double dividerWidth = 5;
  static double dividerHeight = 5;

  // 进度条长宽
  static double proWidth = 60;

  late double nameHeight = headHeight / 2;

  late double proHeight = (headHeight - nameHeight - dividerHeight * 2) / 3;

  CharInfo(this.fightModels)
      : super(
          size: infoSize,
          position: Vector2(dividerWidth, Game21.viewportSize.y - infoSize.y),
        );

  @override
  FutureOr<void> onLoad() async {
    int index = 0;
    addAll(fightModels.map((e) => oneStatus(index++, e)));
  }

  PositionComponent oneStatus(int index, FightModelInfo model) {
    return PositionComponent(
      size: Vector2(headWidth + proWidth, headHeight),
      position: Vector2((headWidth + proWidth) * index + dividerWidth * index, 0),
      children: [
        Header(size: Vector2.all(headWidth))..position = Vector2(0, 0),
        TextComponent(
            text: model.name, position: Vector2(0, headHeight), anchor: Anchor.bottomLeft, textRenderer: tinyRender),
        ProgressBar(
          model.currentJing,
          model.jing,
          size: Vector2(proWidth, proHeight),
        )..position = Vector2(headWidth, 0),
        ProgressBar(
          model.currentQi,
          model.qi,
          size: Vector2(proWidth, proHeight),
        )..position = Vector2(headWidth, proHeight + dividerHeight),
        ProgressBar(
          model.currentShen,
          model.shen,
          size: Vector2(proWidth, proHeight),
        )..position = Vector2(headWidth, proHeight * 2 + dividerHeight * 2)
      ],
    );
  }

  void updateInfo() {
    removeWhere((component) => component is PositionComponent);
    int index = 0;
    addAll(fightModels.map((e) => oneStatus(index++, e)));
  }
}

class Toast extends HudMarginComponent with BgPaint {
  final String msg;
  late TextComponent textComponent;
  static Vector2 toastSize = Vector2(300, 30);

  Toast(this.msg, {super.margin}) : super(size: toastSize) {
    bgPaint.color = const Color(0x7f667788);
  }

  @override
  FutureOr<void> onLoad() async {
    add(
      textComponent = TextComponent(
        text: msg,
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: middleRender,
      )..add(RemoveEffect(
          delay: 2,
          onComplete: () {
            removeFromParent();
          })),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), bgPaint);
  }

  static void showToast(String msg, CameraComponent camera) {
    double center = camera.viewport.size.x / 2 - toastSize.x / 2;
    camera.viewport.add(Toast(msg, margin: EdgeInsets.only(left: center, top: 50)));
  }
}
