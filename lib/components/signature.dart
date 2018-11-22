import 'package:flutter/material.dart';

export './signature.dart' show Signature;

class SignaturePainter extends CustomPainter {
  SignaturePainter({this.points});

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blue[200]
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 12.0
      ..strokeJoin = StrokeJoin.bevel;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {
  Signature({Key key}) : super(key: key);

  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      Expanded(
          flex: 12,
          child: Stack(
            overflow: Overflow.clip,
            fit: StackFit.loose,
            children: [
              GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    RenderBox referenceBox = context.findRenderObject();
                    Offset localPosition =
                        referenceBox.globalToLocal(details.globalPosition);
                    setState(() {
                      _points = new List.from(_points)..add(localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) => _points.add(null)),
              CustomPaint(
                painter: new SignaturePainter(points: _points),
              ),
            ],
          )),
      new Expanded(
          flex: 1,
          child: Card(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [new Text('123')]),
          ))
    ]);
  }
}
