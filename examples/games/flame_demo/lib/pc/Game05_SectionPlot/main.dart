import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_demo/pc/Game05_SectionPlot/text.dart';
import 'package:flame_demo/pc/Game05_SectionPlot/xml.dart';
import 'package:flame_demo/pc/Game07_Dialog/main.dart';
import 'package:flame_demo/pc/game.dart';
import 'package:flutter/foundation.dart';

import '../../mobile/common/map.dart';
import '../Game04_RPGVS/main.dart';
import 'story.dart';

class DemoGame05 extends Component with HasGameRef<PCGameEntry> {
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
      bool value = await gameRef.router.pushAndWait(BaseValueRoute(DemoGame04()));
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
    return 'bg/map/wild${(Random().nextInt(10) + 1).toString().padLeft(3, '0')}.jpg';
  }
}