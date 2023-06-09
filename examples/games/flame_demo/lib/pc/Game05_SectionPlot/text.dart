import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../common/style.dart';
import 'main.dart';

class StoryShow extends PositionComponent with TapCallbacks {
  Vector2 viewportSize;
  String content;

  StoryShow(this.content, this.viewportSize)
      : super(
          size: Vector2(viewportSize.x * 2 / 3, viewportSize.y / 2),
          position: Vector2(0, viewportSize.y / 2),
        );

  StoryScrollTextBox? scrollText;

  DemoGame05? game;

  @override
  void onMount() {
    super.onMount();
    game = findParent();
  }

  @override
  FutureOr<void> onLoad() async {
    show();
  }

  show() {
    if (scrollText?.parent != null) {
      remove(scrollText!);
    }
    add(
      scrollText = StoryScrollTextBox(
        content,
        size: size,
      )..anchor = Anchor.topLeft,
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (scrollText == null) {
      return;
    }
    if (scrollText!.finished) {
      game?.onTapUp(event);
    } else {
      if (scrollText?.parent != null) {
        remove(scrollText!);
      }
      add(
        scrollText = StoryScrollTextBox(
          content,
          size: size,
          timePerChar: 0
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
    double? margins,
  }) : super(
          text: text,
          textRenderer: boxRender,
          boxConfig: TextBoxConfig(
            timePerChar: timePerChar ?? 0.05,
            margins: EdgeInsets.all(margins ?? 16),
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
