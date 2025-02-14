import 'dart:async';
import 'dart:ui';

import 'package:examples/demo/utils/mixins/router-provider.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';

import 'buttons.dart';

/// 暂停Route
class PauseRoute extends Route {
  PauseRoute() : super(PausePage.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
    super.onPush(previousRoute);
    previousRoute!
      ..stopTime()
      ..addRenderEffect(PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0));
  }

  @override
  void onPop(Route nextRoute) {
    super.onPop(nextRoute);
    nextRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}

/// 暂停按钮，进入到暂停界面
class PauseButton extends SimplePathButton with HasGameRef<RouterProvider> {
  PauseButton()
      : super(Path()
          ..moveTo(12, 8)
          ..lineTo(12, 32)
          ..moveTo(28, 8)
          ..lineTo(28, 32));

  @override
  void action() => gameRef.router.pushNamed('pause');
}

/// 暂停按钮，暂停引擎
class PauseButtonEngine extends PauseButton {
  @override
  void action() {
    gameRef.pauseOrResume();
  }
}

/// 放慢游戏
class TimeScaleButton extends PauseButton {
  @override
  void action() {
    gameRef.timeScale = 0.25;
  }
}

/// 暂停界面
class PausePage extends Component with TapCallbacks, HasGameRef<RouterProvider> {
  @override
  FutureOr<void> onLoad() async {
    final game = findGame()!;
    addAll([
      TextComponent(text: 'paused', position: game.canvasSize / 2, anchor: Anchor.center, children: [
        ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(
              infinite: true,
              duration: 0.3,
              alternate: true,
            ))
      ])
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pop();
  }
}
