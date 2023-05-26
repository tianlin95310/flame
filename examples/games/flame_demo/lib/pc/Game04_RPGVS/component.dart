
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/painting.dart';

class FightStage extends PositionComponent with ShapePaint {
  FightStage({super.size, super.position});

  @override
  FutureOr<void> onLoad() {
    add(BaseModel());
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), shapePaint);
  }
}
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