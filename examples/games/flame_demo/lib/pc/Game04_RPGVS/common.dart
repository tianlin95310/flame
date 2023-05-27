
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/painting.dart';

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
  Background({super.size, super.position}){
    bgPaint.color = const Color(0xff9f9f5f);
  }
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), bgPaint);
  }
}