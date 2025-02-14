import 'dart:async';

import 'package:examples/demo/component/buttons.dart';
import 'package:examples/demo/game.dart';
import 'package:examples/demo/utils/vo/simpleObj.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

class MobileGameHome extends Component with HasGameRef<PCGameEntry> {
  List<List<RouteInfo>> routes = [
    [
      RouteInfo('g01 Camera Follow', 'game01'),
      RouteInfo('g02 Map Draggable', 'game02'),
      RouteInfo('g04 Cycle Map', 'game04'),
      RouteInfo('g05 World & Diff Cameras', 'game05'),
      RouteInfo('6 方法调用测试', 'game13'),
      RouteInfo('7 测试旋转api', 'game14'),
      RouteInfo('8 弹窗浮层', 'game16'),
      RouteInfo('9 补间动画', 'game17'),
      RouteInfo('9 单页', 'game18'),
    ],
    [
      RouteInfo('1 帧动画模型', 'game06'),
      RouteInfo('2 帧动画特效', 'game03'),
      RouteInfo('3 帧动画特效', 'game15'),
      RouteInfo('4 地图构建tmx', 'game09'),
      RouteInfo('5 骨骼动画', 'game10'),
      RouteInfo('6 动画库', 'game08'),
    ],
    [
      RouteInfo('1 最短路径', 'game12'),
    ],
    [
      RouteInfo('1 坦克大战 Mobile', 'game07'),
      RouteInfo('2 坦克大战 PC', 'game11'),
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
        )..position = Vector2(RectButton.initSize.x * (i - 1) + RectButton.initSize.x / 2, 50.0 * j));
      }
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }
}
