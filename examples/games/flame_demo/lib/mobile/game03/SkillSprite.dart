import 'package:flame/components.dart';
import 'package:flame_demo/utils/utils.dart';
import 'package:flutter/material.dart';

class SkillSprite extends SpriteAnimationComponent with HasGameRef {
  int? filterColor;
  String path;
  int amount;
  int col;
  Vector2 textureSize;

  SkillSprite(
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
    // print('layoutRect = ' + layoutRect.toString());
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
      // print('layoutRect = ' + layoutRect.toString());
      // print(filterColor);
      canvas.drawRect(layoutRect, filterPaint);
    }
    canvas.restore();
  }
}

class SkillMulFile extends PositionComponent with HasPaint{
  List<Sprite> frames = [];

  double flyingSpriteIndex = 0;

  int skillSpeed = 10;

  SkillMulFile() : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    frames[flyingSpriteIndex.toInt()].renderRect(canvas, Rect.fromLTRB(0, 0, size.x, size.y));
  }

  @override
  void update(double dt) {
    flyingSpriteIndex += skillSpeed * dt;
    if (flyingSpriteIndex > frames.length) {
      flyingSpriteIndex = 0;
    }
  }
}
