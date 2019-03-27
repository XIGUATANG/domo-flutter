import 'package:flutter/material.dart';
import 'dart:math';

enum _FlingGestureKind { none, forward, reverse }

const Curve _kResizeTimeCurve = Interval(0.4, 1.0, curve: Curves.ease);
const double _kMinFlingVelocity = 700.0;
const double _kMinFlingVelocityDelta = 400.0;

const double _kFlingVelocityScale = 2.0 / 300.0;
const double _kDismissThreshold = 0.2;

class Demo2 extends StatefulWidget {
  Demo2({Key key}) : super(key: key);

  Demo2State createState() => new Demo2State();
}

class Demo2State extends State<Demo2>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // ignore: MIXIN_INFERENCE_INCONSISTENT_MATCHING_CLASSES

  @override
  void initState() {
    super.initState();
    _moveController = new AnimationController(
        duration: Duration(milliseconds: 200), vsync: this)
      ..addStatusListener(_handleDismissStatusChanged);
    _updateScaleAnimation();
    _updateMoveAnimation();
  }

  @override
  void didUpdateWidget(Demo2 oldWidgt) {
    super.didUpdateWidget(oldWidgt);
    _updateScaleAnimation();
    _updateMoveAnimation();
  }

  bool get wantKeepAlive => _moveController?.isAnimating == true;

  double _dragExtent = 0.0;
  bool _dragUnderway = false;

  void _handleDismissStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      List<String> testArr = [];
      testArr = _demoArr.sublist(1);

      if (testArr.length != _demoArr.length)
        testArr.addAll(_demoArr.sublist(0, 1));
      setState(() {
        _moveController.value = 0.0;
        _demoArr = testArr;
      });
    }
  }

  void _startResizeAnimation() {
    _resizeController = new AnimationController(
        duration: Duration(milliseconds: 200), vsync: this)
      ..addStatusListener((AnimationStatus status) => updateKeepAlive());
    _resizeController.forward();
    setState(() {
      // _sizePriorToCollapse = context.size;
      _resizeAnimation = new Tween<double>(begin: 1.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: _resizeController, curve: _kResizeTimeCurve));
    });
  }

  bool get _isActive {
    return _dragUnderway || _moveController.isAnimating;
  }

  _FlingGestureKind _describeFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      // If it was a fling, then it was a fling that was let loose at the exact
      // middle of the range (i.e. when there's no displacement). In that case,
      // we assume that the user meant to fling it back to the center, as
      // opposed to having wanted to drag it out one way, then fling it past the
      // center and into and out the other side.
      return _FlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    // Verify that the fling is in the generally right direction and fast enough.
    if (vx.abs() - vy.abs() < _kMinFlingVelocityDelta ||
        vx.abs() < _kMinFlingVelocity) return _FlingGestureKind.none;
    assert(vx != 0.0);
    if (vx < 0) return _FlingGestureKind.forward;
    return _FlingGestureKind.reverse;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isActive || _moveController.isAnimating) return;
    _dragUnderway = false;
    if (_moveController.isCompleted) {
      // _startResizeAnimation();
      return;
    }
    final double flingVelocity = details.velocity.pixelsPerSecond.dx;
    switch (_describeFlingGesture(details.velocity)) {
      case _FlingGestureKind.none:
        {
          if (!_moveController.isDismissed) {
            if (_moveController.value > _kDismissThreshold &&
                flingVelocity < 0.0) {
              _moveController.forward();
            } else {
              _moveController.reverse();
            }
          }
          break;
        }
      case _FlingGestureKind.reverse:
        {
          assert(_dragExtent != 0.0);
          assert(!_moveController.isDismissed);
          _dragExtent = flingVelocity.sign;
          _moveController.reverse();
          break;
        }
      case _FlingGestureKind.forward:
        {
          assert(_dragExtent != 0.0);
          assert(!_moveController.isDismissed);
          _dragExtent = flingVelocity.sign;
          _moveController.fling(
              velocity: flingVelocity.abs() * _kFlingVelocityScale);
          break;
        }
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _dragUnderway = true;
    if (_moveController.isAnimating) {
      _dragExtent =
          _moveController.value * context.size.width * _dragExtent.sign;
      _moveController.stop();
    } else {
      _dragExtent = 0.0;
      _moveController.value = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
      _updateScaleAnimation();
    });
  }

  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;
    _moveAnimation =
        new Tween<Offset>(begin: Offset.zero, end: new Offset(end, 0.0))
            .animate(_moveController);
  }

  void _updateScaleAnimation() {
    _positionAndScale =
        new Tween<double>(begin: 0.9, end: 1.05).animate(_moveController);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // if (!_isActive || _moveController.isAnimating) return;

    final double delta = details.primaryDelta;
    final double oldDragExtent = _dragExtent;

    _dragExtent += delta;
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
        _updateScaleAnimation();
      });
    }
    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / context.size.width;
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  AnimationController _moveController;
  Animation<Offset> _moveAnimation;

  AnimationController _resizeController;
  Animation<double> _resizeAnimation;

  Animation<double> _positionAndScale;

  Widget _cardBox(String text) {
    return new Container(
        width: 375.0,
        child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          new SizedBox(
            width: 240.0,
            height: 320.0,
            child: new Container(
              child: new Text(text),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.green),
            ),
          ),
        ]));
  }

  Function _buildAnimationIndex(int index, String text) {
    print(_positionAndScale.value);
    return (BuildContext context, Widget child) => new Positioned(
        child: new Transform(
          child: _cardBox(text),
          alignment: Alignment.center,
          transform: new Matrix4.diagonal3Values(
              _positionAndScale.value * pow(0.9, index),
              _positionAndScale.value * pow(0.9, index),
              1.0),
        ),
        left: 300.0 - 300 * _positionAndScale.value + (30.0 * index));
  }

  List<String> _demoArr = ['1111', '2222', '3333'];

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    int index = 0;
    var arrdemo = <Widget>[];
    _demoArr.sublist(1).toList().forEach((item) {
      arrdemo.add(new AnimatedBuilder(
        builder: _buildAnimationIndex(index++, item),
        animation: _moveController,
      ));
    });
    arrdemo = arrdemo.reversed.toList();
    arrdemo.add(new SlideTransition(
      position: _moveAnimation,
      child: _cardBox(_demoArr[0]),
    ));
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
            color: Colors.grey[300],
            child: new GestureDetector(
              onHorizontalDragStart: _handleDragStart,
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              behavior: HitTestBehavior.opaque,
              child: new Container(
                  child: new Center(child: new Stack(children: arrdemo))),
            )));
  }
}
