import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flame_demo/component/scroll.dart';
import 'package:flame_demo/mixins/paint.dart';
import 'package:flutter/rendering.dart';

import 'main.dart';
import 'model.dart';
import 'style.dart';

class Menu extends PositionComponent with BgPaint {
  static Vector2 menuSize = Vector2(150, 150);

  static Vector2 showPosition = DemoGame04.viewportSize / 2 - menuSize / 2 - Vector2(menuSize.x / 2, 0);

  Menu() : super(size: menuSize, position: showPosition);

  @override
  FutureOr<void> onLoad() async {
    Vector2 center = menuSize / 2;
    print('position = $position');
    addAll([
      getButton('击', () {
        onMenuClick(0);
      })
        ..position = center,
      getButton('技', () {
        onMenuClick(1);
      })
        ..position = center - Vector2(0, TextButtonRect.buttonSize.y),
      getButton('术', () {
        onMenuClick(2);
      })
        ..position = center + Vector2(TextButtonRect.buttonSize.x, 0),
      getButton('物', () {
        onMenuClick(3);
      })
        ..position = center - Vector2(TextButtonRect.buttonSize.x, 0),
      getButton('避', () {
        onMenuClick(4);
      })
        ..position = center + Vector2(0, TextButtonRect.buttonSize.y),
    ]);
    bgPaint.color = const Color(0x7FA52A2A);
  }

  PositionComponent getButton(String text, void Function() action) {
    return TextButtonRect(
      text: text,
      action: action,
      color: const Color(0xFF00FFFF),
      borderColor: const Color(0xFF00FFFF),
    );
  }

  void onMenuClick(int menu) {
    DemoGame04? game = findParent();
    game?.onMenuClick(menu);
  }

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(TextButtonRect.buttonSize.x / 4)),
      bgPaint,
    );
  }

  showMenu() {
    position = showPosition;
  }

  hideMenu() {
    position = -DemoGame04.viewportSize;
  }
}

class SecondMenu extends PositionComponent with BgPaint {
  BaseRPGModel model;

  static Vector2 menuSize = Vector2(150, 150);

  static Vector2 showPosition = DemoGame04.viewportSize / 2 - menuSize / 2 + Vector2(menuSize.x / 4 * 3, 0);

  SecondMenu(this.model) : super(size: menuSize, position: DemoGame04.viewportSize / 2 - menuSize / 2);

  int? menuId;

  CharSkill? charSkill;

  CharSpell? charSpell;

  UserInventory? userInventory;

  @override
  FutureOr<void> onLoad() async {
    Vector2 closeSize = SimplePathButton.buttonSize * 0.7;
    add(
      CloseButton(hideMenu, hasBorder: false, strokeWidth: 3)
        ..position = Vector2(menuSize.x, -closeSize.y)
        ..scale = Vector2.all(0.7),
    );

    bgPaint.color = const Color(0x7F668800);
  }

  _hideAll() {
    if (charSkill?.parent != null) {
      remove(charSkill!);
    }
    if (charSpell?.parent != null) {
      remove(charSpell!);
    }
    if (userInventory?.parent != null) {
      remove(userInventory!);
    }
  }

  void show(int menuId) {
    if (this.menuId == menuId) {
      return;
    }
    this.menuId = menuId;
    _hideAll();
    print('show, menuId = $menuId');

    if (menuId == 1) {
      add(charSkill = CharSkill(model));
    } else if (menuId == 2) {
      add(charSpell = CharSpell(model));
    } else if (menuId == 3) {
      add(userInventory = UserInventory());
    }
  }

  showMenu() {
    position = showPosition;
  }

  hideMenu() {
    position = -DemoGame04.viewportSize * 2;
  }

  void updateCurrentModel(BaseRPGModel rpgModel) {
    model = rpgModel;
    charSkill?.model = rpgModel;
    charSkill?.show();
    charSpell?.model = rpgModel;
    charSpell?.show();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), Radius.circular(TextButtonRect.buttonSize.x / 4)),
      bgPaint,
    );
  }
}

class UserInventory extends Component {
  @override
  FutureOr<void> onLoad() async {}
}

class CharSpell extends Component {
  BaseRPGModel model;

  CharSpell(this.model) : super();

  ScrollComponentOneCol? listView;

  Vector2 buttonSize = Vector2(30, 30);

  String type = '1';

  late Map<String, List<SpellVo>> spells = {'1': [], '2': [], '3': [], '4': [], '5': []};

  Map dist = {
    '金': '1',
    '木': '2',
    '水': '3',
    '火': '4',
    '土': '5',
  };

  late List<TextButtonRect> buttons;
  TextButtonRect button(String text, String type) {
    return TextButtonRect(
        text: text,
        action: () {
          changeType(type);
        },
        color: this.type == dist[text] ? const Color(0xFF008866) : const Color(0x00000000),
        borderColor: const Color(0x00000000),
        size: buttonSize);
  }

  @override
  FutureOr<void> onLoad() async {
    addAll(buttons = [
      button('金', '1')..position = Vector2(0, 0) + buttonSize / 2,
      button('木', '2')..position = Vector2(30, 0) + buttonSize / 2,
      button('水', '3')..position = Vector2(60, 0) + buttonSize / 2,
      button('火', '4')..position = Vector2(90, 0) + buttonSize / 2,
      button('土', '5')..position = Vector2(120, 0) + buttonSize / 2,
    ]);
    show();
  }

  updateButton() {
    for (var element in buttons) {
      element.changeColor(type == dist[element.text] ? const Color(0xFF008866) : const Color(0x00000000));
    }
  }

  changeType(String type) {
    if (this.type == type) {
      return;
    }
    this.type = type;
    updateButton();
    show();
  }

  resetSpells() {
    spells = {'1': [], '2': [], '3': [], '4': [], '5': []};
  }

  show() {
    resetSpells();
    for (var element in model.spells) {
      spells[element.spellType]!.add(element);
    }
    if (listView?.parent != null) {
      remove(listView!);
    }
    add(
      listView = ScrollComponentOneCol(
        Axis.vertical,
        spells[type]!
            .map((e) => TextComponent(
                  textRenderer: middleRender,
                  text: e.name,
                  size: Vector2(middleRender.measureTextHeight(e.name), SecondMenu.menuSize.x),
                ))
            .toList(),
        position: Vector2(0, 30),
        size: Vector2(SecondMenu.menuSize.x, SecondMenu.menuSize.y - 30),
      ),
    );
  }
}

class CharSkill extends Component {
  BaseRPGModel model;

  CharSkill(this.model) : super();

  ScrollComponentOneCol? listView;

  @override
  FutureOr<void> onLoad() async {
    show();
  }

  void show() {
    if (listView?.parent != null) {
      remove(listView!);
    }
    add(
      listView = ScrollComponentOneCol(
        Axis.vertical,
        model.skills
            .map((e) => TextComponent(
                  textRenderer: middleRender,
                  text: e.name,
                  size: Vector2(middleRender.measureTextHeight(e.name), SecondMenu.menuSize.x),
                ))
            .toList(),
        size: SecondMenu.menuSize,
      ),
    );
  }
}
