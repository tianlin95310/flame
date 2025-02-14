import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Game09 extends Component {
  late TiledComponent mapComponent;

  final world = World();
  late final CameraComponent cameraComponent;

  late TiledComponent map;

  @override
  FutureOr<void> onLoad() async {
    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: 16 * 28,
      height: 16 * 14,
    );
    cameraComponent.viewfinder.zoom = 0.5;
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    cameraComponent.viewfinder.add(
      MoveToEffect(
        Vector2(1000, 0),
        EffectController(
          duration: 5,
          alternate: true,
          infinite: true,
        ),
      ),
    );

    addAll([cameraComponent, world]);

    mapComponent = await TiledComponent.load('Demo01/map.tmx', Vector2.all(16));
    world.add(mapComponent);

    final objectGroup = mapComponent.tileMap.getLayer<ObjectGroup>('AnimatedCoins');
    final coins = await Flame.images.load('coins.png');

    final objectGroup2 = mapComponent.tileMap.getLayer<ObjectGroup>('path');
    final customProperties = objectGroup2!.objects[1].properties.elementAt(3);
    print('customProperties.value = ${customProperties.value}');
    // We are 100% sure that an object layer named `AnimatedCoins`
    // exists in the example `map.tmx`.
    for (final object in objectGroup!.objects) {
      world.add(
        SpriteAnimationComponent(
          size: Vector2.all(20.0),
          position: Vector2(object.x, object.y),
          animation: SpriteAnimation.fromFrameData(
            coins,
            SpriteAnimationData.sequenced(
              amount: 8,
              stepTime: .15,
              textureSize: Vector2.all(20),
            ),
          ),
        ),
      );
    }

    map = await TiledComponent.load('dungeon.tmx', Vector2.all(16));
    world.add(map);
  }
}
