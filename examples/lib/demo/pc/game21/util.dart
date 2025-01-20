import 'dart:ui';

import 'package:flame/components.dart';

import 'model.dart';
import 'vo.dart';

var basicSkill = [
  BasicActionVo('run'),
  BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
    return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
  }),
  BasicActionVo('attack'),
  BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
    return {'to': hit.position.clone()};
  }),
];

void init(List<FightModelInfo> fightModels, List<FightModelInfo> enemyModels) {
  fightModels[0]
    ..speed = 150
    ..jing = 2000
    ..currentJing = 2000
    ..currentQi = 60
    ..currentShen = 70
    ..model = SimpleRPGModel(
      color: const Color(0xffffff00),
      skills: [SkillVo('横扫千军', basicSkill, 500), SkillVo('当头一击', basicSkill, 800)],
      spells: [
        SpellVo('金', '金技能1', basicSkill, 100),
        SpellVo('金', '金技能2', basicSkill, 100),
        SpellVo('火', '火技能1', basicSkill, 100),
        SpellVo('火', '火技能2', basicSkill, 100),
        SpellVo('火', '火技能3', basicSkill, 100),
        SpellVo('火', '火技能4', basicSkill, 100),
        SpellVo('火', '火技能5', basicSkill, 100),
        SpellVo('火', '火技能6', basicSkill, 100)
      ]..forEach((element) => element.type = 2),
    );
  fightModels[1]
    ..speed = 120
    ..jing = 1000
    ..currentJing = 800
    ..currentQi = 30
    ..currentShen = 30
    ..model = SimpleRPGModel(
      color: const Color(0xffff00ff),
      size: Vector2.all(80),
      skills: [SkillVo('九齿钉耙击', basicSkill, 100)],
    );
  fightModels[2]
    ..speed = 130
    ..jing = 800
    ..currentJing = 800
    ..currentQi = 0
    ..currentShen = 20
    ..model = SimpleRPGModel(
      color: const Color(0xff00ffff),
      size: Vector2.all(100),
      skills: [SkillVo('杖击', basicSkill, 100)],
    );

  enemyModels[0]
    ..type = 2
    ..speed = 150
    ..jing = 1200
    ..currentJing = 1200
    ..currentQi = 100
    ..currentShen = 100
    ..model = EnemySimpleRPGModel(
      color: const Color(0xffff0000),
      enemyModels[0],
      size: Vector2(120, 130),
      skills: [
        SkillVo('九阴白骨爪', basicSkill, 200),
      ],
    );

  // fightModels[1].model = await loadModel('kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
  // fightModels[2].model = await loadModel('jian02', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8);
  // fightModels[3].model = await loadModel('jian10', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
  // enemyModels[0].model = await loadEnemyModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);
}
