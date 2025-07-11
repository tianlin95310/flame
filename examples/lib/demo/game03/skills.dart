import 'package:examples/demo/utils/constant/blend_mode.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

mixin class BasicSkill {
  double _skillSpeed = 300;

  double get skillSpeed => _skillSpeed;

  void set(double speed) => _skillSpeed = speed;
}

/// 单文件skill，所有帧在一张图片里
class SingleFileSkill extends SpriteAnimationComponent
    with HasGameRef, BasicSkill {
  int? filterColor;
  String path;
  int amount;
  int col;
  Vector2 textureSize;

  SingleFileSkill(
      this.filterColor, this.path, this.amount, this.col, this.textureSize)
      : super(size: Vector2.all(100), anchor: Anchor.center);

  late Rect layoutRect;
  late Paint filterPaint;

  @override
  Future<void>? onLoad() async {
    if (filterColor != null) {
      int color = filterColor!;
      filterPaint = paint;
      if (filterColor == 0xFF000000) {
        paint.color = Color(color);
        paint.blendMode = blendModeS[3];
      } else if (filterColor == 0xFFFFFFFF) {
        filterPaint.color = Color(color);
        filterPaint.blendMode = blendModeS[17];
      }
    }
    layoutRect = Rect.fromLTRB(0, 0, size.x, size.y);
    animation = await gameRef.loadSpriteAnimation(
      path,
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        amountPerRow: col,
        textureSize: textureSize,
      ),
    );
  }

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    canvas.save();
    super.render(canvas);
    if (filterColor != null) {
      canvas.drawRect(layoutRect, filterPaint);
    }
    canvas.restore();
  }
}

/// 多文件skill，帧分在不同的文件里
class MulFileSkill extends PositionComponent with HasPaint, BasicSkill {
  List<Sprite> frames = [];

  double flyingSpriteIndex = 0;

  int flameSpeed = 10;

  MulFileSkill() : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    frames[flyingSpriteIndex.toInt()].renderRect(canvas, Rect.fromLTRB(0, 0, size.x, size.y));
  }

  @override
  void update(double dt) {
    flyingSpriteIndex += flameSpeed * dt;
    if (flyingSpriteIndex > frames.length) {
      flyingSpriteIndex = 0;
    }
  }
}

/// 加载器
class SkillLoadUtils {
  static Future<List<PositionComponent>> getAllSkills() async {
    List<PositionComponent> muls = await getAllSkillMulFile();
    List<PositionComponent> sigs = loadAllSkillSingleFile();
    return muls..addAll(sigs);
  }

  static Future<List<PositionComponent>> getAllSkillMulFile() async {
    return [
      // await mulFileSkill('crtz', 14),
      // await mulFileSkill('feidao', 15),
    ];
  }

  static Future<PositionComponent> mulFileSkill(name, int frameCount) async {
    MulFileSkill skill = MulFileSkill();
    for (int i = 0; i < frameCount; i++) {
      String fileName = (i + 1).toString().padLeft(3, '0');
      skill.frames.add(Sprite(await Flame.images.load('mulSkill/$name/s${fileName}.png')));
    }
    return skill;
  }

