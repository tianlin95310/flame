import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/layout.dart';
import 'package:flutter/animation.dart';

List<String> cs = [
  'linear',
  'decelerate',
  'fastLinearToSlowEaseIn',
  'fastEaseInToSlowEaseOut',
  'ease',
  'easeIn',
  'easeInToLinear',
  'easeInSine',
  'easeInQuad',
  'easeInCubic',
  'easeInQuart',
  'easeInQuint',
  'easeInExpo',
  'easeInCirc',
  'easeInBack',
  'easeOut',
  'linearToEaseOut',
  'easeOutSine',
  'easeOutQuad',
  'easeOutCubic',
  'easeOutQuart',
  'easeOutQuint',
  'easeOutExpo',
  'easeOutCirc',
  'easeOutBack',
  'easeInOut',
  'easeInOutSine',
  'easeInOutQuad',
  'easeInOutCubic',
  'easeInOutCubicEmphasized',
  'easeInOutQuart',
  'easeInOutQuint',
  'easeInOutExpo',
  'easeInOutCirc',
  'easeInOutBack',
  'fastOutSlowIn',
  'slowMiddle',
  'bounceIn',
  'bounceOut',
  'bounceInOut',
  'elasticIn',
  'elasticOut',
  'elasticInOut'
];
Set<Curve> curves = {
  Curves.linear,
  Curves.decelerate,
  Curves.fastLinearToSlowEaseIn,
  Curves.fastEaseInToSlowEaseOut,
  Curves.ease,
  Curves.easeIn,
  Curves.easeInToLinear,
  Curves.easeInSine,
  Curves.easeInQuad,
  Curves.easeInCubic,
  Curves.easeInQuart,
  Curves.easeInQuint,
  Curves.easeInExpo,
  Curves.easeInCirc,
  Curves.easeInBack,
  Curves.easeOut,
  Curves.linearToEaseOut,
  Curves.easeOutSine,
  Curves.easeOutQuad,
  Curves.easeOutCubic,
  Curves.easeOutQuart,
  Curves.easeOutQuint,
  Curves.easeOutExpo,
  Curves.easeOutCirc,
  Curves.easeOutBack,
  Curves.easeInOut,
  Curves.easeInOutSine,
  Curves.easeInOutQuad,
  Curves.easeInOutCubic,
  Curves.easeInOutCubicEmphasized,
  Curves.easeInOutQuart,
  Curves.easeInOutQuint,
  Curves.easeInOutExpo,
  Curves.easeInOutCirc,
  Curves.easeInOutBack,
  Curves.fastOutSlowIn,
  Curves.slowMiddle,
  Curves.bounceIn,
  Curves.bounceOut,
  Curves.bounceInOut,
  Curves.elasticIn,
  Curves.elasticOut,
  Curves.elasticInOut
};

class Game17 extends Component with HasGameRef, TapCallbacks {
  late Content content;

  int index = 0;

  @override
  FutureOr<void> onLoad() async {
    add(content = Content(size: gameRef.canvasSize)
      // ..anchor = Anchor.center
      // ..position = gameRef.canvasSize / 2
      // ..anchor = Anchor.topLeft
      // ..position = Vector2(0, 0)
      ..anchor = Anchor.topCenter
      ..position = Vector2(gameRef.size.x / 2, 0));
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    print('current = ${cs[index % curves.length]}');
    Curve current = curves.toList()[index % curves.length];
    content.scale = Vector2(1, 1);
    content
      ..add(
        ScaleEffect.to(Vector2(0, 0), EffectController(duration: 1, curve: current)),
      )
      ..add(
        OpacityEffect.to(0, EffectController(duration: 1, curve: current)),
      );
  }

  @override
  void onTapUp(TapUpEvent event) {
    Curve current = curves.toList()[index++ % curves.length];
    content.scale = Vector2(0, 0);
    content
      ..add(
        ScaleEffect.to(Vector2(1, 1), EffectController(duration: 1, curve: current)),
      )
      ..add(
        OpacityEffect.to(1, EffectController(duration: 1, curve: current)),
      );
  }
}

class Content extends PositionComponent with HasGameRef, HasPaint implements OpacityProvider {
  Content({super.size});

  @override
  set opacity(double value) {
    paint.color = paint.color.withOpacity(value);
  }

  @override
  double get opacity => paint.color.opacity;

  @override
  FutureOr<void> onLoad() async {
    Sprite sprite = Sprite(await Flame.images.load('flame.png'));
    addAll([
      RectangleComponent(size: gameRef.size, paint: paint),
      AlignComponent(
        child: SpriteComponent(sprite: sprite, size: sprite.originalSize / 2),
        alignment: Anchor.center,
      )
    ]);
  }
}
