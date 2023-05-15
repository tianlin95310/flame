import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_demo/mobile/game.dart';
import 'package:flame_demo/pc/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DemoHome(),
      color: Colors.lime,
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('WillPopScope');
        return Future.value(false);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    PCGameEntry? game;
                    return WillPopScope(
                      onWillPop: () async {
                        if (game?.router.currentRoute.name ==
                            game?.router.initialRoute) {
                          Navigator.pop(context);
                          return true;
                        } else {
                          game?.router.pop();
                          return false;
                        }
                      },
                      child: GameWidget(game: game = PCGameEntry()),
                    );
                  },
                ));
              },
              child: const Text('PC Game')),
          ElevatedButton(
              onPressed: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    MobileGameEntry? game;
                    return WillPopScope(
                      onWillPop: () async {
                        if (game?.router.currentRoute.name ==
                            game?.router.initialRoute) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown
                          ]);
                          Navigator.pop(context);
                          return true;
                        } else {
                          game?.router.pop();
                          return false;
                        }
                      },
                      child: GameWidget(game: game = MobileGameEntry()),
                    );
                  }),
                );
              },
              child: const Text('Mobile Game')),
        ],
      ),
    );
  }
}

mixin RouterProvider on FlameGame{
  late RouterComponent router;
}
