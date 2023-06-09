import 'package:flame/components.dart';
import 'package:flame/events.dart';

class MapDraggable extends SpriteComponent with DragCallbacks {
  CameraComponent camera;

  MapDraggable(this.camera) : super(anchor: Anchor.topLeft);
  late Vector2 start;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('bg/bigMap/ditu2019.jpg');
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


class StageMap extends SpriteComponent with HasGameRef {
  String? path;
  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(path ?? 'bg/map/stage001.jpg');
    sizeByX();
  }

  sizeByY() {
    size.y = gameRef.canvasSize.y;
    size.x = sprite!.originalSize.x / (sprite!.originalSize.y / size.y);
  }

  sizeByX() {
    size.x = gameRef.canvasSize.x;
    size.y = sprite!.originalSize.y / (sprite!.originalSize.x / size.x);
  }

  StageMap({this.path}) : super(anchor: Anchor.topLeft);
}
