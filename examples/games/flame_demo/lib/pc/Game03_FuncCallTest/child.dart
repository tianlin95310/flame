import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Child extends PositionComponent with TapCallbacks {
  @override
  bool containsLocalPoint(Vector2 point) {
    bool con = super.containsLocalPoint(point);
    // print('Child containsLocalPoint, _size = $size,  point = $point, con = $con');
    return con;
  }

  @override
  void onTapUp(TapUpEvent event) {
    print('Child onTapUp, event = $event');
    super.onTapUp(event);
  }

  final Paint _paint = Paint()..color = const Color(0xff0000ff);
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  FutureOr<void> onLoad() {
    print('Child onLoad');
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    print('Child onGameResize');
    super.onGameResize(size);
  }

  @override
  void onMount() {
    print('Child onMount');
    super.onMount();
  }

  @override
  void onRemove() {
    print('Child onRemove');
    super.onRemove();
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('Child onParentResize, parent = $parent');
    super.onParentResize(maxSize);
  }

  Child() : super(anchor: Anchor.center, size: Vector2.all(100));
}
