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
