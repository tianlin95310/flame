import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'main.dart';
import 'model.dart';

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

class Menu extends PositionComponent with BgPaint {
  static final menuSize = Vector2(150, 150);
  Vector2 buttonSize = TextButtonRect.initSize;

  Menu() : super(size: menuSize);

  @override
  FutureOr<void> onLoad() async {
    addAll([
      getButton('击', () {
        onMenuClick(0);
      })
        ..position = center,
      getButton('技', () {
        onMenuClick(1);
      })
        ..position = center - Vector2(0, buttonSize.y),
      getButton('术', () {
        onMenuClick(2);
      })
        ..position = center + Vector2(buttonSize.x, 0),
      getButton('物', () {
        onMenuClick(3);
      })
        ..position = center - Vector2(buttonSize.x, 0),
      getButton('避', () {
        onMenuClick(4);
      })
        ..position = center + Vector2(0, buttonSize.y),
    ]);
    bgPaint.color = const Color(0x7FA52A2A);
  }

  PositionComponent getButton(String text, void Function() action) {
    return TextButtonRect(text: text, action: action, color: const Color(0xFF00FFFF), borderColor: const Color(0xFF00FFFF));
  }

  void onMenuClick(int menu) {
    DemoGame04? game = findParent();
    game?.onMenuClick(menu);
    scale = Vector2(0, 0);
  }
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(RRect.fromRectAndRadius(menuSize.toRect(), Radius.circular(buttonSize.x / 4)), bgPaint);
  }
}

class SecondMenu extends PositionComponent {}
