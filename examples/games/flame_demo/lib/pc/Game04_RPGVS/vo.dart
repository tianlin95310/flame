import 'package:flame/components.dart';

import 'common.dart';
import 'model.dart';

class BaseModelInfo {
  String name;
  double jing = 100;
  double qi = 100;
  double shen = 100;

  late BaseRPGModel model;
  late Header header;

  BaseModelInfo(this.name);
}

class FightModelInfo extends BaseModelInfo {
  double currentJing = 0;
  double currentQi = 0;
  double currentShen = 0;

  FightModelInfo(super.name);
}

class Inventory {
  String name;
  int count;
  String type;
  String path;

  Inventory(this.name, this.count, this.type, this.path);
}

