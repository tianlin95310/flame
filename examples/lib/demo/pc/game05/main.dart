import 'package:examples/demo/component/shape-sprite-joystick.dart';
import 'package:examples/demo/component/map.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

class Game05 extends Component with HasGameRef{
  late final JoystickComponent joystick;

  late PathSpriteJoystick pathSpriteWithJoystick;

  late StageMap bitMap;

  late World world;

  late CameraComponent cameraComponent;

  @override
  Future<void>? onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    await add(world = World());
    await add(
      cameraComponent = CameraComponent(
          world: world,
          viewport: FixedSizeViewport(400, 200, children: [
            TextComponent(text: 'viewport')
          ]),
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
    cameraComponent.viewport.anchor = Anchor.center;
    cameraComponent.viewport.position = gameRef.canvasSize / 2;
    cameraComponent.viewfinder.position = gameRef.canvasSize / 2;
    print('cameraComponent.viewport.position = ${cameraComponent.viewport.position}');
    print('cameraComponent.viewport.size = ${cameraComponent.viewport.size}');
    print('cameraComponent.viewfinder.position = ${cameraComponent.viewfinder.position}');
    print('cameraComponent.viewfinder.anchor = ${cameraComponent.viewfinder.anchor}');
    print('cameraComponent.viewfinder.children = ${cameraComponent.viewfinder.children.length}');
    // withFixedResolution会尽量的使用屏幕空间，会放缩
    // await add(camera = CameraComponent.withFixedResolution(world: world, width: 200, height: 200, hudComponents: [
    //   joystick = JoystickComponent(
    //     knob: CircleComponent(radius: 30, paint: knobPaint),
    //     background: CircleComponent(radius: 60, paint: backgroundPaint),
    //     margin: const EdgeInsets.only(left: 30, bottom: 30),
    //   )
    // ]));

    await world.add(bitMap = StageMap()..position = -cameraComponent.viewport.size / 2);
    world.add(pathSpriteWithJoystick = PathSpriteJoystick(joystick)
      ..position = bitMap.size / 2);

    cameraComponent.follow(pathSpriteWithJoystick);
  }
  
  @override
  void onMount() {
    super.onMount();
    cameraComponent.setBounds(Rectangle.fromRect((bitMap.size - cameraComponent.viewport.size).toRect()));
  }
}
