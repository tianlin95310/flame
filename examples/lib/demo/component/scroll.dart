import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

/// 可滚动组件
class ScrollComponentAnchorCenter extends PositionComponent with DragCallbacks {
  late Vector2 start;

  Axis axis = Axis.horizontal;

  Vector2 canvasPosition = Vector2(0, 0);

  List<PositionComponent> childs;

  final Paint _borderPaint = Paint()
    ..color = const Color(0x3344ffff)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  ScrollComponentAnchorCenter(
    this.axis,
    this.childs, {
    super.size,
    super.position,
  });

  late World world;

  late CameraComponent camera;

  @override
  Future<void>? onLoad() async {
    await add(world = World());
    await add(camera = CameraComponent(world: world, viewport: FixedSizeViewport(size.x, size.y)));

    if (axis == Axis.vertical) {
      int colCount = 1;
      for (int i = 0; i < childs.length; i++) {
        int row = i ~/ colCount;
        int col = i % colCount;
        print('vertical col = $col, row = $row');
        childs[i].position = Vector2(
          1.0 * col * childs[i].size.x + 50,
          1.0 * row * childs[i].size.y + 50,
        );
      }

      // 实际可以滚动的
      Vector2 bound = Vector2(
            size.x,
            childs.map((e) => e.size.y).reduce((value, element) => value + element),
          ) -
          camera.viewport.size;
      camera.setBounds(Rectangle.fromRect(bound.toRect()));
    } else {
      int rowCount = 1;
      for (int i = 0; i < childs.length; i++) {
        int row = i % rowCount;
        int col = i ~/ rowCount;
        print('col = $col, row = $row');
        childs[i].position = Vector2(
          1.0 * col * childs[i].size.x + 50,
          1.0 * row * childs[i].size.y + 50,
        );
      }
      Vector2 bound = Vector2(
            childs.map((e) => e.size.x).reduce((value, element) => value + element),
            size.y,
          ) -
          camera.viewport.size;
      camera.setBounds(Rectangle.fromRect(bound.toRect()));
    }
    world.addAll(childs);
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _borderPaint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    start = event.canvasPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    Vector2 diff = event.canvasEndPosition - start;
    if (axis == Axis.vertical) {
      camera.moveBy(Vector2(0, -diff.y * 2), speed: 500);
    } else {
      camera.moveBy(Vector2(-diff.x * 2, 0), speed: 500);
    }
    start = event.canvasEndPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }
}

class ScrollComponentOneCol extends PositionComponent with DragCallbacks {
  late Vector2 start;

  Axis axis = Axis.horizontal;

  Vector2 canvasPosition = Vector2(0, 0);

  List<PositionComponent> childs;

  late Vector2 actSize;

  final Paint _borderPaint = Paint()
    ..color = const Color(0x3344ffff)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  ScrollComponentOneCol(
    this.axis,
    this.childs, {
    super.size,
    super.position,
  });

  late World world;

  late CameraComponent camera;

  @override
  Future<void>? onLoad() async {
    if (childs.isEmpty) {
      return;
    }
    await add(world = World());
    await add(camera = CameraComponent(world: world, viewport: FixedSizeViewport(size.x, size.y)));

    if (axis == Axis.vertical) {
      int colCount = 1;
      for (int i = 0; i < childs.length; i++) {
        int row = i ~/ colCount;
        int col = i % colCount;
        print('vertical col = $col, row = $row');
        childs[i].position = Vector2(
          1.0 * col * childs[i].size.x,
          1.0 * row * childs[i].size.y,
        );
      }

      // 实际可以滚动的
      Vector2 bound = Vector2(
            size.x,
            childs.map((e) => e.size.y).reduce((value, element) => value + element),
          ) -
          camera.viewport.size;
      actSize = bound + camera.viewport.size;
      camera.setBounds(Rectangle.fromRect(bound.toRect()));
    } else {
      int rowCount = 1;
      for (int i = 0; i < childs.length; i++) {
        int row = i % rowCount;
        int col = i ~/ rowCount;
        print('col = $col, row = $row');
        childs[i].position = Vector2(
          1.0 * col * childs[i].size.x,
          1.0 * row * childs[i].size.y,
        );
      }
      Vector2 bound = Vector2(childs.map((e) => e.size.x).reduce((value, element) => value + element), size.y) -
          camera.viewport.size;
      actSize = bound + camera.viewport.size;
      camera.setBounds(Rectangle.fromRect(bound.toRect()));
    }
    world.addAll(childs);
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _borderPaint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!scrollCheck()) {
      return;
    }
    start = event.canvasPosition;
  }

  bool scrollCheck() {
    if (axis == Axis.vertical) {
      if (actSize.y < size.y) {
        return false;
      }
    } else {
      if (actSize.x < size.x) {
        return false;
      }
    }
    return true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!scrollCheck()) {
      return;
    }
    // super.onDragUpdate(event);
    Vector2 diff = event.canvasEndPosition - start;
    if (axis == Axis.vertical) {
      camera.moveBy(Vector2(0, -diff.y * 2), speed: 500);
    } else {
      camera.moveBy(Vector2(-diff.x * 2, 0), speed: 500);
    }
    start = event.canvasEndPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }
}

