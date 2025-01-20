import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'shape-sprite.dart';
class ShapeSpriteDraggable extends ShapeSprite with DragCallbacks {
  late Vector2 start;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    start = event.canvasPosition;
  }
  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2 diff = event.canvasPosition - start;
    position += diff;
    start = event.canvasPosition;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }
  @override
  void render(Canvas canvas) {
    paint.color = Colors.lightBlue;
    double rwidth = width / 3;
    double rheight = height / 2;
    Rect block = Rect.fromLTWH(0, 0, rwidth, rheight);

    canvas.drawRect(block.translate((width - rwidth) / 2, 0), paint);
    canvas.drawRect(block.translate(0, rheight), paint);
    canvas.drawRect(block.translate(width - rwidth, rheight), paint);

    super.render(canvas);
  }

  ShapeSpriteDraggable({super.angle, super.position});
}
