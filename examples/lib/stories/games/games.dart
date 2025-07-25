import 'package:crystal_ball/crystal_ball.dart';
import 'package:dashbook/dashbook.dart';
import 'package:examples/demo/main.dart';
import 'package:padracing/padracing_game.dart';
import 'package:padracing/padracing_widget.dart';
import 'package:rogue_shooter/rogue_shooter_game.dart';
import 'package:rogue_shooter/rogue_shooter_widget.dart';
import 'package:trex_game/trex_game.dart';
import 'package:trex_game/trex_widget.dart';

String gamesLink(String game) =>
    'https://github.com/flame-engine/flame/blob/main/examples/games/$game';

void addGameStories(Dashbook dashbook) {
  dashbook.storiesOf('Sample Games')
    ..add(
      'PC Game Demo',
          (_) => const DemoHome(),
      codeLink: gamesLink('demo'),
      info: 'PC Game Demo',
    )
    ..add(
      'Crystal Ball',
      (_) => const CrystalBallWidget(),
      codeLink: gamesLink('crystal_ball'),
      info: CrystalBallWidget.description,
    )
    ..add(
      'Padracing',
      (_) => const PadracingWidget(),
      codeLink: gamesLink('padracing'),
      info: PadRacingGame.description,
    )
    ..add(
      'Rogue Shooter',
      (_) => const RogueShooterWidget(),
      codeLink: gamesLink('rogue_shooter'),
      info: RogueShooterGame.description,
    )
    ..add(
      'T-Rex',
      (_) => const TRexWidget(),
      codeLink: gamesLink('trex'),
      info: TRexGame.description,
    );
}
