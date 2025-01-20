import 'dart:async';

import 'package:examples/demo/constant/style.dart';
import 'package:examples/demo/pc/game21/skill.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

class Game15 extends Component with HasGameRef, HasPaint {
  int colCount = 8;

  @override
  FutureOr<void> onLoad() {
    int index = 0;
    for (var element in BlendMode.values) {
      int row = index ~/ colCount;
      int col = index % colCount;
      add(AtlasSprite(index)..position = Vector2(col * 200, row * 200));

      // add(SingleFileSkill(index, 0xFF000000, 'singleSkill/sk001.png', 16, 4, Vector2(128.0, 128.0))
      //   ..position = Vector2(col * 200, row * 200)
      //   ..anchor = Anchor.topLeft);
      // add(SingleFileSkill(index, 0xFF000000, 'singleSkill/sk003.png', 17, 5, Vector2(192.0, 192.0))
      //   ..position = Vector2(col * 200, row * 200)
      //   ..anchor = Anchor.topLeft);
      index++;
    }
    paint.color = const Color(0xff445500);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(game.canvasSize.toRect(), paint);
  }
}

/// 单文件skill，所有帧在一张图片里
class SingleFileSkill extends SpriteAnimationComponent with HasGameRef, BasicSkill {
  int? filterColor;
  String path;
  int amount;
  int col;
  Vector2 textureSize;

  int index = 0;

  SingleFileSkill(this.index, this.filterColor, this.path, this.amount, this.col, this.textureSize)
      : super(size: Vector2.all(100), anchor: Anchor.center);

  late Rect layoutRect;

  @override
  Future<void>? onLoad() async {
    paint.color = Color(filterColor!);
    paint.blendMode = BlendMode.values[index % BlendMode.values.length];

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

    add(
      TextComponent(
          text: 'Mode$index = ${BlendMode.values[index].name}', anchor: Anchor.center, textRenderer: middleRender)
        ..position = size / 2,
    );
  }

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    canvas.save();
    super.render(canvas);
    canvas.drawRect(layoutRect, paint);
    canvas.restore();
  }
}

class AtlasSprite extends SpriteComponent {
  late Sprite sprite_;

  int index = 0;

  AtlasSprite(this.index);

  @override
  FutureOr<void> onLoad() async {
    Sprite sprite = Sprite(await Flame.images.load('icons/port.png'));
    sprite_ = Sprite(await Flame.images.load('icons/port!a.png'));
    this.sprite = sprite;
    size = sprite.originalSize..scaleTo(200);

    add(
      TextComponent(
          text: 'Mode$index = ${BlendMode.values[index].name}', anchor: Anchor.center, textRenderer: middleRender)
        ..position = size / 2,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    super.render(canvas);
    // blendPaint.blendMode = BlendMode.values[index % BlendMode.values.length];
    // sprite_.render(canvas, size: size, overridePaint: blendPaint);
    paint.color = const Color(0xFF000000);
    paint.blendMode = BlendMode.values[index % BlendMode.values.length];
    canvas.drawRect(size.toRect(), paint);
    canvas.restore();
  }
}
