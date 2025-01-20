import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_lottie/flame_lottie.dart';

class Game08 extends Component with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    final asset = await loadLottie(Lottie.asset('assets/images/animations/lottieLogo.json'));

    add(
      LottieComponent(
        asset,
        size: Vector2.all(200),
        repeating: true,
      ),
    );
  }
}
