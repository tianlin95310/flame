import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_lottie/flame_lottie.dart';
import 'package:flame_rive/flame_rive.dart';

class Game08 extends Component with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    final skillsArtboard = await loadArtboard(RiveFile.asset('assets/anims/skills.riv'));
    final asset = await loadLottie(Lottie.asset('assets/anims/LottieLogo1.json'));

    add(SkillsAnimationComponent(skillsArtboard, size: Vector2.all(200))..position = Vector2(200, 0));
    add(
      LottieComponent(
        asset,
        size: Vector2.all(200),
        repeating: true,
      ),
    );
  }
}

class SkillsAnimationComponent extends RiveComponent with TapCallbacks {
  SkillsAnimationComponent(Artboard artboard, {super.size}) : super(artboard: artboard);

  SMIInput<double>? _levelInput;

  @override
  void onLoad() {
    final controller = StateMachineController.fromArtboard(
      artboard,
      "Designer's Test",
    );
    if (controller != null) {
      artboard.addController(controller);
      _levelInput = controller.findInput<double>('Level');
      _levelInput?.value = 0;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final levelInput = _levelInput;
    if (levelInput == null) {
      return;
    }
    levelInput.value = (levelInput.value + 1) % 3;
  }
}
