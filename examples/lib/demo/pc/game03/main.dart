import 'package:examples/demo/component/map.dart';
import 'package:examples/demo/component/scroll.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

import 'skills.dart';

class Game03 extends Component {
  late List<PositionComponent> skills = [];

  int colCount = 1;

  @override
  Future<void>? onLoad() async {
    skills = await SkillLoadUtils.getAllSkills();
    List<PositionComponent> skills2 = await SkillLoadUtils.getAllSkills();
    add(StageMap());
    add(ScrollComponentAnchorCenter(
      Axis.vertical,
      skills,
      size: Vector2(100, 300),
      position: Vector2(50, 50),
    ));
    add(ScrollComponentAnchorCenter(
      Axis.horizontal,
        skills2,
      size: Vector2(600, 100),
      position: Vector2(200, 50),
    ));
  }
}
