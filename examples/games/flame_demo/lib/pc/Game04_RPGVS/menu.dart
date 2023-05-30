import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flame_demo/component/scroll.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flame_demo/pc/Game04_RPGVS/model.dart';
import 'package:flutter/rendering.dart';

import 'main.dart';
import 'style.dart';

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
    return TextButtonRect(
        text: text, action: action, color: const Color(0xFF00FFFF), borderColor: const Color(0xFF00FFFF));
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
  Vector2 viewportSize;

  BaseRPGModel model;

  static Vector2 menuSize = Vector2(200, 200);

  SecondMenu(this.model, this.viewportSize) : super(size: menuSize);

  int menuType = 1;

  late CharSkill charSkill;

  @override
  FutureOr<void> onLoad() async {
    add(charSkill = CharSkill(model));
    add(
      CloseButton(hideMenu , hasBorder: false)
        ..position = Vector2(
          SecondMenu.menuSize.x - SimplePathButton.buttonSize.x / 2,
          -SimplePathButton.buttonSize.y / 2,
        ),
    );
  }
  showMenu() {
    position = Vector2(0, 0);
  }
  hideMenu() {
    position = -Vector2(1000, 1000);
  }

  void updateCurrentModel(BaseRPGModel rpgModel) {
    model = rpgModel;
    charSkill.model = rpgModel;
  }
}

class CharSkill extends Component with BgPaint {
  BaseRPGModel model;

  CharSkill(this.model) : super();

  @override
  FutureOr<void> onLoad() async {
    add(
      ScrollComponent(
        Axis.vertical,
        model.skills
            .map((e) => TextComponent(
                textRenderer: regularRender,
                text: e.name,
                size: Vector2(regularRender.measureTextHeight(e.name), SecondMenu.menuSize.x)))
            .toList(),
        size: SecondMenu.menuSize,
      ),
    );

  }

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawRect(SecondMenu.menuSize.toRect(), bgPaint);
  }

}
