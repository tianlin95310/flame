import 'package:examples/demo/component/pause.dart';
import 'package:examples/demo/game01/main.dart';
import 'package:examples/demo/game02/main.dart';
import 'package:examples/demo/game03/main.dart';
import 'package:examples/demo/game04/main.dart';
import 'package:examples/demo/game05/main.dart';
import 'package:examples/demo/game06/main.dart';
import 'package:examples/demo/game07/main.dart';
import 'package:examples/demo/game08/main.dart';
import 'package:examples/demo/game09/main.dart';
import 'package:examples/demo/game10/main.dart';
import 'package:examples/demo/game11/extensions.dart';
import 'package:examples/demo/game11/main.dart';
import 'package:examples/demo/game12/main.dart';
import 'package:examples/demo/game13/main.dart';
import 'package:examples/demo/game14/main.dart';
import 'package:examples/demo/game15/main.dart';
import 'package:examples/demo/game16/main.dart';
import 'package:examples/demo/game17/main.dart';
import 'package:examples/demo/game21/main.dart';
import 'package:examples/demo/game22/main.dart';
import 'package:examples/demo/home.dart';
import 'package:examples/demo/utils/mixins/router-provider.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;

class PCGameEntry extends FlameGame
    with
        HasCollisionDetection,
        DoubleTapDetector,
        RouterProvider,
        KeyboardEvents,
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

          'game11': Route(Game11.new),
          'game12': Route(Game12.new),
          'game13': Route(Game13.new),
          'game14': Route(Game14.new),
          'game15': Route(Game15.new),

          'game16': Route(Game16.new),
          'game17': Route(Game17.new),

          'game21': Route(Game21.new),
          'game22': Route(Game22.new),
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

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Game11? game01 = findChild<Game11>(this);
    game01?.onKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }
}
