import 'package:flame/components.dart';
import 'package:flame/events.dart';

// 锚点在中心
class DraggableMap extends SpriteComponent with DragCallbacks {
  CameraComponent camera;

  DraggableMap(this.camera) : super(anchor: Anchor.center);
  late Vector2 start;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('img34.jpg');
    size = sprite!.originalSize;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    start = event.canvasPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2 diff = event.canvasPosition - start;
    camera.moveBy(-diff * 2, speed: 200);
    print('diff = $diff');
    start = event.canvasPosition;
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

class BigRawMap extends SpriteComponent with HasGameRef {
  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('img34.jpg');
    size = sprite!.originalSize;
  }

  BigRawMap() : super(anchor: Anchor.topLeft);
}

class StageFitMap extends SpriteComponent with HasGameRef {
  String? path;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(path ?? 'img34.jpg');
    fitByY();
    print('StageFitMap sprite = ${sprite!.originalSize}, size = ${size}');
  }

  fitByY() {
    size.y = gameRef.canvasSize.y;
    size.x = sprite!.originalSize.x / (sprite!.originalSize.y / size.y);
  }

  fitByX() {
    size.x = gameRef.canvasSize.x;
    size.y = sprite!.originalSize.y / (sprite!.originalSize.x / size.x);
  }

  StageFitMap({this.path}) : super(anchor: Anchor.topLeft);
}

class FullScreenBg extends SpriteComponent with HasGameRef {
  String? path;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(path ?? 'img35.jpg');
    size = game.size;
  }

  FullScreenBg({this.path}) : super();
}
