import 'package:flame/game.dart';

mixin RouterProvider on FlameGame{
  late RouterComponent router;

  set timeScale(double value);
  double get timeScale;

  void pauseOrResume() {
    if (overlays.isActive('pause')) {
      overlays.remove('pause');
      resumeEngine();
    } else {
      overlays.add('pause');
      pauseEngine();
    }
  }
}
