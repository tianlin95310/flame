import 'dart:collection';
import 'dart:math';

//最短路径算法
// https://zhuanlan.zhihu.com/p/33162490
// 0 - 0 = 0
// 0 - 1 = 10
// 0 - 2 = 50
// 0 - 3 = 30
// 0 - 4 = 60

final double maxValue = pow(2, 50).toDouble();

class ResultInfo {
  List<double> distances;
  List<List<int>> paths;
  ResultInfo(this.distances, this.paths);
}
ResultInfo dijkstra(List<List<double>> map, int start, int n) {
  final List<double> dist = List.filled(n, maxValue);
  Set<int> visit = HashSet<int>();
  visit.add(start);
  // 松弛路径
  List<int> path = List.filled(n, -1);
  path[start] = start;

  // 保存i - start的距离值
  for (int i = 0; i < n; i++) {
    dist[i] = map[start][i];
  }

  while (visit.length < n) {
    double minValue = maxValue;
    int minIndex = 0;
    for (int i = 0; i < n; i++) {
      if (!visit.contains(i) && dist[i] < minValue) {
        minValue = dist[i];
        minIndex = i;
      }
    }
    for (int i = 0; i < n; i++) {
      if (!visit.contains(i)) {
        double temp = dist[minIndex] + map[minIndex][i];
        if (temp < dist[i] && map[minIndex][i] != maxValue) {
          dist[i] = min(dist[i], temp);
          path[i] = minIndex;
        }
      }
    }
    visit.add(minIndex);
  }

  List<List<int>> paths = [];
  for (int i = 0; i < n; i++) {
    if (dist[i] == maxValue) {
      continue;
    }
    List<int> currentPath = [];
    currentPath.add(i);
    int now = path[i];
    while(now != start && now != -1) {
      currentPath.add(now);
      now = path[now];
    }
    currentPath.add(start);
    paths.add(currentPath.reversed.toList());
  }

  return ResultInfo(dist, paths);
}
