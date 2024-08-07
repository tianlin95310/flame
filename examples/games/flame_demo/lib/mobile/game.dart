import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_demo/component/pause.dart';
import 'package:flame_demo/mixins/RouterProvider.dart';

import 'game01/main.dart';
import 'game02/main.dart';
import 'game03/main.dart';
import 'game04/main.dart';
import 'game05/main.dart';
import 'game06/main.dart';
import 'game07/main.dart';
import 'game08/main.dart';
import 'game09/main.dart';
import 'game10/main.dart';
import 'home.dart';

class MobileGameEntry extends FlameGame
    with
        HasCollisionDetection,
        DoubleTapDetector,
        RouterProvider,
        HasTimeScale {
  @override
  void onLoad() {
    print('MobileGameEntry onLoad, size = $size');
    add(
      router = RouterComponent(
        initialRoute: 'home',
        routes: {
          'home': Route(MobileGameHome.new),
          'pause': PauseRoute(),
          'game01': Route(Game01.new),
          'game02': Route(Game02.new),
          'game03': Route(Game03.new),
          'game04': Route(Game04.new),
          'game05': Route(Game05.new),
          'game06': Route(Game06.new),
          'game07': Route(Game07.new),
          'game08': Route(Game08.new),
          'game09': Route(Game09.new),
          'game10': Route(Game10.new),
        },
      ),
    );
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    print('MobileGameEntry onGameResize, size = $canvasSize');
    super.onGameResize(canvasSize);
  }

  @override
  void onMount() {
    print('MobileGameEntry onMount, size = $canvasSize');
    super.onMount();
  }

  @override
  void onAttach() {
    print('MobileGameEntry onAttach, size = $canvasSize');
    super.onAttach();
  }

  @override
  void onDetach() {
    print('MobileGameEntry onDetach, size = $canvasSize');
    super.onDetach();
  }

  @override
  void onRemove() {
    print('MobileGameEntry onRemove, size = $canvasSize');
    super.onRemove();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    print('MobileGameEntry onChildrenChanged, size = $canvasSize');
    super.onChildrenChanged(child, type);
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('MobileGameEntry onParentResize, maxSize = $maxSize');
    super.onParentResize(maxSize);
  }
}
