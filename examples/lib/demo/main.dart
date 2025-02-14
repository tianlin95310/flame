import 'package:examples/demo/game.dart';
import 'package:examples/demo/utils/mixins/router-provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return DemoGameWidget(
                  game: PCGameEntry(),
                );
              }),
            );
          },
          child: const Text('PC Game'),
        ),
      ],
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
