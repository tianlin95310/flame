import 'dart:async';

import 'package:examples/demo/game22/story.dart';
import 'package:examples/demo/utils/constant/style.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/layout.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class StoryShow extends PositionComponent with TapCallbacks {
  Vector2 viewportSize;
  StoryItem item;

  StoryShow(this.item, this.viewportSize)
      : super(
          size: Vector2(viewportSize.x * 2 / 3 + viewportSize.y / 5, viewportSize.y / 5 * 2),
          position: Vector2(0, viewportSize.y / 5 * 3),
        );

  StoryScrollTextBox? scrollText;

  Game22? game;

  late SpriteComponent spriteComponent;

  late TextComponent nameComponent;

  @override
  void onMount() {
    super.onMount();
    game = findParent();
  }

  @override
  FutureOr<void> onLoad() async {
    await add(
      AlignComponent(
        child: spriteComponent = SpriteComponent(
          sprite: Sprite(await Flame.images.load(item.head ?? '')),
          size: Vector2(size.y, size.y),
          // scale: Vector2(1.1, 1.1)
        ),
        alignment: Anchor.bottomRight,
      )..priority = 5,
    );
    String text = '${item.name}：';
    add(nameComponent = TextComponent(
      text: text,
      textRenderer: tinyRender,
      // size: tinyRender.measureText(text),
      position: Vector2(0, 25),
        priority: 4
    ));
    show();
  }
  show() {
    if (scrollText?.parent != null) {
      remove(scrollText!);
    }
    add(
      scrollText = StoryScrollTextBox(
        item.content,
        size: size - Vector2(size.y / 2, 0),
      )..anchor = Anchor.topLeft,
    );
    nameComponent.text = '${item.name}：';
    if (item.name.contains('？？？')) {
      spriteComponent.scale = Vector2.zero();
    } else {
      spriteComponent.scale = Vector2.all(1);
      Flame.images.load(item.head ?? '').then((value) => spriteComponent.sprite = Sprite(value));
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (scrollText!.finished == true) {
      game?.onTapUp(event);
    } else {
      if (scrollText?.parent != null) {
        remove(scrollText!);
      }
      add(
        scrollText = StoryScrollTextBox(
          item.content,
          size: size - Vector2(size.y / 2, 0),
          timePerChar: 0,
        )..anchor = Anchor.topLeft,
      );
    }
  }
}

class StoryScrollTextBox extends TextBoxComponent {
  StoryScrollTextBox(
    String text, {
    super.align,
    super.size,
    double? timePerChar,
  }) : super(
          text: text,
          textRenderer: boxRender,
          priority: 3,
          boxConfig: TextBoxConfig(
            timePerChar: timePerChar ?? 0.05,
            margins: const EdgeInsets.only(top: 25, left: 64, right: 25, bottom: 25),
          ),
        );

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, Paint()..color = Colors.white24);
    super.render(canvas);
  }

  @override
  void drawBackground(Canvas c) {
    super.drawBackground(c);
  }
}
