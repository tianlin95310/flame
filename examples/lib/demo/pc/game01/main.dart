import 'package:examples/demo/component/shape-sprite-joystick.dart';
import 'package:examples/demo/component/map.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Game01 extends Component with HasGameRef{
  late PathSpriteJoystick sprite1;

  late final JoystickComponent joystick;

  late SpriteComponent map1;

  late CameraComponent camera;

  late World world;

  late BigStageMap stageMap;

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

    stageMap = BigStageMap();

    await add(world = World());
    // world.add(joystick);
    await add(
      camera = CameraComponent(
        world: world,
        hudComponents: [TextComponent(text: 'AAA'), joystick],
      ),
    );
    await world.add(
      map1 = stageMap
    );
    world.add(sprite1 = PathSpriteJoystick(joystick));
    camera.follow(sprite1);
  }

  @override
  void onMount() {
    Rect rect = (map1.size - game.size).toRect();
    print('map1.size = ${map1.size}, rect = $rect, game.size = ${game.size}, camera.viewport.size = ${camera.viewport.size}, camera.visibleWorldRect = ${camera.visibleWorldRect}');
    camera.setBounds(Rectangle.fromRect(rect));
  }
}
