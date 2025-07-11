import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_spine/flame_spine.dart';

class Game10 extends Component with TapCallbacks {
  late SpineComponent spineboy;

  Vector2 size = Vector2(400, 400);

  int _stateIndex = 0;

  final states = [
    'walk',
    'aim',
    'death',
    'hoverboard',
    'idle',
    'jump',
    'portal',
    'run',
    'shoot',
  ];

  @override
  FutureOr<void> onLoad() async {
    await initSpineFlutter();
    spineboy = await SpineComponent.fromAssets(
      atlasFile: 'assets/spine/skeleton.atlas',
      // skeletonFile: 'assets/spine/spineboy-pro.skel', // skel or json
      skeletonFile: 'assets/spine/skeleton.json',
      scale: Vector2(0.4, 0.4),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    // Set the "walk" animation on track 0 in looping mode
    // spineboy.animationState.setAnimationByName(0, 'walk', true);
    await add(spineboy);

    print(spineboy.animationStateData);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    _stateIndex = (_stateIndex + 1) % states.length;
    spineboy.animationState.setAnimationByName(0, states[_stateIndex], true);
  }

  @override
  void onRemove() {
    print('Game10 onRemove');
    // spineboy.dispose();
  }

}
