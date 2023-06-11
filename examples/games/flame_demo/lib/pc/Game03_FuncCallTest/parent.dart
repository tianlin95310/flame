import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Parent extends PositionComponent with TapCallbacks {
  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xffff0000)
    ..strokeWidth = 2;

  @override
  bool containsLocalPoint(Vector2 point) {
    bool con = super.containsLocalPoint(point);
    // print('Parent containsLocalPoint,  point = $point, con = $con');
    return con;
  }

  @override
  void onTapUp(TapUpEvent event) {
    print('Parent onTapUp, event = $event');
    removeFromParent();
    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  FutureOr<void> onLoad() {
    print('Parent onLoad');
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    print('Parent onGameResize');
    super.onGameResize(size);
  }

  @override
  void onMount() {
    print('Parent onMount');
    super.onMount();
  }

  @override
  void onRemove() {
    print('Parent onRemove');
    super.onRemove();
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('Parent onParentResize, parent = $parent');
    super.onParentResize(maxSize);
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    print('Parent onChildrenChanged, child = $child');
    super.onChildrenChanged(child, type);
  }

  Parent() : super(anchor: Anchor.center, size: Vector2.all(300));
}
