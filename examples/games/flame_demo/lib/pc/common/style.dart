import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

final _regularTextStyle = TextStyle(
  fontSize: 18,
  color: BasicPalette.cyan.color,
  fontFamily: 'DaKai',
);

final miniRender = TextPaint(
  style: _regularTextStyle.copyWith(fontSize: 10.0),
);

final smallRender = TextPaint(
  style: _regularTextStyle.copyWith(fontSize: 12.0),
);

final tinyRender = TextPaint(
  style: _regularTextStyle.copyWith(fontSize: 14.0),
);

final middleRender = TextPaint(
  style: _regularTextStyle.copyWith(fontSize: 16.0),
);

final regularRender = TextPaint(style: _regularTextStyle);

final largeRender = TextPaint(
  style: _regularTextStyle.copyWith(fontSize: 16.0),
);

final boxRender = tinyRender.copyWith(
  (style) => style.copyWith(
    fontFamily: 'DaKai',
    letterSpacing: 1.2,
    // backgroundColor: BasicPalette.brown.color
  ),
);

final shadedRender = TextPaint(
  style: TextStyle(
    color: BasicPalette.white.color,
    fontSize: 20,
    shadows: const [
      Shadow(color: Colors.red, offset: Offset(1, 1), blurRadius: 1),
      Shadow(color: Colors.yellow, offset: Offset(2, 2), blurRadius: 2),
    ],
  ),
);
