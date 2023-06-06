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
  fightModels[0].model = SimpleRPGModel(
    skills: [
      SkillVo(
        '横扫千军',
        basicSkill,
      ),
      SkillVo('当头一击', basicSkill)
    ],
    spells: [
      SpellVo('金', '金技能1', basicSkill),
      SpellVo('金', '金技能2', basicSkill),
      SpellVo('火', '火技能1', basicSkill),
      SpellVo('火', '火技能2', basicSkill),
      SpellVo('火', '火技能3', basicSkill),
      SpellVo('火', '火技能4', basicSkill),
      SpellVo('火', '火技能5', basicSkill),
      SpellVo('火', '火技能6', basicSkill)
    ]..forEach((element) => element.type = 2),
  );
  fightModels[1].model = SimpleRPGModel(
    size: Vector2.all(80),
    skills: [SkillVo('九齿钉耙击', basicSkill)],
  );
  fightModels[2].model = SimpleRPGModel(
    size: Vector2.all(100),
    skills: [SkillVo('杖击', basicSkill)],
  );

  enemyModels[0].model = SimpleRPGModel(
    size: Vector2.all(120),
    skills: [
      SkillVo(
        '九阴白骨爪',
        basicSkill,
      ),
    ],
  );

  // fightModels[1].model = await loadModel('kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
  // fightModels[2].model = await loadModel('jian02', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8);
  // fightModels[3].model = await loadModel('jian10', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
  // enemyModels[0].model = await loadEnemyModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);
}
