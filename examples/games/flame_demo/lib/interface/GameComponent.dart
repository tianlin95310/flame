import 'package:flame/components.dart';

abstract interface class GameComponent implements Component {
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other, PositionComponent main);
}
