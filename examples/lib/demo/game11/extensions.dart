import 'package:flame/components.dart';

import '../game.dart';

extension PCGameEntryExtension on PCGameEntry {
  T? findChild<T extends Component>(Component component) {
    return findAllChild(component).whereType<T>().firstOrNull;
  }
  Iterable<Component> findAllChild(Component component) sync*{
    if (component.children.isEmpty) {
      return;
    } else {
      for (var element in component.children) {
        yield element;
        yield* findAllChild(element);
      }
    }
  }
}