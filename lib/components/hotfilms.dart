import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import './outlinebutton.dart';

import '../http/HttpUtil.dart';

get(String path, Map<String, String> params) async {
  var httpClinet = new HttpClient();
  var uri = new Uri.http('https://api.douban.com', path, params);
  var request = await httpClinet.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  return json.decode(responseBody);
}

class HotFilms extends StatefulWidget {
  HotFilms({Key key}) : super(key: key);

  HotFilmsState createState() => new HotFilmsState();
}

class HotFilmsState extends State<HotFilms> with AutomaticKeepAliveClientMixin {
  List _filmList = [];

  TextStyle smallfont = TextStyle(color: Color(0xFF666666), fontSize: 12.0);

  Future _dioGetHotFilms() async {
    var response = await HttpUtil().get('/v2/movie/in_theaters?city=苏州');
  }

  Future<Map<String, dynamic>> _getHotFilms() async {
    return await HttpUtil().get('/v2/movie/in_theaters?city=苏州');
    // return await response.transform(utf8.decoder).join();
  }

  @override
  void initState() {
    // TODO: implement initState
    // _getHotFilms();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void _showMessage() {
    // Tooltip()
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: new Text(
        '123',
      ),
      duration: Duration(seconds: 2),
    ));
  }

  Future<Null> _loadList() async {
    await _getHotFilms();
    if (!mounted) return;
    setState(() {});
  }

  Widget _renderCollect(int collectCount) {
    String collectCountStr = collectCount < 10000
        ? collectCount.toString()
        : (collectCount / 10000).toStringAsFixed(1) + '万';

    return new Text(collectCountStr + '人看过',
        style: TextStyle(
            fontSize: 10.0,
            // height: 10.0,
            color: Colors.red[300]));
  }

  List<Widget> _rankstars(Map starsMap) {
    try {
      var stars = starsMap['stars'];
      double average = double.parse(starsMap['average'].toString());
      if (stars == '00') {
        throw new Error();
      }
      int starCount = int.parse(stars);
      double starCout = starCount / 10;
      var starsList = <Widget>[];
      new List(starCout.toInt()).forEach((item) {
        starsList.add(Icon(
          Icons.star,
          size: 12.0,
          color: Colors.yellow[700],
        ));
      });
      // List numArr = new List(starCout.toInt());
      // List<Widget> starsList = numArr
      //     .map((item) =>
      //     .toList();
      if (starCount % 10 != 0) {
        starsList.add(Icon(
          Icons.star_half,
          size: 12.0,
          color: Colors.yellow[700],
        ));
      }
      int starsLenght = starsList.length;
      for (var i = starsLenght; i < 5; i++) {
        starsList.add(Icon(
          Icons.star,
          size: 12.0,
          color: Colors.grey[300],
        ));
      }
      // while (starsList.length < 5) {
      //   starsList.add(Icon(
      //     Icons.star,
      //     size: 12.0,
      //     color: Colors.grey[700],
      //   ));
      // }
      starsList.add(new Container(
        padding: EdgeInsets.only(left: 3.0),
        child: new Text(
          average.toString(),
          style: TextStyle(
              fontSize: 10.0, color: Color(0xFF666666), wordSpacing: 12.0),
        ),
      ));
      return starsList.toList();
    } catch (e) {
      return [
        new Text(
          '暂无评分',
          style: TextStyle(color: Color(0xFF666666), fontSize: 12.0),
        )
      ];
    }
  }

  Widget _renderAbout(Map filmInfo) {
    try {
      String directorsName =
          filmInfo['directors'].map((item) => item['name']).join(' / ');
      String castsName =
          filmInfo['casts'].map((item) => item['name']).join(' / ');

      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new Text(
              '导演：' + directorsName,
              style: smallfont,
              maxLines: 1,
            ),
            padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
          ),
          new Text(
            '主演：' + castsName,
            style: smallfont,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    } catch (e) {
      return new Row(
        children: <Widget>[],
      );
    }
  }

  Widget _filmsRow(filmInfo) {
    return new Column(
      children: <Widget>[
        new Container(
            height: 142.0,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new SizedBox(
                  width: 80.0,
                  height: 112.0,
                  child: new Image.network(
                    filmInfo['images']['small'],
                    fit: BoxFit.fill,
                  ),
                ),
                new Expanded(
                  child: new Container(
                      height: 140.0,
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: new Text(
                              filmInfo['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF444444),
                              ),
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: new Row(
                                children: _rankstars(filmInfo['rating'])),
                          ),
                          _renderAbout(filmInfo)
                        ],
                      )),
                ),
                new Container(
                  width: 65.0,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(top: 5.0, bottom: 8.0),
                          child: _renderCollect(filmInfo['collect_count'])),
                      new LineButton(
                        text: '购票',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/detail');
                          // _showMessage();
                          // print('11');
                          // PrintHandler()
                        },
                      )
                      // new FlatButton(
                      //     // borderSide: BorderSide(
                      //     //     color: Colors.red[300], style: BorderStyle.solid),
                      //     onPressed: () => {},
                      //     padding: EdgeInsets.all(2.0),
                      //     textColor: Colors.red[300],
                      //     child: new Text(
                      //       '购票',
                      //       style: TextStyle(fontSize: 10.0),
                      //     ))
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget loadList(List filmList) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext othercontext) {
    //       return new Text('123');
    //     });
    return new ListView.builder(
        primary: true,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        cacheExtent: 100.0,
        shrinkWrap: true,
        itemExtent: 142.0,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        // padding: const EdgeInsets.all(16.0),
        itemCount: filmList.length,
        itemBuilder: (BuildContext othercontext, int index) {
          return _filmsRow(filmList[index]);
          //return new Text('${filmList.length}');
        });
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List filmList = [];
    Map jsonData = snapshot.data;
    if (jsonData['subjects'] != null) {
      filmList = jsonData['subjects'];
    }
    _filmList = filmList;
    return loadList(filmList);
    // return new Text('${filmList.length}');
    // return _filmsRow(filmList[i]);
    // return new ListView.builder(
    //     primary: true,
    //     addAutomaticKeepAlives: true,
    //     addRepaintBoundaries: true,
    //     cacheExtent: 100.0,
    //     shrinkWrap: true,
    //     itemExtent: 142.0,
    //     scrollDirection: Axis.vertical,
    //     physics: const AlwaysScrollableScrollPhysics(),
    //     // padding: const EdgeInsets.all(16.0),
    //     itemCount: filmList.length,
    //     itemBuilder: (BuildContext othercontext, int index) {
    //       return _filmsRow(filmList[index]);
    //       //return new Text('${filmList.length}');
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        backgroundColor: Colors.green,
        onRefresh: _loadList,
        child: new FutureBuilder(
            future: _getHotFilms(),
            builder: (BuildContext contetext, AsyncSnapshot snashot) {
              switch (snashot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  if (_filmList.length == 0) {
                    return new Center(
                        child: new Card(
                      child: Text('加载中'),
                    ));
                  }
                  return loadList(_filmList);
                  break;
                default:
                  if (snashot.hasError) {
                    return new Text('Error: ${snashot.error}');
                  }
                  //return new Text('123');
                  return createListView(contetext, snashot);
              }
            }));
  }
}
