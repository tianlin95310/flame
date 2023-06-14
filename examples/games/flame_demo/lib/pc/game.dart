import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_demo/mixins/RouterProvider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route, OverlayRoute;

import 'Game01_Tank/extensions.dart';
import 'Game01_Tank/main.dart';
import 'Game02_ShortestPath/main.dart';
import 'Game03_FuncCallTest/main.dart';
import 'Game04_RPGVS/main.dart';
import 'Game05_SectionPlot/main.dart';
import 'Game06_transform/main.dart';
import 'Game07_Dialog/main.dart';
import 'home.dart';

class PCGameEntry extends FlameGame
    with KeyboardEvents, HasCollisionDetection, RouterProvider, HasTimeScale // , TapCallbacks
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
          'game05': Route(DemoGame05.new),
          'game06': Route(DemoGame06.new),
          'game07': Route(DemoGame07.new),
          'okOrNot': OverlayRoute((context, game) {
            return Center(
              child: GestureDetector(
                child: const Text('okOrNot'),
                onTap: () {
                  // game.overlays.
                  if (game is PCGameEntry) {
                    game.router.pop();
                  }
                  // game.overlays.remove('okOrNot');
                },
              ),
            );
          }),
          'pause': OverlayRoute.existing(),
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
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    DemoGame01? game01 = findChild<DemoGame01>(this);
    game01?.onKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }
}
