import 'package:examples/demo/component/map.dart';
import 'package:examples/demo/component/shape-sprite.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

class Game05 extends Component with HasGameRef {
  late final JoystickComponent joystick;

  late PathSpriteJoystick pathSpriteWithJoystick;

  late StageFitMap bitMap;

  late World world;

  late CameraComponent cameraComponent;

  late CameraComponent cameraComponentR;

  late CameraComponent cameraComponentS;

  @override
  Future<void>? onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    await add(world = World());
    // withFixedResolution会尽量的使用屏幕空间，会放缩
    await add(
      cameraComponentR = CameraComponent.withFixedResolution(
        world: world,
        width: game.size.x / 3,
        height: game.size.y / 4,
        hudComponents: [],
      ),
    );
    await add(
      cameraComponent = CameraComponent(
          world: world,
          viewport: FixedSizeViewport(
            450,
            300,
            children: [TextComponent(text: 'viewport')],
          ),
          hudComponents: [
            joystick = JoystickComponent(
              size: 40,
              knob: CircleComponent(radius: 10, paint: knobPaint),
              background: CircleComponent(radius: 40, paint: backgroundPaint),
              position: Vector2(50, 50),
              // margin: const EdgeInsets.only(left: 30, bottom: 60),
            )
          ]),
    );

    await add(
      cameraComponentS = CameraComponent(
        world: world,
        viewport: CircularViewport(
          200,
          children: [TextComponent(text: 'viewport')],
        ),
        hudComponents: [],
      ),
    );
    cameraComponentS.viewport.position = Vector2(700, 0);

    await world.add(bitMap = StageFitMap()..position = -cameraComponent.viewport.size / 2);
    world.add(pathSpriteWithJoystick = PathSpriteJoystick(joystick)..position = bitMap.size / 2);

    cameraComponent.follow(pathSpriteWithJoystick);
    cameraComponentR.follow(pathSpriteWithJoystick);
    cameraComponentS.follow(pathSpriteWithJoystick);
  }

  @override
  void onMount() {
    super.onMount();
    final rect = (bitMap.size - cameraComponent.viewport.size).toRect();
    cameraComponent.setBounds(Rectangle.fromRect(rect));
  }
}