class ScrollComponent extends PositionComponent with DragCallbacks {
  late Vector2 start;

  Axis axis = Axis.horizontal;

  Vector2 canvasPosition = Vector2(0, 0);

  List<PositionComponent> childs;

  late Vector2 actSize;

  int colOrRowCount;

  final Paint _borderPaint = Paint()
    ..color = const Color(0x3344ffff)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  ScrollComponent(
    this.axis,
    this.colOrRowCount,
    this.childs, {
    super.size,
    super.position,
  });

  late World world;

  late CameraComponent camera;

  @override
  Future<void>? onLoad() async {
    if (childs.isEmpty) {
      return;
    }
    await add(world = World());
    await add(camera = CameraComponent(world: world, viewport: FixedSizeViewport(size.x, size.y)));

    if (axis == Axis.vertical) {
      for (int i = 0; i < childs.length; i++) {
        int row = i ~/ colOrRowCount;
        int col = i % colOrRowCount;
        print('vertical col = $col, row = $row');
        childs[i].position = Vector2(
          1.0 * col * childs[i].size.x,
          1.0 * row * childs[i].size.y,
        );
      }
      bool isInt = childs.length ~/ colOrRowCount == childs.length / colOrRowCount;
      // 实际可以滚动的
      Vector2 bound = Vector2(size.x,
              (isInt ? childs.length ~/ colOrRowCount : childs.length ~/ colOrRowCount + 1) * childs[0].size.y) -
          camera.viewport.size;
      actSize = bound + camera.viewport.size;
      camera.setBounds(Rectangle.fromRect(bound.toRect()));
    } else {
      int rowCount = colOrRowCount;
      for (int i = 0; i < childs.length; i++) {
        int row = i % rowCount;
        int col = i ~/ rowCount;
        print('col = $col, row = $row');
        childs[i].position = Vector2(
          1.0 * col * childs[i].size.x,
          1.0 * row * childs[i].size.y,
        );
      }
      bool isInt = childs.length ~/ colOrRowCount == childs.length / colOrRowCount;
      Vector2 bound = Vector2(
              (isInt ? childs.length ~/ colOrRowCount : childs.length ~/ colOrRowCount + 1) * childs[0].size.x,
              size.y) -
          camera.viewport.size;
      actSize = bound + camera.viewport.size;
      camera.setBounds(Rectangle.fromRect(bound.toRect()));
    }
    world.addAll(childs);
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _borderPaint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!scrollCheck()) {
      return;
    }
    start = event.canvasPosition;
  }

  bool scrollCheck() {
    if (axis == Axis.vertical) {
      if (actSize.y < size.y) {
        return false;
      }
    } else {
      if (actSize.x < size.x) {
        return false;
      }
    }
    return true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!scrollCheck()) {
      return;
    }
    // super.onDragUpdate(event);
    Vector2 diff = event.canvasEndPosition - start;
    if (axis == Axis.vertical) {
      camera.moveBy(Vector2(0, -diff.y * 2), speed: 500);
    } else {
      camera.moveBy(Vector2(-diff.x * 2, 0), speed: 500);
    }
    start = event.canvasEndPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }
}
