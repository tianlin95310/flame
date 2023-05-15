
import 'package:flame/components.dart';

class StageMap extends SpriteComponent with HasGameRef{

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('bg/map/stage001.jpg');
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

  StageMap(): super(anchor: Anchor.topLeft);
}