import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({super.key});

  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<List<Offset>> lines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(details.globalPosition);
            if (lines.isEmpty || lines.last.isEmpty) {
              lines.add([localPosition]);
            } else {
              lines.last.add(localPosition);
            }
          });
        },
        onPanEnd: (_) {
          setState(() {
            lines.add([]);
          });
        },
        child: CustomPaint(
          painter: MyPainter(lines),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            lines.clear();
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> lines;
  MyPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }

    Paint face = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Paint eyes = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Paint mouth = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, face);
    canvas.drawCircle(Offset(size.width / 2 - 40, size.height / 2 - 40), 10, eyes);
    canvas.drawCircle(Offset(size.width / 2 + 40, size.height / 2 - 40), 10, eyes);

    Rect mouthRect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2 + 20), radius: 50);
    canvas.drawArc(mouthRect, 0, pi, false, mouth);

    Paint heartPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Path heart = Path();
    heart.moveTo(size.width / 2, size.height / 2 + 150);
    heart.cubicTo(size.width / 2 - 50, size.height / 2 + 100, size.width / 2 - 100, size.height / 2 + 150, size.width / 2, size.height / 2 + 200);
    heart.cubicTo(size.width / 2 + 100, size.height / 2 + 150, size.width / 2 + 50, size.height / 2 + 100, size.width / 2, size.height / 2 + 150);
    heart.close();

    canvas.drawPath(heart, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}