import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/common/buttons.dart';
import 'package:flutter/rendering.dart';

import '../utils/utils.dart';
import 'game.dart';

class MobileGameHome extends Component with HasGameRef<MobileGameEntry> {
  List<List<RouteInfo>> routes = [
    [
      RouteInfo('01 相机跟随', 'game01'),
      RouteInfo('02 拖移地图', 'game02'),
      RouteInfo('03 动画特效', 'game03'),
      RouteInfo('04 地图平移', 'game04'),
      RouteInfo('05 可视窗口小', 'game05'),
      RouteInfo('06 模型与特效', 'game06'),
    ],
    [
      RouteInfo('', 'game07'),
      RouteInfo('', 'game08'),
      RouteInfo('', 'game09'),
    ],
    [
      RouteInfo('坦克大战', 'game07'),
      RouteInfo('', 'game08'),
      RouteInfo('', 'game09'),
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
        )..position = Vector2(Button.initSize.x * (i - 1) + Button.initSize.x / 2 , 50.0 * j));
      }
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }
}

