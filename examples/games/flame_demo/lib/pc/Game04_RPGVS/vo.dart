import 'package:flame/components.dart';

import 'common.dart';

class BaseModelInfo {
  String name;
  double jing = 100;
  double qi = 100;
  double shen = 100;

  late PositionComponent model;
  late Header header;

  BaseModelInfo(this.name);
}

class FightModelInfo extends BaseModelInfo {
  double currentJing = 0;
  double currentQi = 0;
  double currentShen = 0;

  FightModelInfo(super.name);
}

