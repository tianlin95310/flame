
import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flame_demo/mixins/paint.dart';

import 'main.dart';

class Menu extends PositionComponent with BgPaint {
  static final menuSize = Vector2(150, 150);
  Vector2 buttonSize = TextButtonRect.initSize;

  Menu() : super(size: menuSize);

  @override
  FutureOr<void> onLoad() async {
    addAll([
      getButton('击', () {
        onMenuClick(0);
      })
        ..position = center,
      getButton('技', () {
        onMenuClick(1);
      })
        ..position = center - Vector2(0, buttonSize.y),
      getButton('术', () {
        onMenuClick(2);
      })
        ..position = center + Vector2(buttonSize.x, 0),
      getButton('物', () {
        onMenuClick(3);
      })
        ..position = center - Vector2(buttonSize.x, 0),
      getButton('避', () {
        onMenuClick(4);
      })
        ..position = center + Vector2(0, buttonSize.y),
    ]);
    bgPaint.color = const Color(0x7FA52A2A);
  }

  PositionComponent getButton(String text, void Function() action) {
    return TextButtonRect(text: text, action: action, color: const Color(0xFF00FFFF), borderColor: const Color(0xFF00FFFF));
  }

  void onMenuClick(int menu) {
    DemoGame04? game = findParent();
    game?.onMenuClick(menu);
  }
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(RRect.fromRectAndRadius(menuSize.toRect(), Radius.circular(buttonSize.x / 4)), bgPaint);
  }
}

class SecondMenu extends PositionComponent {

}