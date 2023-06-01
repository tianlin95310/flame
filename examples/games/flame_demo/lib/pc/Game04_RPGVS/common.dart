import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_demo/component/progress.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'main.dart';
import 'style.dart';
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
          position: Vector2(dividerWidth, DemoGame04.viewportSize.y - infoSize.y),
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
}
