import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_demo/basic/simpleObj.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flutter/rendering.dart';

import 'game.dart';

class MobileGameHome extends Component with HasGameRef<MobileGameEntry> {
  List<List<RouteInfo>> routes = [
    [
      RouteInfo('相机跟随', 'game01'),
      RouteInfo('大地图拖移', 'game02'),
      RouteInfo('帧动画特效', 'game03'),
      RouteInfo('循环地图平移', 'game04'),
      RouteInfo('可视窗口ViewPort', 'game05'),
      RouteInfo('帧动画模型', 'game06'),
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

