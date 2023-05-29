import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_demo/component/progress.dart';
import 'package:flame_demo/pc/Game04_RPGVS/model.dart';
import 'package:flutter/painting.dart';

import 'common.dart';
import 'menu.dart';
import 'stage.dart';
import 'vo.dart';
import 'style.dart';

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
  List<FightModelInfo> enemyModels = [
    FightModelInfo('白骨精')
      ..currentJing = 90
      ..currentQi = 100
      ..currentShen = 100,
  ];

  Vector2 viewportSize = Vector2(640, 360);

  late FightStage fightStage;

  late Menu menu;

  late SecondMenu secondMenu;

  @override
  FutureOr<void> onLoad() async {
    fightModels[0].model = BaseRPGModel();
    fightModels[1].model = BaseRPGModel(size: Vector2.all(80));
    fightModels[2].model = BaseRPGModel(size: Vector2.all(100));
    enemyModels[0].model = BaseRPGModel(size: Vector2.all(120));
    // fightModels[1].model = await loadModel('kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
    // fightModels[2].model = await loadModel('jian02', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8);
    // fightModels[3].model = await loadModel('jian10', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
    // enemyModels[0].model = await loadEnemyModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);

    await add(world = World());

    await add(
      camera = CameraComponent.withFixedResolution(
        world: world,
        width: viewportSize.x,
        height: viewportSize.y,
        hudComponents: [
          HudMarginComponent(
            size: CharInfo.infoSize,
            margin: EdgeInsets.only(bottom: 0, left: CharInfo.dividerWidth),
            children: [CharInfo(fightModels)],
          ),
          HudMarginComponent(
              size: Menu.menuSize,
              position: viewportSize / 2 - Vector2(0, Menu.menuSize.y / 2),
              children: [menu = Menu()]),
          HudMarginComponent(
              size: Menu.menuSize,
              position: viewportSize / 2 - Vector2(0, Menu.menuSize.y / 2),
              children: [secondMenu = SecondMenu()])
        ],
      ),
    );
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(Background(size: viewportSize));
    Vector2 stageSize = viewportSize - Vector2.all(40);
    world.add(
      fightStage = FightStage(fightModels, enemyModels, position: viewportSize / 2 - stageSize / 2, size: stageSize),
    );
  }

  void onMenuClick(int menu) {
    if (menu == 0) {
      hideMenu();
    } else if (menu == 1) {
      // hideMenu();
      resetSecondMenu();
    } else if (menu == 2) {
    } else if (menu == 3) {
    } else if (menu == 4) {}
    FutureOr futureOr = fightStage.onMenuClick(menu);
    if (futureOr is Future) {
      futureOr.then((value) {
        fightStage.changeActor();
        resetMenu();
      });
    }
  }

  resetSecondMenu() {}
  void resetMenu() {
    menu.scale = Vector2(1, 1);
  }

  void hideMenu() {
    menu.scale = Vector2(0, 0);
  }
}
