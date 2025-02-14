import 'dart:math';

import 'package:examples/demo/component/shape-sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';

class Game04 extends Component with HasGameRef {
  final bgLayers = {
    'map/stage001.jpg': 1.0,
    'map/stage009.jpg': 1.0,
  };

  late ShapeSpriteDraggable draggable;

  @override
  Future<void>? onLoad() async {
    final layers = bgLayers.entries.map(
      (item) => game.loadParallaxLayer(
        ParallaxImageData(item.key),
        velocityMultiplier: Vector2(item.value, 1.0),
      ),
    );

    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(20.0, 0),
      ),
    );

    add(parallax);
    add(
      draggable = ShapeSpriteDraggable()
        ..position = Vector2(
          Random().nextInt(gameRef.canvasSize.x.toInt()) * 0.9,
          Random().nextInt(gameRef.canvasSize.y.toInt()) * 0.9,
        ),
    );

    add(HudButtonComponent(
      button: TextComponent(text: '-'),
      onPressed: () => draggable.scale = draggable.scale * 1.01
    )..position = Vector2(50, 50));

    add(HudButtonComponent(
        button: TextComponent(text: '+'),
        onPressed: () => draggable.scale = draggable.scale * 0.99
    )..position = Vector2(100, 50));

  }
}
