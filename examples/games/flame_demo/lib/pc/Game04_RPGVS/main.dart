import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_demo/pc/Game04_RPGVS/model.dart';
import 'package:flutter/painting.dart';

import 'common.dart';
import 'menu.dart';
import 'stage.dart';
import 'vo.dart';

class DemoGame04 extends Component {
  late World world;

  late CameraComponent camera;

  late BaseRPGModel currentModel;

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

  int current = 0;

  @override
  FutureOr<void> onLoad() async {
    fightModels[0].model = SimpleRPGModel(skills: [
      Skill('横扫千军', [
        Action('run'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
        }),
        Action('attack'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': hit.position.clone()};
        }),
      ]),
      Skill('当头一击', [
        Action('run'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
        }),
        Action('attack'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': hit.position.clone()};
        }),
      ])
    ]);
    fightModels[1].model = SimpleRPGModel(size: Vector2.all(80), skills: [
      Skill('九齿钉耙击', [
        Action('run'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
        }),
        Action('attack'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': hit.position.clone()};
        }),
      ])
    ]);
    fightModels[2].model = SimpleRPGModel(size: Vector2.all(100), skills: [
      Skill('杖击', [
        Action('run'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
        }),
        Action('attack'),
        Action('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
          return {'to': hit.position.clone()};
        }),
      ])
    ]);
    enemyModels[0].model = SimpleRPGModel(size: Vector2.all(120));
    currentModel = fightModels[current].model;
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
            position: viewportSize / 2 - Menu.menuSize / 2,
            children: [menu = Menu()],
          ),
          HudMarginComponent(
            size: SecondMenu.menuSize,
            position: viewportSize / 2 - SecondMenu.menuSize / 2,
            children: [secondMenu = SecondMenu(currentModel, viewportSize)],
          )
        ],
      ),
    );
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(Background(size: viewportSize));
    Vector2 stageSize = viewportSize - Vector2.all(40);
    world.add(
      fightStage =
          FightStage(this, fightModels, enemyModels, position: viewportSize / 2 - stageSize / 2, size: stageSize),
    );
  }

  void onMenuClick(int menu) {
    if (menu == 0) {
      hideMenu();
      FutureOr futureOr = currentModel.basicAttack(enemyModels[0].model);
      if (futureOr is Future) {
        futureOr.then((value) {
          currentModel = fightModels[++current % fightModels.length].model;
          resetMenu();
        });
      }
    } else if (menu == 1) {
      // hideMenu();
      secondMenu.showMenu();
    } else if (menu == 2) {
    } else if (menu == 3) {
    } else if (menu == 4) {}
  }

  void resetMenu() {
    menu.scale = Vector2(1, 1);
  }

  void hideMenu() {
    menu.scale = Vector2(0, 0);
  }

  void onModelSelect(BaseRPGModel rpgModel) {
    currentModel = rpgModel;
    secondMenu.updateCurrentModel(rpgModel);
  }
}
