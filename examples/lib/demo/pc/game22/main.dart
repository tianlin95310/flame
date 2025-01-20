import 'dart:async';
import 'dart:math';

import 'package:examples/demo/component/map.dart';
import 'package:examples/demo/pc/game.dart';
import 'package:examples/demo/pc/game16/main.dart';
import 'package:examples/demo/pc/game21/main.dart';
import 'package:examples/demo/pc/game22/text.dart';
import 'package:examples/demo/pc/game22/xml.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import 'story.dart';

class Game22 extends Component with HasGameRef<PCGameEntry> {
  static Uint8List? buffer;

  late StoryShow storyShow;
  int index = 0;

  late Iterable<StoryItem> items;

  late World world;
  late CameraComponent camera;
  Vector2 viewportSize = Vector2(640, 360);
  
  late StageMap stageMap;

  @override
  FutureOr<void> onLoad() async {
    Story story = XmlReader.readXmlByUint8(buffer!);
    await add(world = World());
    await add(camera = CameraComponent.withFixedResolution(world: world, width: viewportSize.x, height: viewportSize.y));
    camera.viewfinder.anchor = Anchor.topLeft;
    items = story.items;
    for (var item in items) {
      if (item.id == 'start') {
       break;
      } else {
        index++;
      }
    }
    // world.add(stageMap = StageMap(path: randomBg()));
    world.add(
      storyShow = StoryShow(items.elementAt(index++ % items.length), viewportSize),
    );
  }

  void onTapUp(TapUpEvent event) {
    nextStory();
    // Flame.images.load(randomBg()).then((value) => stageMap.sprite = Sprite(value));
  }
  Future<bool> nextStory() async {
    StoryItem storyItem = items.elementAt(index++ % items.length);
    if (storyItem.type == 'story') {
      storyShow.item = storyItem;
      storyShow.show();
    } else if (storyItem.type == 'fight'){
      // gameRef.router.pushNamed('game04');
      // gameRef.router.pushAndWait(route);
      bool value = await gameRef.router.pushAndWait(BaseValueRoute(Game21()));
      print('onTapUp, value = $value');
      if (value) {
        return nextStory();
      } else {
        return value;
      }
    }
    return true;
  }

  String randomBg() {
    return 'map/wild${(Random().nextInt(10) + 1).toString().padLeft(3, '0')}.jpg';
  }
}
