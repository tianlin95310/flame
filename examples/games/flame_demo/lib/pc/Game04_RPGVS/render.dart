import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

final _regularTextStyle = TextStyle(
  fontSize: 18,
  color: BasicPalette.white.color,
);
final regularRender = TextPaint(style: _regularTextStyle);

final tinyRender = TextPaint(
  style: _regularTextStyle.copyWith(fontSize: 14.0),
);
final boxRender = regularRender.copyWith(
  (style) => style.copyWith(
    color: Colors.lightGreenAccent,
    fontFamily: 'monospace',
    letterSpacing: 2.0,
  ),
);
final shadedRender = TextPaint(
  style: TextStyle(
    color: BasicPalette.white.color,
    fontSize: 40.0,
    shadows: const [
      Shadow(color: Colors.red, offset: Offset(2, 2), blurRadius: 2),
      Shadow(color: Colors.yellow, offset: Offset(4, 4), blurRadius: 4),
    ],
  ),
);
