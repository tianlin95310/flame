import 'package:flame/components.dart';

abstract class GameComponent extends Component {
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other, PositionComponent main);
}
