import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_demo/mixins/paint.dart';

class ProgressBar extends PositionComponent with BgPaint, HasPaint {
  double progress;
  double maxValue;

  ProgressBar(this.progress, this.maxValue, {Color? color, super.size }) {
    if (color != null) {
      paint.color == color;
    } else {
      paint.color = const Color(0xff456789);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), bgPaint);
    double current = size.x / maxValue * progress;
    canvas.drawRect(Vector2(current, size.y).toRect(), paint);
  }
}
