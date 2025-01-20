import 'package:examples/demo/mixins/router-provider.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';

/// Rect文字button
class RectButton extends PositionComponent with TapCallbacks {
  static final Vector2 initSize = Vector2(200, 40);

  RectButton({
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
class RoundedButton extends RectButton {
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
  SpriteButton(Sprite sprite, this.onTap) : super(sprite: sprite, size: Vector2.all(72), priority: 2);

  Function onTap;

  @override
  void onTapUp(TapUpEvent event) {
    onTap();
  }
}

/// Rect文字button
class TextButtonRect extends PositionComponent with TapCallbacks {
  static final Vector2 buttonSize = Vector2(50, 50);

  TextButtonRect(
      {required this.text,
      required this.action,
      required Color color,
      required Color borderColor,
      super.anchor = Anchor.center,
      Vector2? size})
      : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w700,
          ),
        ).toTextPainter(text) {
    this.size = (size ?? buttonSize);
    _textOffset = Offset(
      (this.size.x - _textDrawable.width) / 2,
      (this.size.y - _textDrawable.height) / 2,
    );
    initBg();
    _bgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
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

  void changeColor(Color color) {
    _bgPaint.color = color;
  }

  Color get bgColor => _bgPaint.color;

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
  static Vector2 buttonSize = Vector2(40, 40);

  SimplePathButton(
    this._iconPath, {
    super.position,
    bool? hasBorder,
    double? strokeWidth,
  }) : super(size: buttonSize) {
    this.hasBorder = (hasBorder ?? true);
    _iconPaint.strokeWidth = (strokeWidth ?? 7);
  }

  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = const Color(0xffffffff);

  final Paint _iconPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7
    ..color = const Color(0xffffffff);

  final Path _iconPath;

  void action();

  bool hasBorder = true;

  @override
  void render(Canvas canvas) {
    if (hasBorder) {
      canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)), _borderPaint);
    }
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

/// 返回button
class CloseButton extends SimplePathButton with HasGameRef<RouterProvider> {
  Function onClick;

  CloseButton(this.onClick, {super.hasBorder, super.strokeWidth})
      : super(Path()
          ..moveTo(5, 5)
          ..lineTo(35, 35)
          ..moveTo(5, 35)
          ..lineTo(35, 5));

  @override
  void action() {
    onClick();
  }
}
