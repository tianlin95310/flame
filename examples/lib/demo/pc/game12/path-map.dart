import 'dart:ui';

import 'package:examples/demo/utils/shortest_path.dart';
import 'package:flame/components.dart';

class PathMap extends PositionComponent with HasPaint {
  List<Vertex> points;
  List<List<EdgeVertex>> edgeList;

  Vector2 cSize = Vector2.all(5);

  final Paint _edgePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..isAntiAlias = true
    ..color = const Color(0xFF000000);

  final Paint _bgPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFF00cccc);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _bgPaint);

    for (var element in points) {
      canvas.drawCircle(
        element.position.toOffset(),
        cSize.x,
        paint,
      );
      ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(
        fontSize: 16,
      ))
        ..addText(element.name)
        ..pushStyle(
          TextStyle(color: const Color(0xff00ff00)),
        );
      Paragraph paragraph = builder.build()
        ..layout(ParagraphConstraints(width: cSize.length));

      canvas.drawParagraph(
        paragraph,
        Offset(element.position.x - paragraph.width,
            element.position.y - paragraph.height),
      );

      for (var outer in edgeList) {
        for (var inner in outer) {
          if (inner.infinity == false) {
            canvas.drawLine(inner.from.position.toOffset(),
                inner.to.position.toOffset(), _edgePaint);
          }
        }
      }

    }
  }

  PathMap(this.points, this.edgeList, {super.size, super.position})
      : super(anchor: Anchor.topLeft);
}

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
