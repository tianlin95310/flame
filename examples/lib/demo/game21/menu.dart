import 'dart:async';

import 'package:examples/demo/component/buttons.dart';
import 'package:examples/demo/component/scroll.dart';
import 'package:examples/demo/utils/constant/style.dart';
import 'package:examples/demo/utils/mixins/paint.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';

import 'main.dart';
import 'model.dart';
import 'vo.dart';

class Menu extends PositionComponent with BgPaint {
  static Vector2 menuSize = Vector2(150, 150);

  static Vector2 showPosition = Game21.viewportSize / 2 - menuSize / 2;

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
    bgPaint.color = const Color(0x7Fcccccc);
  }

  PositionComponent getButton(String text, void Function() action) {
    return TextButtonRect(
      text: text,
      action: action,
      color: const Color(0xFF00FFFF),
      borderColor: const Color(0xFF00FFFF),
      size: Vector2(40, 40)
    );
  }

  void onMenuClick(int menu) {
    Game21? game = findParent();
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
    position = -Game21.viewportSize;
  }
}

class SecondMenu extends PositionComponent with BgPaint {
  FightModelInfo? model;

  static Vector2 menuSize = Vector2(150, 150);

  static Vector2 showPosition = Game21.viewportSize / 2 - menuSize / 2 + Vector2(menuSize.x / 4 * 3, 0);

  SecondMenu(this.model, this.onSecondMenu)
      : super(size: menuSize, position: Game21.viewportSize / 2 - menuSize / 2);

  int? menuId;

  CharSkill? charSkill;

  CharSpell? charSpell;

  UserInventory? userInventory;

  Function onSecondMenu;

  @override
  FutureOr<void> onLoad() async {
    Vector2 closeSize = SimplePathButton.buttonSize * 0.7;
    add(
      CloseButton(hideMenu, hasBorder: false, strokeWidth: 3)
        ..position = Vector2(menuSize.x, -closeSize.y)
        ..scale = Vector2.all(0.7),
    );

    bgPaint.color = const Color(0x7Fccccee);
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
    if (model == null) {
      return;
    }
    if (this.menuId == menuId) {
      return;
    }
    this.menuId = menuId;
    _hideAll();
    print('show, menuId = $menuId');

    if (menuId == 1) {
      add(charSkill = CharSkill(model!, onSecondMenu));
    } else if (menuId == 2) {
      add(charSpell = CharSpell(model!, onSecondMenu));
    } else if (menuId == 3) {
      add(userInventory = UserInventory(onSecondMenu));
    }
  }

  showMenu() {
    position = showPosition;
  }

  hideMenu() {
    position = -Game21.viewportSize * 2;
  }

  void updateCurrentModel(FightModelInfo rpgModel) {
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
  late List<Inventory> inventory;

  UserInventory(this.onSecondMenu);

  Function onSecondMenu;

  ScrollComponent? scrollComponent;

  late Map<String, List<Inventory>> inventorys = {
    '丹药': [],
    '毒药': [],
    '异果': [],
  };

  String type = '丹药';

  late List<TextButtonRect> buttons;

  Vector2 buttonSize = Vector2(40, 30);

  TextButtonRect button(String type) {
    return TextButtonRect(
        text: type,
        action: () {
          changeType(type);
        },
        color: this.type == type ? const Color(0xFF008866) : const Color(0x00000000),
        borderColor: const Color(0x00000000),
        size: buttonSize);
  }

  changeType(String type) {
    if (this.type == type) {
      return;
    }
    this.type = type;
    updateButton();
    show();
  }

  updateButton() {
    for (var element in buttons) {
      element.changeColor(type == element.text ? const Color(0xFF008866) : const Color(0x00000000));
    }
  }

  @override
  FutureOr<void> onLoad() async {
    addAll(buttons = [
      button('丹药')..position = Vector2(0, 0) + buttonSize / 2,
      button('毒药')..position = Vector2(40, 0) + buttonSize / 2,
      button('异果')..position = Vector2(80, 0) + buttonSize / 2,
    ]);
    show();
  }

  show() {
    loadUserInventory();
    for (var element in inventory) {
      inventorys[element.type]!.add(element);
    }

    if (scrollComponent?.parent != null) {
      remove(scrollComponent!);
    }
    add(
      scrollComponent = ScrollComponent(
        Axis.vertical,
        3,
        inventorys[type]!
            .map((e) => ButtonComponent(
                button: InventoryItem(e),
                onReleased: () {
                  onSecondMenu(3, e);
                }))
            .toList(),
        position: Vector2(0, 30),
        size: Vector2(SecondMenu.menuSize.x, SecondMenu.menuSize.y - 30),
      ),
    );
  }

  loadUserInventory() {
    inventory = [
      Inventory('金疮药', 30, '丹药', ''),
      Inventory('孔雀胆1', 30, '毒药', ''),
      Inventory('孔雀胆2', 20, '毒药', ''),
      Inventory('孔雀胆3', 10, '毒药', ''),
      Inventory('孔雀胆4', 5, '毒药', ''),
      Inventory('孔雀胆5', 1, '毒药', ''),
      Inventory('孔雀胆6', 30, '毒药', ''),
      Inventory('孔雀胆7', 20, '毒药', ''),
      Inventory('孔雀胆8', 10, '毒药', ''),
      Inventory('孔雀胆9', 5, '毒药', ''),
      Inventory('孔雀胆10', 1, '毒药', ''),
      Inventory('人参果', 30, '异果', ''),
    ];
    inventorys = {
      '丹药': [],
      '毒药': [],
      '异果': [],
    };
  }
}

class InventoryItem extends PositionComponent with BgPaint {
  Inventory inventory;
  InventoryItem(this.inventory) : super(size: itemSize);
  static Vector2 itemSize = Vector2(50, 50);

