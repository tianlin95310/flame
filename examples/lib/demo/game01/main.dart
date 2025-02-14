import 'package:examples/demo/component/map.dart';
import 'package:examples/demo/component/shape-sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Game01 extends Component with HasGameRef{
  late PathSpriteJoystick sprite1;

  late final JoystickComponent joystick;

  late CameraComponent camera;

  late World world;

  late StageFitMap stageFitMap;
  late FullScreenBg fullBg;

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

    await add(world = World());
    await world.add(
        stageFitMap = StageFitMap()
    );
    world.add(TextComponent(text: 'World BBB'));
    world.add(sprite1 = PathSpriteJoystick(joystick));
    // world.add(joystick);
    await add(
      camera = CameraComponent(
        world: world,
        hudComponents: [TextComponent(text: 'Hud AAA'), joystick],
      ),
    );
    camera.backdrop.add(fullBg = FullScreenBg());

    camera.follow(sprite1);
  }

  @override
  void onMount() {
    final rect2 = Rectangle.fromPoints(Vector2.zero() + game.size / 2, stageFitMap.size - game.size / 2);
    print('rect2 = ${rect2}');
    camera.setBounds(rect2);
  }
}
