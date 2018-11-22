import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  Demo({Key key}) : super(key: key);

  DemoState createState() => new DemoState();
}

class DemoState extends State<Demo> {
  double _sliderValue = 1.0;

  double _boxHeight = 22.0;

  GlobalKey _myKey = new GlobalKey();

  // 生命周期
  @override
  void initState() {
    // TODO: implement initState
    // _getHotFilms();
    print('init');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');

    // 在这里可以跨组件拿到数据
    // context.inheritFromWidgetOfExactType()
  }

  @override
  void didUpdateWidget(Demo oldWidgt) {
    // print(oldWidgt)
    super.didUpdateWidget(oldWidgt);
    print('didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  Widget _renderColumn() {
    return new Container(
      height: 88.0,
      child: new Column(
        children: <Widget>[
          new Container(
            // padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 2.0),
            height: _boxHeight,
            color: Colors.lightGreen,
          ),
          new Expanded(
            flex: 1,
            child: new Container(
              color: Colors.lightBlue,
            ),
          ),
          new Expanded(
            flex: 2,
            child: new Container(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderRow() {
    return new Container(
      height: 88.0,
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new Container(
              color: Colors.blue,
            ),
          ),
          Expanded(
            flex: 2,
            child: new Container(
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: _sliderValue.floor(),
            child: new Container(
              color: Colors.red,
              height: 88.0,
              child: new Text(
                'flex${_sliderValue.floor()}',
                textAlign: TextAlign.center,
                style: TextStyle(height: 3.6),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // leading: new Container(),
        title: new Text('Demo'),
        elevation: 0.0,
      ),
      body: new Container(
          width: 375.0,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Row'),
              new Slider(
                inactiveColor: Colors.red,
                label: '123',
                value: _sliderValue,
                max: 5.0,
                min: 1.0,
                activeColor: Colors.lightGreen,
                onChanged: (double value) {
                  // _sliderValue = value;
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
              _renderRow(),
              new Text('Column'),
              new Slider(
                inactiveColor: Colors.red,
                label: '123',
                value: _boxHeight,
                min: 10.0,
                max: 66.0,
                activeColor: Colors.lightGreen,
                onChanged: (double value) {
                  setState(() {
                    _boxHeight = value;
                  });
                },
              ),
              _renderColumn(),
              new Text('backgroundImage'),
              new Container(
                  height: 200.0,
                  width: 200.0,
                  child: new Text('123'),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(200.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: const Color(0x80000000),
                          offset: new Offset(2.0, 2.0),
                          blurRadius: 2.0,
                        ),
                      ],
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          image: AssetImage('images/xiaodingdang.jpeg')))),
              new Text('123456', key: _myKey)
            ],
          ),
          decoration: new BoxDecoration(
            // shape: BoxShape.circle,
            color: Colors.grey[200],
          )),
    );
  }
}
