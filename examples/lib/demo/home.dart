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
      RouteInfo('g13 Test Function Call', 'game13'),
      RouteInfo('g14 Test transformMatrix', 'game14'),
      RouteInfo('g16 Overlay Route', 'game16'),
      RouteInfo('g17 Test Effect', 'game17'),
      RouteInfo('g18 单页', 'game18'),
    ],
    [
      RouteInfo('g03 Frame Skill', 'game03'),
      RouteInfo('g06 Frame Model', 'game06'),
      RouteInfo('g08 Lottie Anim', 'game08'),
      RouteInfo('g15 Test BlendMode', 'game15'),
      RouteInfo('g09 Tiles Map', 'game09'),
      RouteInfo('g10 Spine Anim', 'game10'),
    ],
    [
      RouteInfo('g12 Shortest Path', 'game12'),
    ],
    [
      RouteInfo('g07 Tank Mobile', 'game07'),
      RouteInfo('g11 Tank PC', 'game11'),
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
