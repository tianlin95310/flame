import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/pc/game.dart';

import 'common.dart';
import 'menu.dart';
import 'model.dart';
import 'stage.dart';
import 'util.dart';
import 'vo.dart';

class DemoGame04 extends Component with HasGameRef<PCGameEntry> {
  late World world;

  late CameraComponent camera;

  int currentIndex = 0;

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

  static Vector2 viewportSize = Vector2(640, 360);

  late FightStage fightStage;

  late Menu menu;

  late SecondMenu secondMenu;

  @override
  FutureOr<void> onLoad() async {
    init(fightModels, enemyModels);

    await add(world = World());
    currentModel = fightModels[currentIndex].model;
    await add(
      camera = CameraComponent.withFixedResolution(
        world: world,
        width: viewportSize.x,
        height: viewportSize.y,
        hudComponents: [],
      ),
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(Background(size: viewportSize));
    Vector2 stageSize = viewportSize - Vector2.all(40);
    world.add(
      fightStage = FightStage(
        this,
        fightModels,
        enemyModels,
        position: viewportSize / 2 - stageSize / 2,
        size: stageSize,
      ),
    );
    world.add(CharInfo(fightModels));
    world.add(menu = Menu());
    world.add(secondMenu = SecondMenu(currentModel)..hideMenu());
  }

  void onMenuClick(int menuId) {
    print('onMenuClick, menuId = $menuId');
    if (menuId == 0) {
      menu.hideMenu();
      secondMenu.hideMenu();
      FutureOr futureOr = currentModel.basicAttack(enemyModels[0].model);
      if (futureOr is Future) {
        futureOr.then((value) {
          currentModel = fightModels[++currentIndex % fightModels.length].model;
          menu.showMenu();
        });
      } else {
        currentModel = fightModels[++currentIndex % fightModels.length].model;
        menu.showMenu();
      }
    } else if (menuId == 1) {
      secondMenu.showMenu();
      secondMenu.show(menuId);
    } else if (menuId == 2) {
      secondMenu.showMenu();
      secondMenu.show(menuId);
    } else if (menuId == 3) {
      secondMenu.showMenu();
      secondMenu.show(menuId);
    } else if (menuId == 4) {}
  }

  void onModelSelect(BaseRPGModel rpgModel) {
    currentModel = rpgModel;
    secondMenu.updateCurrentModel(rpgModel);
  }
}
