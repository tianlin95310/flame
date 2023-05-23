import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'ModelSprite.dart';

class ModelLoadUtils {
  static Future<List<ModelSprite>> loadAllModels() async {
    return [
      await loadModel('fe_bian01', 3, 8, 16, 23, 8, 1440.0 / 8, 1440.0 / 8),
    ];
  }

  static Future<ModelSprite> loadModel(name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async{

    final spriteSheetStand = SpriteSheet(image: await Flame.images.load('models/singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetRun = SpriteSheet(image: await Flame.images.load('models/singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetAttack = SpriteSheet(image: await Flame.images.load('models/singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));
    Map<CharBasicAnimation, SpriteAnimation> sprites = {
      CharBasicAnimation.standLeft: spriteSheetStand.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.standRight: spriteSheetStand.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.runLeft: spriteSheetRun.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.runRight: spriteSheetRun.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.attackLeft: spriteSheetAttack.createAnimation(row: 1, to: 7, stepTime: 0.1, loop: false) ,
      CharBasicAnimation.attackRight: spriteSheetAttack.createAnimation(row: 2, to: 7, stepTime: 0.1, loop: false),
    };
    ModelSprite model = ModelSprite(animations: sprites);
    return model;
  }


  static Future<ModelSpriteAndroid> loadAndroidModel(name, imgRow, imgColumn, startIndex, endIndex, frameCount, double frameWidth, double frameHeight) async{

    final spriteSheetStand = SpriteSheet(image: await Flame.images.load('models/singleModel/$name/stand.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetRun = SpriteSheet(image: await Flame.images.load('models/singleModel/$name/run.png'), srcSize: Vector2(frameWidth, frameHeight));
    final spriteSheetAttack = SpriteSheet(image: await Flame.images.load('models/singleModel/$name/attack.png'), srcSize: Vector2(frameWidth, frameHeight));

    Map<CharBasicAnimation, SpriteAnimation> sprites = {
      CharBasicAnimation.standLeft: spriteSheetStand.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.standRight: spriteSheetStand.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.runLeft: spriteSheetRun.createAnimation(row: 1, to: 7, stepTime: 0.1),
      CharBasicAnimation.runRight: spriteSheetRun.createAnimation(row: 2, to: 7, stepTime: 0.1),
      CharBasicAnimation.attackLeft: spriteSheetAttack.createAnimation(row: 1, to: 7, stepTime: 0.1, loop: false) ,
      CharBasicAnimation.attackRight: spriteSheetAttack.createAnimation(row: 2, to: 7, stepTime: 0.1, loop: false),
    };
    ModelSpriteAndroid model = ModelSpriteAndroid(animations: sprites);

    return model;
  }
}
