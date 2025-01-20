import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'child.dart';
import 'parent.dart';

class Game13 extends Component with TapCallbacks, HasGameRef {
  Parent? parent_p;
  Child? child;
  @override
  bool containsLocalPoint(Vector2 point) {
    bool con = super.containsLocalPoint(point);
    // print('DemoGame03 containsLocalPoint, point = $point, con = $con');
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    print('DemoGame03 onTapUp, event = $event');
    if (parent_p?.parent == null) {
      add(parent_p = Parent()..position = gameRef.size / 2);
    } else {
      if (child?.parent == null) {
        parent_p?.add(child = Child()..position = parent_p!.size / 2);
      }
    }
    // add(ClickAddOrRemove()..position = event.canvasPosition);
    super.onTapUp(event);
  }

  @override
  FutureOr<void> onLoad() {
    print('DemoGame03 onLoad');

    // add(ClickAddOrRemove()..position = size / 2);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    print('DemoGame03 onGameResize');
    super.onGameResize(size);
  }

  @override
  void onMount() {
    print('DemoGame03 onMount');
    super.onMount();
  }

  @override
  void onRemove() {
    print('DemoGame03 onRemove');
    super.onRemove();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    print('DemoGame03 onChildrenChanged, child = $child');
    super.onChildrenChanged(child, type);
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('DemoGame03 onParentResize, parent = ${parent.runtimeType}');
    super.onParentResize(maxSize);
  }
}
