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

  bool _isShowFilmName = false;

  ScrollController _handleScoll;

  @override
  void initState() {
    super.initState();

    _handleScoll = new ScrollController()
      ..addListener(() {
        if (_isShowFilmName !=
            (_handleScoll.position.pixels >= (320.0 - _barHeight)))
          setState(() {
            _isShowFilmName =
                _handleScoll.position.pixels >= (320.0 - _barHeight);
          });
      });
  }

  List<Widget> _buildTitle(isShowFilmName) {
    if (isShowFilmName) {
      return <Widget>[
        new Text(
          '八只鸡',
          style: new TextStyle(
            fontSize: 16.0,
            color: Color(0xFFFFFFFF),
          ),
        )
      ];
    }
    return <Widget>[
      new Icon(
        DoubanIcons.popcorn,
        color: Color(0xFFFFFFFF),
        size: 16.0,
      ),
      Container(
        width: 4.0,
      ),
      new Text(
        '电影',
        style: new TextStyle(
          fontSize: 16.0,
          color: Color(0xFFFFFFFF),
        ),
      ),
    ];
  }

  Future<double> _getHeight() async {
    double _height = await FlutterStatusbar.height;
    if (_height != _barHeight) {
      setState(() {
        _barHeight = _height;
      });
    }
    return _height;
  }

  TextStyle _smallfont =
      new TextStyle(color: Color(0xFF999999), fontSize: 11.0);

  @override
  Widget build(BuildContext context) {
    _getHeight();
    return new Scaffold(
      backgroundColor: Colors.lime[300],
      body: new CustomScrollView(
        controller: _handleScoll,
        slivers: <Widget>[
          SliverAppBar(
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.lime[300],
            elevation: 0.0,
            pinned: true,
            title: Container(
              height: double.infinity,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    new Row(
                      children: _buildTitle(_isShowFilmName),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    new IconButton(
                      icon: new Icon(
                        DoubanIcons.share,
                        color: Color(0xFFFFFFFF),
                        size: 22.0,
                      ),
                      onPressed: () {},
                    )
                  ]),
            ),
            // actions: <Widget>[
            //
            // ],
            expandedHeight: 320.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: new Container(
                margin: EdgeInsets.only(top: _barHeight),
                color: Colors.lime[300],
                // padding: EdgeInsets.only(top: 40.0),
                height: 320.0,
                child: new Center(
                    widthFactor: 240.0,
                    heightFactor: 180.0,
                    child: new Image.network(
                        'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2525715533.jpg',
                        width: 160.0,
                        fit: BoxFit.cover)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                height: 1800.0,
                child: new Container(
                    color: Colors.grey[200],
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(20.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                flex: 1,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          color: const Color(0x33333333),
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
                                style: TextStyle(color: Colors.grey[400])))
                      ],
                    )),
              )
            ]),
          )
        ],
      ),
    );
  }
}
