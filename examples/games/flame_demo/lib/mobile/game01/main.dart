import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../common/ShapeSpriteWithJoystick.dart';

class Game01 extends Component {
  late PathSpriteWithJoystick sprite1;

  late final JoystickComponent joystick;

  late SpriteComponent map1;

  late CameraComponent cameraComponent;

  late World world;

  @mustCallSuper
  @override
  Future<void>? onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    // 只有大地图的sie出来以后， 后面的才能进行定位
    joystick = JoystickComponent(
      size: 60,
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 30, bottom: 30),
    );

    Sprite map = await Sprite.load('bg/bigMap/ditu2019.jpg');

    await add(world = World());
    // world.add(joystick);
    await add(
      cameraComponent = CameraComponent(
        world: world,
        hudComponents: [TextComponent(text: 'AAA'), joystick],
      ),
    );
    await world.add(
      map1 = SpriteComponent(sprite: map)
        ..size = map.originalSize
        ..position = -cameraComponent.viewport.size / 2,
    );
    world.add(sprite1 = PathSpriteWithJoystick(joystick));
    cameraComponent.follow(sprite1);
  }

  @override
  void onMount() {
    Rect rect = (map1.size - cameraComponent.viewport.size).toRect();
    print('map1.size = ${map1.size}, rect = $rect');
    cameraComponent.setBounds(Rectangle.fromRect(rect));
  }
}
