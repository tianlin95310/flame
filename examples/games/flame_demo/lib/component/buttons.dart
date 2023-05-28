import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_demo/mixins/RouterProvider.dart';
import 'package:flutter/rendering.dart';

/// Rect文字button
class Button extends PositionComponent with TapCallbacks {
  static final Vector2 initSize = Vector2(200, 40);
  Button({
    required this.text,
    required this.action,
    required Color color,
    required Color borderColor,
    super.anchor = Anchor.center,
  }) : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w700,
          ),
        ).toTextPainter(text) {
    size = initSize;
    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );
    initBg();
    _bgPaint = Paint()..color = color;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;
  }

  final String text;
  final void Function() action;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final Rect _rect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // position.x = position.x - this.size.x / 2;
    // position.x = size.x / 2;
  }

  @override
  void render(Canvas canvas) {
    drawBg(canvas);
    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
    priority = 9999;
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }

  initBg() {
    _rect = Rect.fromLTRB(0, 0, size.x, size.y);
  }

  void drawBg(Canvas canvas) {
    canvas.drawRect(_rect, _bgPaint);
    canvas.drawRect(_rect, _borderPaint);
  }
}

/// Round文字button
class RoundedButton extends Button {
  late final RRect _rrect;

  RoundedButton({
    required super.text,
    required super.action,
    required super.color,
    required super.borderColor,
  });

  @override
  initBg() {
    _rrect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 2));
  }

  @override
  void drawBg(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
  }
}

/// SpriteButton
class SpriteButton extends SpriteComponent with TapCallbacks {
  SpriteButton(Sprite sprite, this.onTap)
      : super(sprite: sprite, size: Vector2.all(72), priority: 2);

  Function onTap;

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

/// Rect文字button
class TextButtonRect extends PositionComponent with TapCallbacks {
  static final Vector2 initSize = Vector2(50, 50);
  TextButtonRect({
    required this.text,
    required this.action,
    required Color color,
    required Color borderColor,
    super.anchor = Anchor.center,
  }) : _textDrawable = TextPaint(
    style: const TextStyle(
      fontSize: 16,
      color: Color(0xFF000000),
      fontWeight: FontWeight.w700,
    ),
  ).toTextPainter(text) {
    size = initSize;
    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );
    initBg();
    _bgPaint = Paint()..color = color;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;
  }

  final String text;
  final void Function() action;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final Rect _rect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // position.x = position.x - this.size.x / 2;
    // position.x = size.x / 2;
  }

  @override
  void render(Canvas canvas) {
    drawBg(canvas);
    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
    priority = 9999;
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }

  initBg() {
    _rect = Rect.fromLTRB(0, 0, size.x, size.y);
  }

  void drawBg(Canvas canvas) {
    canvas.drawRect(_rect, _bgPaint);
    canvas.drawRect(_rect, _borderPaint);
  }
}


/// 简单path路径button
abstract class SimplePathButton extends PositionComponent with TapCallbacks {
  SimplePathButton(this._iconPath, {super.position})
      : super(size: Vector2(40, 40));

  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = const Color(0xffffffff);

  final Paint _iconPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xffffffff);

  final Path _iconPath;
  void action();

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)), _borderPaint);
    canvas.drawPath(_iconPath, _iconPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _iconPaint.color = const Color(0xffaaaaaa);
    _borderPaint.color = const Color(0xffaaaaaa);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _iconPaint.color = const Color(0xffffffff);
    _borderPaint.color = const Color(0xffffffff);
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _iconPaint.color = const Color(0xffffffff);
    _borderPaint.color = const Color(0xffffffff);
  }
}

/// 返回button
class BackButton extends SimplePathButton with HasGameRef<RouterProvider> {
  BackButton()
      : super(Path()
          ..moveTo(22, 8)
          ..lineTo(10, 20)
          ..lineTo(22, 32)
          ..moveTo(12, 20)
          ..lineTo(34, 20));
  @override
  void action() {
    gameRef.router.pop();
  }
}
