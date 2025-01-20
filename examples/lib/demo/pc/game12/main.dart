import 'dart:async';
import 'dart:ui';

import 'package:examples/demo/component/shape-sprite.dart';
import 'package:examples/demo/utils/shortest_path.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'path-map.dart';

class Game12 extends Component with HasGameRef {
  final List<Vertex> vertexList = [
    Vertex(Vector2(100, 150), 'A'),
    Vertex(Vector2(450, 50), 'B'),
    Vertex(Vector2(200, 600), 'C'),
    Vertex(Vector2(700, 200), 'D'),
    Vertex(Vector2(600, 500), 'E'),
  ];
  List<String> edges = [
    'A-B',
    'B-A',
    'B-D',
    'D-B',
    'D-E',
    'E-D',
    'C-E',
    'E-C',
    'A-C',
    'C-A',
    'C-D',
    'D-C',
    'B-E',
    'E-B',
  ];
  List<List<EdgeVertex>> edgeList = [];

  @override
  FutureOr<void> onLoad() async {
    int start = 0;

    initEdgeInfo();
    calculateShortPath(start);

    add(PathMap(vertexList, edgeList, size: game.canvasSize));
    // 当前的最短路径
    // moveByShortPath(start);
    List<int> path = [0, 1, 4, 3, 2, 0];
    smoothMoveByPath(path, ShapeSprite(color: const Color(0xff00ff00)), start);
    moveByPath(path, ShapeSprite(color: const Color(0xffffff00),), start);
  }

  late ResultInfo resultInfo;

  moveByShortPath(int start) {
    int end = vertexList.length - 1;
    List<int> path = resultInfo.paths[end];
    smoothMoveByPath(path, ShapeSprite(color: const Color(0xffff0000)), start);
  }

  smoothMoveByPath(List<int> path, ShapeSprite shapeSprite, int start) {
    add(shapeSprite);
    shapeSprite.position = vertexList[start].position;
    print('path = ${path.map((e) => vertexList[e].name).toList()}');
    List<Effect> effects = [];
    // path = [0, 1, 4]
    // 初始位置与点1的夹角
    // print('init angle to 1 = ${shapeSprite.angleTo(vertexList[1].position)}');
    // 初始位置与点4的夹角
    // print('init angle to 4 = ${shapeSprite.angleTo(vertexList[4].position)}');
    for (int i = 1; i < path.length; i++) {
      double angle = 0;
      if (i == 1) {
        angle = shapeSprite.angleTo(vertexList[path[i]].position);
      } else {
        // 上一个位置与当前位置的夹角，借助一个虚拟组件求得，其大小和初始角与原始组件相同
        PositionComponent temp = PositionComponent(
          position: vertexList[path[i - 1]].position,
          size: shapeSprite.size,
          anchor: Anchor.center,
        );
        // print('temp.angle = ${temp.angle}');
        // 这个只是向量的夹角
        // print('point = ${vertexList[path[i - 1]].position.angleTo(vertexList[path[i]].position)}');
        angle = temp.angleTo(vertexList[path[i]].position);
      }
      // 当前的夹角
      print('angle to ${vertexList[path[i]].name}, angle = $angle');
      effects.add(
        RotateEffect.to(angle, LinearEffectController(2.5)),
      );
      effects.add(
        MoveToEffect(
            vertexList[path[i]].position, EffectController(duration: 2.5)),
      );
    }
    shapeSprite.add(SequenceEffect(effects, repeatCount: 99));
  }

  moveByPath(List<int> path, ShapeSprite shapeSprite, int start) {
    add(shapeSprite);
    shapeSprite.position = vertexList[start].position;
    print('path = ${path.map((e) => vertexList[e].name).toList()}');
    List<Effect> effects = [];
    for (int i = 1; i < path.length; i++) {
      if (i == 1) {
        shapeSprite.lookAt(vertexList[path[1]].position);
      }
      effects.add(
        MoveToEffect(
          vertexList[path[i]].position,
          EffectController(duration: 1),
          onComplete: () {
            if (i + 1 < path.length) {
              shapeSprite.lookAt(vertexList[path[i + 1]].position);
            } else {
              shapeSprite.lookAt(vertexList[path[1]].position);
            }
          },
        ),
      );
    }
    shapeSprite.add(SequenceEffect(effects, infinite: true));
  }

  calculateShortPath(int start) {
    List<List<double>> map =
    edgeList.map((e) => e.map((e) => e.distance).toList()).toList();
    int length = vertexList.length;
    resultInfo = dijkstra(map, start, length);
    print(resultInfo.distances);
    print(resultInfo.paths);
  }

  initEdgeInfo() {
    edgeList = [];
    int n = vertexList.length;
    for (int i = 0; i < n; i++) {
      List<EdgeVertex> inner = [];
      for (int j = 0; j < n; j++) {
        String edge = '${vertexList[i].name}-${vertexList[j].name}';
        if (edges.contains(edge) || i == j) {
          inner.add(EdgeVertex(vertexList[i], vertexList[j]));
        } else {
          inner.add(EdgeVertex(vertexList[i], vertexList[j], infinity: true));
        }
      }
      edgeList.add(inner);
    }
  }
}
