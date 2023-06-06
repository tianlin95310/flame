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

  FightModelInfo? currentModel;

  List<FightModelInfo> fightModels = [
    // FightModelInfo('三藏')
    //   ..currentJing = 30
    //   ..currentQi = 40
    //   ..currentShen = 50,
    FightModelInfo('悟空')
      ..speed = 100
      ..currentJing = 50
      ..currentQi = 60
      ..currentShen = 70,
    FightModelInfo('八戒')
      ..speed = 60
      ..currentJing = 30
      ..currentQi = 30
      ..currentShen = 30,
    FightModelInfo('悟净')
      ..speed = 70
      ..currentJing = 100
      ..currentQi = 0
      ..currentShen = 20,
  ];
  List<FightModelInfo> enemyModels = [
    FightModelInfo('白骨精')
      ..type = 2
      ..speed = 60
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

    world.add(
      fightStage = FightStage(this, fightModels, enemyModels),
    );
    world.add(CharInfo(fightModels));
    world.add(menu = Menu()..hideMenu());
    world.add(secondMenu = SecondMenu(currentModel, onSecondMenu)..hideMenu());
  }

  void onSecondMenu(int type, dynamic params) {
    menu.hideMenu();
    secondMenu.hideMenu();
    if (type == 1) {
      SkillVo skillVo = params;
      Toast.showToast('${currentModel?.name}使用了${skillVo.name}', camera);
    } else if (type == 2) {
      SpellVo spellVo = params;
      Toast.showToast('${currentModel?.name}使用了${spellVo.name}', camera);
    } else if (type == 3) {
      Inventory inventory = params;
      Toast.showToast('${currentModel?.name}使用了${inventory.name}', camera);
    }
    Future.delayed(const Duration(seconds: 2)).then((value) => fightStage.resume());
  }

  void onMenuClick(int menuId) {
    print('onMenuClick, menuId = $menuId');
    if (menuId == 0) {
      Toast.showToast('${currentModel?.name}使用普通攻击', camera);
      menu.hideMenu();
      secondMenu.hideMenu();
      FutureOr futureOr = currentModel?.model.basicAttack(enemyModels[0].model);
      if (futureOr is Future) {
        futureOr.then((value) {
          fightStage.resume();
        });
      } else {
        currentModel = fightModels[++currentIndex % fightModels.length];
        fightStage.resume();
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

  void onModelSelect(FightModelInfo rpgModel) {
    currentModel = rpgModel;
    secondMenu.updateCurrentModel(rpgModel);
  }

  void onTurnsWho(FightModelInfo model) {
    if (model.type == 2) {
      currentModel = null;
      secondMenu.updateCurrentModel(model);
      Toast.showToast('${model.name}释放了一个技能', camera);
      Future.delayed(const Duration(seconds: 2)).then((value) => fightStage.resume());
    } else {
      currentModel = model;
      secondMenu.updateCurrentModel(model);
      menu.showMenu();
    }
  }
}
