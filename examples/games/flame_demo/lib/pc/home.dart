import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/basic/simpleObj.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flutter/rendering.dart';

import 'game.dart';

class PCGameHome extends Component with HasGameRef<PCGameEntry> {
  List<List<RouteInfo>> routes = [
    [
      RouteInfo('Tank', 'game01'),
      RouteInfo('最短路径', 'game02'),
      RouteInfo('生命方法测试', 'game03'),
      RouteInfo('RPG VS', 'game04'),
    ],
    [
      RouteInfo('', 'game03'),
    ],
    [
      RouteInfo('', 'game03'),
    ]
  ];
  @override
  FutureOr<void> onLoad() {
    int i = 0;
    for (var children in routes) {
      i++;
      int j = 0;
      for (var element in children) {
        j++;
        add(RoundedButton(
          text: element.title,
          action: () => gameRef.router.pushNamed(element.router),
          color: const Color(0xffadde6c),
          borderColor: const Color(0xffedffab),
        )..position = Vector2(
            RectButton.initSize.x * (i - 1) + RectButton.initSize.x / 2, 50.0 * j));
      }
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }
}
