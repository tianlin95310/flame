import 'common.dart';
import 'model.dart';

class BaseModelInfo {
  String name;
  double jing = 100;
  double qi = 100;
  double shen = 100;

  late Header header;

  BaseModelInfo(this.name);
}

class FightModelInfo<T extends BaseRPGModel> extends BaseModelInfo {
  double currentJing = 0;
  double currentQi = 0;
  double currentShen = 0;

  double speed = 300;

  // 1,主角队，2敌人，其他
  int type = 1;

  late T model;

  update() {
    // model.updateInfo
  }

  FightModelInfo(super.name);
}

class Inventory {
  String name;
  int count;
  String type;
  String path;

  Inventory(this.name, this.count, this.type, this.path);
}

