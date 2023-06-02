import 'package:flame/components.dart';

import 'model.dart';
import 'vo.dart';

void init(List<FightModelInfo> fightModels, List<FightModelInfo> enemyModels) {
  fightModels[0].model = SimpleRPGModel(skills: [
    SkillVo('横扫千军', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ],),
    SkillVo('当头一击', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ])
  ], spells: [
    SpellVo('金', '金技能1', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('金', '金技能2', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('火', '火技能1', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('火', '火技能2', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('火', '火技能3', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('火', '火技能4', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('火', '火技能5', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ]),
    SpellVo('火', '火技能6', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ])
  ]..forEach((element) => element.type = 2));
  fightModels[1].model = SimpleRPGModel(size: Vector2.all(80), skills: [
    SkillVo('九齿钉耙击', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ])
  ]);
  fightModels[2].model = SimpleRPGModel(size: Vector2.all(100), skills: [
    SkillVo('杖击', [
      BasicActionVo('run'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': takeHit.position - Vector2(hit.size.x / 2, 0)};
      }),
      BasicActionVo('attack'),
      BasicActionVo('rush', translate: (BaseRPGModel hit, BaseRPGModel takeHit) {
        return {'to': hit.position.clone()};
      }),
    ])
  ]);
  enemyModels[0].model = SimpleRPGModel(size: Vector2.all(120));

  // fightModels[1].model = await loadModel('kongshou06', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
  // fightModels[2].model = await loadModel('jian02', 3, 8, 16, 23, 8, 1400.0 / 8, 1400.0 / 8);
  // fightModels[3].model = await loadModel('jian10', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8);
  // enemyModels[0].model = await loadEnemyModel('shanzi03', 3, 8, 16, 23, 8, 1120.0 / 8, 1120.0 / 8);
}