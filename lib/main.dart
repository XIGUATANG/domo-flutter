import 'package:flutter/material.dart';

import './components/hotfilms.dart';
// import './components/buttery.dart';

import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:convert';

import './views/detail.dart';
import './views/demo.dart';
import './views/demo2.dart';
import './http/HttpUtil.dart';


void main() {
  runApp(new MyApp());
  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

get(String path, Map<String, String> params) async {
  var httpClinet = new HttpClient();
  var uri = new Uri.http('api.douban.com', path, params);
  var request = await httpClinet.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          unselectedWidgetColor: Colors.grey[200],
          primaryColor: Colors.grey[100],
          accentColor: Colors.grey[100],
          primarySwatch: Colors.grey,
        ),
        home: MyHomePage(
          title: '123',
        ),
        routes: <String, WidgetBuilder>{
          '/detail': (BuildContext context) => FilmDetail(
                filmId: '123',
              ),
          '/demo': (contenxt) => Demo(),
          '/demo2': (contenxt) => Demo2()
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _currentIndex = 0;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: '正在热映'),
    new Tab(text: '即将上映'),
  ];
  TabController _tabController;

  void _incrementCounter() {
    // Scaffold.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.green,
    //       content: new Text('123'),
    //       duration: Duration(seconds: 2),
    //     ));
    setState(() {
      // Scaffold.of(context).openDrawer();

      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List listItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  Widget dimissRow(BuildContext context) {
    return new ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return new Dismissible(
          direction: DismissDirection.endToStart,
          key: new Key(listItems[index]),
          background: new Container(
            color: Colors.red,
            height: 80.0,
            child: new Text('data'),
          ),
          onDismissed: (direction) {
            setState(() {
              listItems.removeAt(index);
            });
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text('hahha'),
            ));
          },
          child: new Container(
            height: 60.0,
            child: new Text('滑动删除'),
          ),
        );
      },
    );
  }

  var currentPanelIndex = -1;

  List<int> mList = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      appBar: new AppBar(
        flexibleSpace: new DecoratedBox(
          child: new Row(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new Container(),
              ),
            ],
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xFFeeeeee), width: 1.0))),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFFFFFFFF),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              '苏州',
              style: TextStyle(
                  fontSize: 16.0, color: Colors.grey[600], height: 0.8),
            ),
            new Icon(
              Icons.keyboard_arrow_down,
              size: 20.0,
              color: Colors.grey[600],
              textDirection: TextDirection.rtl,
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 4.0),
                height: 32.0,
                decoration: new BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: new BorderRadius.all(Radius.circular(4.0))),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 14.0,
                      color: Colors.grey[400],
                    ),
                    Text(
                      '电影/电视剧/影人',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
            child: new TabBar(
                labelStyle: TextStyle(fontSize: 16.0),
                labelPadding: new EdgeInsets.only(bottom: 0.0),
                // indicatorWeight: 15.0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: new EdgeInsets.only(bottom: 1.0),
                labelColor: Color(0xFF333333),
                indicatorColor: Color(0xFF000000),
                unselectedLabelColor: Color(0xFF999999),
                controller: _tabController,
                tabs: myTabs),
            preferredSize: new Size(double.infinity, 40.0)),
      ),
      // body: singature,
      body: new TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          return tab.text == '正在热映' ? new HotFilms() : dimissRow(context);
        }).toList(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.grey[300],
              icon: Icon(Icons.video_call),
              title: Text('热映')),
          BottomNavigationBarItem(
              backgroundColor: Colors.grey[300],
              icon: Icon(Icons.remove_red_eye),
              title: Text('找片')),
          BottomNavigationBarItem(
              backgroundColor: Colors.grey[300],
              icon: Icon(Icons.person_outline),
              title: Text('我的'))
        ],
        fixedColor: Colors.grey[900],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              Navigator.of(context).pushNamed('/demo');
            }
          });
        },
      ),
    );
  }
}
