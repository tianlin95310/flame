import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

//最短路径算法
// https://zhuanlan.zhihu.com/p/33162490
// 0 - 0 = 0
// 0 - 1 = 10
// 0 - 2 = 50
// 0 - 3 = 30
// 0 - 4 = 60

final double maxValue = pow(2, 50).toDouble();

class Vertex {
  Vector2 position;

  String name;

  Vertex(this.position, this.name);

  @override
  String toString() {
    return name;
  }
}

class EdgeVertex {
  Vertex to;
  Vertex from;
  bool? infinity;
  EdgeVertex(this.to, this.from, {this.infinity = false});

  double get distance {
    if (infinity == true) {
      return maxValue;
    }
    return to.position.distanceTo(from.position);
  }

  @override
  String toString() {
    return '$from - $to = $distance\t';
  }
}

void dijkstra(List<List<EdgeVertex>> a, int p, int n) {
  List<double> d = List.filled(n, maxValue);
  Set<int> set = HashSet<int>();
  set.add(p);
  for (int i = 0; i < n; i++) {
    d[i] = a[p][i].distance;
  }

  while (set.length < n) {
    double minValue = maxValue;
    int num = 0;
    for (int i = 0; i < n; i++) {
      if (!set.contains(i) && d[i] < minValue) {
        minValue = d[i];
        num = i;
      }
    }
    for (int i = 0; i < n; i++) {
      if (!set.contains(i)) {
        d[i] = min(d[i], d[num] + a[num][i].distance);
      }
    }
    set.add(num);
  }

  for (int i = 0; i < n; i++) {
    print('$p - $i = ${d[i]}');
  }
}
