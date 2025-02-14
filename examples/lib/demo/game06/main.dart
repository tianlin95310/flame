import 'package:examples/demo/component/buttons.dart';
import 'package:examples/demo/component/map.dart';
import 'package:examples/demo/component/pause.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

import 'models.dart';

class Game06 extends Component with TapCallbacks{
  late List<ModelSprite> sprites;

  late JoystickComponent joystickComponent;

  late StageFitMap map5;

  late ModelSprite currentSprite;

  late CameraComponent camera;

  late World world;

  int index = 0;

  @override
  void onMount() {
    super.onMount();
    camera.setBounds(Rectangle.fromRect((map5.size - camera.viewport.size).toRect()));
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
 @override
  void onLongTapDown(TapDownEvent event) {
    super.onLongTapDown(event);
    currentSprite = sprites[(++index) % sprites.length];
  }

  @override
  Future<void>? onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    sprites = await ModelLoadUtils.loadAllModels();

    await add(world = World());
    await add(
      camera = CameraComponent(world: world, hudComponents: [
        /// HudMarginComponent不随Viewfinder进行放缩
        HudMarginComponent(
          children: [BackButton()],
          margin: const EdgeInsets.only(left: 10, top: 30),
        ),
        HudMarginComponent(
          children: [PauseButton()],
          margin: const EdgeInsets.only(left: 60, top: 30),
        ),
        HudMarginComponent(
          children: [PauseButtonEngine()],
          margin: const EdgeInsets.only(left: 110, top: 30),
        ),
        HudButtonComponent(
          button: TextComponent(text: '上'),
          onPressed: () {
            Vector2 position = currentSprite.position.clone();
            world.remove(currentSprite);
            currentSprite = sprites[(--index) % sprites.length];
            currentSprite.position = position;
            updateCurrent();
          },
          margin: const EdgeInsets.only(left: 160 + 30, top: 30),
        ),
        HudButtonComponent(
          button: TextComponent(text: '下'),
          onPressed: () {
            Vector2 position = currentSprite.position.clone();
            world.remove(currentSprite);
            currentSprite = sprites[(++index) % sprites.length];
            currentSprite.position = position;
            updateCurrent();
          },
          margin: const EdgeInsets.only(left: 210 + 30, top: 30),
        ),
        HudButtonComponent(
          button: TextComponent(text: '攻击'),
          onPressed: () {
            currentSprite.onJinAttack();
          },
          margin: const EdgeInsets.only(right: 100, bottom: 20),
        ),
        HudButtonComponent(
          button: TextComponent(text: '冲刺'),
          onPressed: () {
            currentSprite.onRunAttack();
          },
          margin: const EdgeInsets.only(right: 20, bottom: 160),
        ),
        HudButtonComponent(
          button: TextComponent(text: '技能'),
          onPressed: () {
            currentSprite.onYuanAttack();
          },
          margin: const EdgeInsets.only(right: 60, bottom: 90),
        ),
        joystickComponent = JoystickComponent(
          size: 60,
          knob: CircleComponent(radius: 30, paint: knobPaint),
          background: CircleComponent(radius: 60, paint: backgroundPaint),
          margin: const EdgeInsets.only(left: 30, bottom: 30),
        )
      ]),
    );

    await world.add(map5 = StageFitMap()..position = -camera.viewport.size / 2);
    world.add(await ModelLoadUtils.loadAndroidModel('jian02', 3, 8, 16, 23, 8, 1400 / 8, 1400 / 8));

    currentSprite = sprites[0];
    updateCurrent(isFirst: true);
  }

  updateCurrent({bool isFirst = false}) {
    world.add(currentSprite);
    currentSprite.joystick = joystickComponent;
    if (isFirst) {
      currentSprite.position = Vector2(-camera.viewport.size.x / 2 + currentSprite.size.x / 2, 0);
    }
    camera.follow(currentSprite);
  }

}
