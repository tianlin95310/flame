import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

mixin BgPaint on Component {
  final Paint bgPaint = BasicPalette.lightGray.paint()
    ..style = PaintingStyle.fill;
}

mixin ShapePaint {
  final Paint shapePaint = BasicPalette.cyan.paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
}
