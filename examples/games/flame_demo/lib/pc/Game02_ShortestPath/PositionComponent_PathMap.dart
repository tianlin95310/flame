import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import 'ShortestPathUtils.dart';

class PathMap extends PositionComponent with HasPaint {
  List<Vertex> points;
  List<List<EdgeVertex>> edgeList;

  Vector2 cSize = Vector2.all(2);

  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = const Color(0xFF000000);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    paint.color = const Color(0xFFFF00FF);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    paint.color = const Color(0xFFFFFFFF);
    for (var element in points) {
      canvas.drawCircle(
        element.position.toOffset(),
        cSize.x,
        paint,
      );
      ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(fontSize: 14))
        ..addText(element.name);
      Paragraph paragraph = builder.build()
        ..layout(ParagraphConstraints(width: cSize.length));

      for (var outer in edgeList) {
        for(var inner in outer) {
          if (inner.infinity == false) {
            canvas.drawLine(inner.from.position.toOffset(), inner.to.position.toOffset(), _paint);
          }
        }
      }

      canvas.drawParagraph(
        paragraph,
        Offset(element.position.x - paragraph.width, element.position.y - paragraph.height),
      );
    }
  }

  PathMap(this.points, this.edgeList, {super.size, super.position})
      : super(anchor: Anchor.topLeft);
}
