import 'package:flame/components.dart';

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
