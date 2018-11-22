import 'package:flutter/material.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'dart:async';

import '../doubanicon.dart';

class FilmDetail extends StatefulWidget {
  FilmDetail({Key key, this.filmId}) : super(key: key);

  final String filmId;

  FilmDetailState createState() => new FilmDetailState();
}

class FilmDetailState extends State<FilmDetail> {
  double _barHeight = 0.0;
  bool _isUpdirection = false;

  ScrollController _handleScoll;

  @override
  void initState() {
    super.initState();

    _handleScoll = new ScrollController()
      ..addListener(() {
        if (_isUpdirection != (_handleScoll.position.pixels <= 0)) {
          setState(() {
            _isUpdirection = (_handleScoll.position.pixels <= 0);
          });
        }
        // print(_handleScoll.position.axisDirection.toString());
      });
  }

  Future<double> _getHeight() async {
    double _height = await FlutterStatusbar.height;
    setState(() {
      _barHeight = _height;
    });
    return _height;
  }

  TextStyle _smallfont =
      new TextStyle(color: Color(0xFF999999), fontSize: 11.0);

  @override
  Widget build(BuildContext context) {
    _getHeight();
    return new Scaffold(
        backgroundColor: _isUpdirection ? Colors.lime[300] : Colors.grey[200],
        body: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
              controller: _handleScoll,
              child: new Container(
                  color: Colors.lime[300],
                  padding: EdgeInsets.only(top: 44.0 + _barHeight),
                  height: 750.0,
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          color: Colors.lime[300],
                          child: new Center(
                            child: new Image.network(
                              'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2525715533.jpg',
                              width: 200.0,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Container(
                            color: Colors.grey[200],
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Expanded(
                                        flex: 1,
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              '八只鸡',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF444444)),
                                            ),
                                            new Text(
                                              '2018/中国大陆/剧情',
                                              style: _smallfont,
                                            ),
                                            new Text(
                                              '上映时间：2018-07-19(中国大陆)',
                                              style: _smallfont,
                                            ),
                                          ],
                                        ),
                                      ),
                                      new SizedBox(
                                        height: 80.0,
                                        width: 80.0,
                                        child: new Container(
                                          child: new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Container(
                                                padding: EdgeInsets.all(0.0),
                                                child: new Text(
                                                  '豆瓣评分',
                                                  style: TextStyle(
                                                      fontSize: 11.0,
                                                      color: Colors.grey[300]),
                                                ),
                                              ),
                                              new Container(
                                                padding: EdgeInsets.only(
                                                    top: 2.0, bottom: 2.0),
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.star,
                                                      size: 12.0,
                                                      color: Colors.grey[300],
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 12.0,
                                                      color: Colors.grey[300],
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 12.0,
                                                      color: Colors.grey[300],
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 12.0,
                                                      color: Colors.grey[300],
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 12.0,
                                                      color: Colors.grey[300],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              new Text(
                                                '尚未上映',
                                                style: _smallfont,
                                              )
                                            ],
                                          ),
                                          decoration: new BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              boxShadow: <BoxShadow>[
                                                new BoxShadow(
                                                  color:
                                                      const Color(0x33333333),
                                                  offset: new Offset(0.0, 1.0),
                                                  blurRadius: 4.0,
                                                ),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                new Container(
                                    child: new Text('剧情简介',
                                        style:
                                            TextStyle(color: Colors.grey[400])))
                              ],
                            )),
                      ),
                    ],
                  )),
            ),
            new Positioned(
              width: MediaQuery.of(context).size.width,
              height: 44.0 + _barHeight,
              left: 0.0,
              top: 0.0,
              child: new Container(
                padding: EdgeInsets.only(top: _barHeight),
                height: 44.0,
                color: Color(0x66E6EE9C),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 22.0,
                        color: Color(0xFFFFFFFF),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new SizedBox(
                      height: 44.0,
                      width: 62.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Icon(
                            DoubanIcons.popcorn,
                            color: Color(0xFFFFFFFF),
                            size: 22.0,
                          ),
                          new Text(
                            '电影',
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(
                        DoubanIcons.share,
                        color: Color(0xFFFFFFFF),
                        size: 22.0,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