  static List<PositionComponent> loadAllSkillSingleFile() {
    return [
      // skillSingleFile('sk001.png', 4, 4, 0, 15, 16, 128.0, 128.0, filterColor: 0xFF000000),
      // skillSingleFile('sk002.png', 3, 5, 0, 10, 11, 192.0, 192.0),
      // skillSingleFile('sk003.png', 4, 5, 0, 16, 17, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk004.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk005.png', 2, 5, 0, 6, 7, 192.0, 192.0),
      //
      // skillSingleFile('sk006.png', 2, 5, 0, 9, 10, 192.0, 192.0),
      // skillSingleFile('sk007.png', 4, 5, 0, 16, 17, 192, 192, filterColor: 0xFF000000),
      // skillSingleFile('sk008.png', 3, 5, 0, 14, 15, 192, 192, filterColor: 0xFF000000),
      // skillSingleFile('sk009.jpg', 2, 5, 0, 5, 6, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk010.png', 2, 5, 0, 6, 7, 192.0, 192.0),
      //
      // skillSingleFile('sk011.png', 5, 5, 0, 21, 22, 192.0, 192.0),
      // skillSingleFile('sk012.png', 2, 5, 0, 7, 8, 192.0, 192.0),
      // skillSingleFile('sk013.png', 2, 5, 0, 9, 10, 192.0, 192.0),
      // skillSingleFile('sk014.png', 7, 5, 0, 31, 32, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk015.png', 7, 5, 0, 34, 35, 192.0, 192.0),
      //
      // skillSingleFile('sk016.png', 4, 5, 0, 19, 20, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk017.jpg', 3, 5, 0, 15, 16, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk018.jpg', 4, 5, 0, 19, 20, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk019.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk020.png', 3, 5, 0, 12, 13, 192.0, 192.0),
      //
      // skillSingleFile('sk021.jpg', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk022.png', 8, 5, 0, 39, 40, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk023.png', 5, 5, 0, 23, 24, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk024.png', 4, 5, 0, 15, 16, 192.0, 192.0),
      // skillSingleFile('sk025.png', 9, 5, 0, 41, 42, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk026.png', 8, 8, 0, 63, 64, 200.0, 200.0, filterColor: 0xFF000000),
      // skillSingleFile('sk027.png', 4, 5, 0, 19, 20, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk028.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk029.jpg', 1, 5, 0, 4, 5, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk030.png', 4, 5, 0, 17, 18, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk031.png', 9, 5, 0, 42, 43, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk032.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk033.png', 8, 5, 0, 35, 36, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk034.png', 2, 5, 0, 6, 7, 192.0, 192.0),
      // skillSingleFile('sk035.png', 4, 5, 0, 16, 17, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk036.png', 3, 5, 0, 12, 13, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk037.png', 7, 5, 0, 33, 34, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk038.png', 8, 5, 0, 39, 40, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk039.png', 4, 5, 0, 15, 16, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk040.jpg', 2, 5, 0, 6, 7, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk041.png', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk042.png', 4, 5, 0, 19, 20, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk043.png', 3, 5, 0, 14, 15, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk044.png', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk045.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk046.jpg', 3, 5, 0, 14, 15, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk047.png', 6, 5, 0, 29, 30, 192.0, 192.0),
      // skillSingleFile('sk048.png', 4, 5, 0, 19, 20, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk049.png', 3, 5, 0, 13, 14, 192.0, 192.0),
      // skillSingleFile('sk050.png', 2, 5, 0, 6, 7, 192.0, 192.0),
      //
      // skillSingleFile('sk051.png', 8, 5, 0, 39, 40, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk052.png', 3, 5, 0, 14, 15, 192.0, 192.0),
      // skillSingleFile('sk053.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk054.png', 5, 5, 0, 22, 23, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk055.bmp', 6, 5, 0, 26, 27, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk056.png', 5, 5, 0, 23, 24, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk057.png', 8, 5, 0, 38, 39, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk058.png', 7, 5, 0, 34, 35, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk059.png', 8, 5, 0, 39, 40, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk060.png', 8, 5, 0, 36, 37, 192.0, 192.0, filterColor: 0xFF000000),
      //
      skillSingleFile('sk061.png', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk062.png', 4, 5, 0, 15, 16, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk063.png', 9, 5, 0, 41, 42, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk064.png', 4, 5, 0, 17, 18, 192.0, 192.0),
      // skillSingleFile('sk065.png', 3, 5, 0, 12, 13, 192.0, 192.0),
      //
      // skillSingleFile('sk066.png', 5, 5, 0, 22, 23, 192.0, 192.0),
      // skillSingleFile('sk067.png', 3, 5, 0, 10, 11, 192.0, 192.0),
      // skillSingleFile('sk068.png', 4, 5, 0, 19, 20, 192, 192, filterColor: 0xFF000000),
      // skillSingleFile('sk069.png', 6, 5, 0, 25, 26, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk070.png', 3, 5, 0, 14, 15, 192.0, 192.0),
      //
      // skillSingleFile('sk071.png', 7, 5, 0, 34, 35, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk072.jpg', 3, 5, 0, 11, 12, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk073.png', 4, 5, 0, 19, 20, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk074.jpg', 2, 5, 0, 9, 10, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk075.png', 5, 5, 0, 24, 25, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk076.png', 6, 5, 0, 27, 25, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk077.jpg', 2, 5, 0, 7, 8, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk078.jpg', 2, 5, 0, 9, 10, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk079.png', 8, 5, 0, 38, 39, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk080.jpg', 2, 5, 0, 8, 9, 192.0, 192.0, filterColor: 0xFF000000),
      //
      // skillSingleFile('sk081.jpg', 3, 5, 0, 14, 15, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk082.jpg', 2, 5, 0, 8, 9, 192.0, 192.0, filterColor: 0xFF000000),
      // skillSingleFile('sk083.jpg', 2, 5, 0, 8, 9, 192.0, 192.0, filterColor: 0xFF000000),

      // skillSingleFileTemp('baopo_01.png', 4, 4, 0, 15, 16, 512 / 4, 512 / 4, filterColor: 0xFF000000),
      // skillSingleFileTemp('bowen.png', 5, 5, 0, 24, 25, 256 / 5, 256 / 5, filterColor: 0xFF000000),
      // skillSingleFileTemp('dkjg_suipian.png', 4, 4, 0, 15, 16, 512 / 4, 512 / 4),
      // skillSingleFileTemp('dy_water1.png', 4, 4, 0, 15, 16, 512 / 4, 512 / 4),
      // skillSingleFileTemp('feichuansgx.png', 4, 4, 0, 12, 13, 510 / 4, 474 / 4),
    ];
  }

  static PositionComponent skillSingleFile(file, row, int col, startIndex, endIndex,
      int totalCount, double frameWidth, double frameHeight,
      {int? filterColor}) {
    return SingleFileSkill(
      filterColor,
      'demo/singleSkill/$file',
      totalCount,
      col,
      Vector2(frameWidth, frameHeight),
    );
  }

  static PositionComponent skillSingleFileTemp(file, row, int col, startIndex, endIndex,
      int totalCount, double frameWidth, double frameHeight,
      {int? filterColor}) {
    return SingleFileSkill(
      filterColor,
      'temp/$file',
      totalCount,
      col,
      Vector2(frameWidth, frameHeight),
    );
  }
}
