import 'dart:async';
import 'dart:math';

import 'package:examples/demo/game.dart';
import 'package:flame/components.dart';

import 'common.dart';
import 'menu.dart';
import 'model.dart';
import 'stage.dart';
import 'util.dart';
import 'vo.dart';

class Game21 extends Component with HasGameRef<PCGameEntry> {
  late World world;

  late CameraComponent camera;

  int currentIndex = 0;

  FightModelInfo? currentModel;

  List<FightModelInfo> fightModels = [
    // FightModelInfo('三藏')
    FightModelInfo('悟空'),
    FightModelInfo('八戒'),
    FightModelInfo('悟净'),
  ];
  List<FightModelInfo<EnemySimpleRPGModel>> enemyModels = [
    FightModelInfo('白骨精'),
  ];

  static Vector2 viewportSize = Vector2(640, 360);

  late FightStage fightStage;

  late Menu menu;

  late SecondMenu secondMenu;

  late CharInfo charInfo;

  late void Function(bool value) completeWith;

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
    world.add(charInfo = CharInfo(fightModels));
    world.add(menu = Menu()..hideMenu());
    world.add(secondMenu = SecondMenu(currentModel, onSecondMenu)..hideMenu());
  }

  chargeWin() {
    if (enemyModels[0].currentJing <= 0) {
      Toast.showToast('战斗结束了,你获得了胜利', camera);
      // game.overlays.add('gameWin');
      // gameRef.router.pop();
      completeWith(true);
    }
    print('left: ${enemyModels[0].currentJing}');
  }

  void onSecondMenu(int type, dynamic params) {
    menu.hideMenu();
    secondMenu.hideMenu();
    if (type == 1) {
      var skillVo = params as SkillVo;
      Toast.showToast('${currentModel?.name}使用了${skillVo.name}', camera);
      enemyModels[0].currentJing -= skillVo.damage;
      enemyModels[0].model.updateInfo();
      chargeWin();
    } else if (type == 2) {
      var spellVo = params as SpellVo;
      Toast.showToast('${currentModel?.name}使用了${spellVo.name}', camera);
      enemyModels[0].currentJing -= spellVo.damage;
      enemyModels[0].model.updateInfo();
      chargeWin();
    } else if (type == 3) {
      var inventory = params as Inventory;
      Toast.showToast('${currentModel?.name}使用了${inventory.name}', camera);
    }
    chargeWin();
    Future.delayed(const Duration(seconds: 2)).then((value) => fightStage.resume());
  }

  void onMenuClick(int menuId) {
    print('onMenuClick, menuId = $menuId');
    if (menuId == 0) {
      // Toast.showToast('${currentModel?.name}使用普通攻击', camera);
      menu.hideMenu();
      secondMenu.hideMenu();
      FutureOr futureOr = currentModel?.model.basicAttack(enemyModels[0].model);
      if (futureOr is Future) {
        futureOr.then((value) {
          enemyModels[0].currentJing -= currentModel!.model.basic.damage;
          enemyModels[0].model.updateInfo();
          chargeWin();
          fightStage.resume();
        });
      } else {
        enemyModels[0].currentJing -= currentModel!.model.basic.damage;
        enemyModels[0].model.updateInfo();
        chargeWin();
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
    } else if (menuId == 4) {

    }
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
      fightModels[Random().nextInt(3)].currentJing -= enemyModels[0].model.skills[0].damage;
      charInfo.updateInfo();
      Future.delayed(const Duration(seconds: 2)).then((value) => fightStage.resume());
    } else {
      currentModel = model;
      secondMenu.updateCurrentModel(model);
      menu.showMenu();
    }
  }
}
