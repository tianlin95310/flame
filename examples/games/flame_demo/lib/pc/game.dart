import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_demo/mixins/RouterProvider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;

import 'Game01_Tank/extensions.dart';
import 'Game01_Tank/main.dart';
import 'Game02_ShortestPath/main.dart';
import 'Game03_FuncCallTest/main.dart';
import 'Game04_RPGVS/main.dart';
import 'home.dart';

class PCGameEntry extends FlameGame
    with KeyboardEvents, HasCollisionDetection, RouterProvider, HasTimeScale
// , TapCallbacks
{
  // @override
  // Color backgroundColor() {
  //   return const Color(0x33440000);
  // }

  @override
  void onLoad() {
    print('PCGameEntry onLoad, size = $size');
    add(
      router = RouterComponent(
        initialRoute: 'home',
        routes: {
          'home': Route(PCGameHome.new),
          'game01': Route(DemoGame01.new),
          'game02': Route(DemoGame02.new),
          'game03': Route(DemoGame03.new),
          'game04': Route(DemoGame04.new),
        },
      ),
    );
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    print('PCGameEntry onGameResize, size = $canvasSize');
    super.onGameResize(canvasSize);
  }

  @override
  void onMount() {
    print('PCGameEntry onMount, size = $canvasSize');
    super.onMount();
  }

  @override
  void onAttach() {
    print('PCGameEntry onAttach, size = $canvasSize');
    super.onAttach();
  }

  @override
  void onDetach() {
    print('PCGameEntry onDetach, size = $canvasSize');
    super.onDetach();
  }

  @override
  void onRemove() {
    print('PCGameEntry onRemove, size = $canvasSize');
    super.onRemove();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    print('PCGameEntry onChildrenChanged, size = $canvasSize');
    super.onChildrenChanged(child, type);
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('PCGameEntry onParentResize, maxSize = $maxSize');
    super.onParentResize(maxSize);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    DemoGame01? game01 = findChild<DemoGame01>(this);
    game01?.onKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }
}
