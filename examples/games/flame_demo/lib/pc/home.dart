import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flame/components.dart';
import 'package:flame_demo/basic/simpleObj.dart';
import 'package:flame_demo/component/buttons.dart';
import 'package:flame_demo/pc/Game05_SectionPlot/main.dart';
import 'package:flutter/rendering.dart';

import 'game.dart';

class PCGameHome extends Component with HasGameRef<PCGameEntry> {
  late List<List<RouteInfo>> routes = [
    [
      RouteInfo('Tank', 'game01'),
      RouteInfo('最短路径', 'game02'),
      RouteInfo('生命方法测试', 'game03'),
      RouteInfo('RPG VS', 'game04'),
      RouteInfo('xml文件读取与解析', '', otherAction: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        result?.files.forEach((element) {
          DemoGame05.buffer = element.bytes;
          gameRef.router.pushNamed('game05');
        });
      }),
    ],
    [
      RouteInfo('图像变换', 'game06'),
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
          action: () =>
              element.router.isNotEmpty ? gameRef.router.pushNamed(element.router) : element.otherAction?.call(),
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
