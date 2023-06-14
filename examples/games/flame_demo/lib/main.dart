import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_demo/mixins/RouterProvider.dart';
import 'package:flame_demo/mobile/game.dart';
import 'package:flame_demo/pc/game.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSpineFlutter();
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

  void onMenuClick<T extends RouterProvider>(BuildContext context, T game, {bool landscape = false}) {
    if (landscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (game.router.currentRoute.name == game.router.initialRoute) {
              if (landscape) {
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
              }
              Navigator.pop(context);
              return true;
            } else {
              game.router.pop();
              return false;
            }
          },
          child: DemoGameWidget(
            game: game,
          ),
        );
      }),
    );
  }

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
              onMenuClick<PCGameEntry>(context, PCGameEntry());
            },
            child: const Text('PC Game'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
                onMenuClick<MobileGameEntry>(context, MobileGameEntry(), landscape: true);
              },
              child: const Text('Mobile Game'),
            ),
          ),
        ],
      ),
    );
  }
}

class DemoGameWidget extends GameWidget<RouterProvider> {
  DemoGameWidget({super.key, required super.game})
      : super(
            backgroundBuilder: (BuildContext context) {
              return const Card(color: Colors.lightBlue);
            },
            loadingBuilder: (BuildContext context) {
              return const CircularProgressIndicator();
            },
            errorBuilder: (BuildContext context, Object error) {
              return const Card(
                color: Colors.red,
                child: Text('出错了'),
              );
            },
            overlayBuilderMap: {
              'gameWin': (BuildContext context, RouterProvider game) {
                return Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(32))),
                    child: Card(
                      color: Colors.lightBlueAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('战斗结束'),
                          ElevatedButton(
                              onPressed: () {
                                game.overlays.remove('gameWin');
                              },
                              child: const Text('继续游戏')),
                        ],
                      ),
                    ),
                  ),
                );
              },
              'pause': (BuildContext context, RouterProvider game) {
                return Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(32))),
                    child: Card(
                      color: Colors.lightBlueAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Engine Paused'),
                          ElevatedButton(
                              onPressed: () {
                                game.pauseOrResume();
                              },
                              child: const Text('Resume Engine')),
                        ],
                      ),
                    ),
                  ),
                );
              }
            });
}