  @override
  FutureOr<void> onLoad() async {
    String name = inventory.name;
    String count = inventory.count.toString();
    addAll([
      TextComponent(
        text: name,
        textRenderer: miniRender,
        anchor: Anchor.center,
        // size: miniRender.measureText(name),
        position: itemSize / 2,
      ),
      TextComponent(
        text: count,
        textRenderer: smallRender,
        anchor: Anchor.bottomRight,
        // size: smallRender.measureText(count),
        position: itemSize - Vector2.all(1),
      )
    ]);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect((size - Vector2(1, 1)).toRect(), bgPaint);
  }
}

class CharSpell extends Component {
  FightModelInfo model;

  CharSpell(this.model, this.onSecondMenu) : super();

  Function onSecondMenu;

  ScrollComponentOneCol? listView;

  Vector2 buttonSize = Vector2(30, 30);

  String type = '金';

  late Map<String, List<SpellVo>> spells = {'金': [], '木': [], '水': [], '火': [], '土': []};

  late List<TextButtonRect> buttons;

  TextButtonRect button(String type) {
    return TextButtonRect(
        text: type,
        action: () {
          changeType(type);
        },
        color: this.type == type ? const Color(0xFF008866) : const Color(0x00000000),
        borderColor: const Color(0x00000000),
        size: buttonSize);
  }

  @override
  FutureOr<void> onLoad() async {
    addAll(buttons = [
      button('金')..position = Vector2(0, 0) + buttonSize / 2,
      button('木')..position = Vector2(30, 0) + buttonSize / 2,
      button('水')..position = Vector2(60, 0) + buttonSize / 2,
      button('火')..position = Vector2(90, 0) + buttonSize / 2,
      button('土')..position = Vector2(120, 0) + buttonSize / 2,
    ]);
    show();
  }

  updateButton() {
    for (var element in buttons) {
      element.changeColor(type == element.text ? const Color(0xFF008866) : const Color(0x00000000));
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

  show() {
    spells = {'金': [], '木': [], '水': [], '火': [], '土': []};
    for (var element in model.model.spells) {
      spells[element.spellType]!.add(element);
    }
    if (listView?.parent != null) {
      remove(listView!);
    }
    add(
      listView = ScrollComponentOneCol(
        Axis.vertical,
        spells[type]!
            .map((e) => ButtonComponent(
                button: TextComponent(
                  textRenderer: middleRender,
                  text: e.name,
                  // size: Vector2(middleRender.measureTextHeight(e.name), SecondMenu.menuSize.x),
                ),
                onReleased: () {
                  onSecondMenu(2, e);
                }))
            .toList(),
        position: Vector2(0, 30),
        size: Vector2(SecondMenu.menuSize.x, SecondMenu.menuSize.y - 30),
      ),
    );
  }
}

class CharSkill extends Component {
  FightModelInfo model;

  Function onSecondMenu;

  CharSkill(this.model, this.onSecondMenu) : super();

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
        model.model.skills
            .map((e) => ButtonComponent(
                button: TextComponent(
                  textRenderer: middleRender,
                  text: e.name,
                  // size: Vector2(middleRender.measureTextHeight(e.name), SecondMenu.menuSize.x),
                ),
                onReleased: () {
                  onSecondMenu(1, e);
                }))
            .toList(),
        size: SecondMenu.menuSize,
      ),
    );
  }
}
