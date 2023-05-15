import 'dart:async';

import 'package:flame/components.dart';

import 'PositionComponent_PathMap.dart';
import 'ShortestPathUtils.dart';

class DemoGame02 extends Component with HasGameRef {
  final List<Vertex> vertexList = [
    Vertex(Vector2(0, 0), 'A'),
    Vertex(Vector2(150, 0), 'B'),
    Vertex(Vector2(150, 200), 'C'),
    Vertex(Vector2(100, 200), 'D'),
  ];
  List<String> edges = [
    'A - B',
    'B - A',
    'B - C',
    'C - B',
    'C - D',
    'D - C',
    'A - C',
    'C - A'
  ];
  List<List<EdgeVertex>> edgeList = [];

  @override
  FutureOr<void> onLoad() async {
    print('DemoGame02 onLoad');
    edgeList = [];
    int n = vertexList.length;
    for (int i = 0; i < n; i++) {
      List<EdgeVertex> inner = [];
      for (int j = 0; j < n; j++) {
        String edge = '${vertexList[i].name} - ${vertexList[j].name}';
        if (edges.contains(edge) || i == j) {
          inner.add(EdgeVertex(vertexList[i], vertexList[j]));
        } else {
          inner.add(EdgeVertex(vertexList[i], vertexList[j], infinity: true));
        }
      }
      edgeList.add(inner);
    }
    print(edgeList);

    add(PathMap(
      vertexList,
      edgeList,
      position: Vector2(25, 25),
      size: game.canvasSize - Vector2(50, 50),
    ));
  }

  @override
  void onMount() {
    print('DemoGame02 onMount');
    super.onMount();
    dijkstra(edgeList, 0, 4);
  }
}
