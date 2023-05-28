import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_demo/component/progress.dart';
import 'package:flame_demo/pc/Game04_RPGVS/model.dart';
import 'package:flutter/painting.dart';

import 'common.dart';
import 'stage.dart';
import 'vo.dart';
import 'render.dart';

class DemoGame04 extends Component {
  late World world;

  late CameraComponent camera;

  List<FightModelInfo> fightModels = [
    // FightModelInfo('三藏')
    //   ..currentJing = 30
    //   ..currentQi = 40
    //   ..currentShen = 50,
    FightModelInfo('悟空')
      ..currentJing = 50
      ..currentQi = 60
      ..currentShen = 70,
    FightModelInfo('八戒')
      ..currentJing = 30
      ..currentQi = 30
      ..currentShen = 30,
    FightModelInfo('悟净')
      ..currentJing = 100
      ..currentQi = 0
      ..currentShen = 20,
  ];

  double headW = 60;
  double headH = 60;
  double dividerWidth = 5;
  double dividerHeight = 5;
  late double nameHeight = headH / 2;
  late double proWidth = headH;
  late double proHeight = (headH - nameHeight - dividerHeight * 2) / 3;
  late double itemWidth = headW + proWidth;

  Vector2 viewportSize = Vector2(640, 360);

  late FightStage fightStage;

  late Menu menu;

  @override
  FutureOr<void> onLoad() async {
    fightModels[0].model = await loadModel('kongshou04', 3, 8, 16, 23, 8, 1560.0 / 8, 1560.0 / 8);
    fightModels[1].model = await loadModel('kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
    fightModels[2].model = await loadModel('jian02', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8);
    // fightModels[3].model = await loadModel('jian10', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
    // await loadModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);

    await add(world = World());
    int index = 0;

    await add(
      camera = CameraComponent.withFixedResolution(
        world: world,
        width: viewportSize.x,
        height: viewportSize.y,
        hudComponents: [
          HudMarginComponent(
            size: Vector2(itemWidth * 3 + dividerWidth * 2, headH),
            margin: EdgeInsets.only(bottom: 0, left: dividerWidth),
            children: fightModels.map(
              (e) => oneStatus(index++, e),
            ),
          ),
          HudMarginComponent(size: Menu.menuSize, position: viewportSize / 2 - Vector2(0, Menu.menuSize.y / 2), children: [menu = Menu()])
        ],
      ),
    );
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(
      Background(size: viewportSize),
    );
    Vector2 stageSize = viewportSize - Vector2.all(40);
    world.add(
      fightStage = FightStage(fightModels, position: viewportSize / 2 - stageSize / 2, size: stageSize),
    );
  }

  Component oneStatus(int index, FightModelInfo model) {
    return PositionComponent(
      size: Vector2(itemWidth, headH),
      position: Vector2(itemWidth * index + dividerWidth * index, 0),
      children: [
        Header(size: Vector2.all(headW))..position = Vector2(0, 0),
        TextComponent(text: model.name, position: Vector2(0, headH), anchor: Anchor.bottomLeft, textRenderer: tinyRender),
        ProgressBar(
          model.currentJing,
          model.jing,
          size: Vector2(proWidth, proHeight),
        )..position = Vector2(headW, 0),
        ProgressBar(
          model.currentQi,
          model.qi,
          size: Vector2(proWidth, proHeight),
        )..position = Vector2(headW, proHeight + dividerHeight),
        ProgressBar(
          model.currentShen,
          model.shen,
          size: Vector2(proWidth, proHeight),
        )..position = Vector2(headW, proHeight * 2 + dividerHeight * 2)
      ],
    );
  }

  void onMenuClick(int menu) {
    fightStage.onMenuClick(menu);
  }

  void resetMenu() {
    menu.scale = Vector2(1, 1);
  }
}
