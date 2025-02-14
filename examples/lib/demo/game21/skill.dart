import 'package:examples/demo/utils/constant/blend_mode.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

mixin class BasicSkill {
  double _skillSpeed = 300;

  double get skillSpeed => _skillSpeed;

  void set(double speed) => _skillSpeed = speed;
}

/// 单文件skill，所有帧在一张图片里
class SingleFileSkill extends SpriteAnimationComponent with HasGameRef, BasicSkill {
  int? filterColor;
  String path;
  int amount;
  int col;
  Vector2 textureSize;

  SingleFileSkill(this.filterColor, this.path, this.amount, this.col, this.textureSize)
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

Future<PositionComponent> mulFileSkill(name, int frameCount) async {
  MulFileSkill skill = MulFileSkill();
  for (int i = 0; i < frameCount; i++) {
    String fileName = (i + 1).toString().padLeft(3, '0');
    skill.frames.add(Sprite(await Flame.images.load('mulSkill/$name/s${fileName}.png')));
  }
  return skill;
}

PositionComponent skillSingleFile(file, row, int col, startIndex, endIndex, int totalCount, double frameWidth, double frameHeight, {int? filterColor}) {
  return SingleFileSkill(
    filterColor,
    'singleSkill/$file',
    totalCount,
    col,
    Vector2(frameWidth, frameHeight),
  );
}
