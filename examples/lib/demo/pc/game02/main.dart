import 'package:examples/demo/component/shape-sprite.dart';
import 'package:examples/demo/component/map.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';


class Game02 extends Component with HasGameRef {
  MapDraggable? map2;

  late ShapeSprite pathSprite;

  late World world;

  late CameraComponent cameraComponent;

  @mustCallSuper
  @override
  Future<void>? onLoad() async {
    await add(world = World());
    await add(cameraComponent = CameraComponent(world: world, hudComponents: [
      TextComponent(text: 'viewport')
    ]));
    await cameraComponent.viewfinder.add(TextComponent(text: 'viewfinder', anchor: Anchor.center));

    await world.add(map2 = MapDraggable(cameraComponent)
      ..position = -cameraComponent.viewport.size / 2);
    world.add(pathSprite = ShapeSprite());

    print('cameraComponent.viewport.position = ${cameraComponent.viewport.position}');
    print('cameraComponent.viewport.size = ${cameraComponent.viewport.size}');
    print('cameraComponent.viewfinder.position = ${cameraComponent.viewfinder.position}');
    print('cameraComponent.viewfinder.anchor = ${cameraComponent.viewfinder.anchor}');
    print('cameraComponent.viewfinder.children = ${cameraComponent.viewfinder.children.length}');

    print('gameRef.canvasSize = ${gameRef.canvasSize}');
    print('gameRef.size = ${gameRef.size}');
    // print('gameRef.camera.canvasSize = ${gameRef.camera.canvasSize}');
    // print('gameRef.camera.gameSize = ${gameRef.camera.gameSize}');
  }
  @override
  void onMount() {
    if (map2 != null) {
      MapDraggable map2 = this.map2!;
      Rect rect = (map2.size - cameraComponent.viewport.size).toRect();
      print('map1.size = ${map2.size}, rect = $rect');
      cameraComponent.setBounds(Rectangle.fromRect(rect));
    }
  }
}
