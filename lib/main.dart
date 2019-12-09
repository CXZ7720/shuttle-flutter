import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'reusable_card.dart';
import 'shuttle_query.dart';
import 'dart:async';
import 'const.dart';
import 'FutureBuilder.dart';
import 'GBusBuilder.dart';
import 'bus_query.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //make devices portrait. Prevent rotate.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: '버스 어디?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '버스 어디?'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Timetable> shuttlecock_i;
  Future<Timetable> shuttlecock_o;
  Future<Timetable> giksa;
  Future<Timetable> subway;
  Future<Timetable> yesulin;

  Future<Bus> bus_3102;

  final RefreshController _refreshController = RefreshController();

  void initState() {
    super.initState();
    shuttlecock_i = fetchData("shuttlecock_i");
    shuttlecock_o = fetchData("shuttlecock_o");
    giksa = fetchData("giksa");
    subway = fetchData("subway");
    yesulin = fetchData("yesulin");

    bus_3102 = queryBus("216000379");
  }

  void _onRefreshing() async {
    // monitor network fetch
    shuttlecock_i = fetchData("shuttlecock_i");
    shuttlecock_o = fetchData("shuttlecock_o");
    giksa = fetchData("giksa");
    subway = fetchData("subway");
    yesulin = fetchData("yesulin");
    bus_3102 = getData("216000379");
    setState(() {});

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버스어디?'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          _onRefreshing();
          _refreshController.refreshCompleted();
        },
//        onLoading: _onRefreshing,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ReusableCard(
                color: Colors.white,
                height: (MediaQuery.of(context).size.height) * 0.15,
                cardChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "3102",
                            style: k3102Text,
                          ),
                        ],
                      ),
                    ),
                    busbuilder(bus_3102),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ReusableCard(
                color: Colors.white,
                height: (MediaQuery.of(context).size.height) * 0.2,
                cardChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("셔틀콕", style: kDestinationText),
                        ],
                      ),
                    ),
                    buildFutureBuilder(shuttlecock_o),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      color: Colors.white,
                      height: (MediaQuery.of(context).size.height) * 0.2,
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("셔틀콕\n건너편", style: kDestinationText),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          buildFutureBuilder(shuttlecock_i)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      color: Colors.white,
                      height: (MediaQuery.of(context).size.height) * 0.2,
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("한대앞", style: kDestinationText),
                              ],
                            ),
                          ),
                          buildFutureBuilder(subway)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      color: Colors.white,
                      height: (MediaQuery.of(context).size.height) * 0.2,
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("예술인\n아파트", style: kDestinationText),
                              ],
                            ),
                          ),
                          buildFutureBuilder(yesulin),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      color: Colors.white,
                      height: (MediaQuery.of(context).size.height) * 0.2,
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("기숙사", style: kDestinationText),
                              ],
                            ),
                          ),
                          buildFutureBuilder(giksa),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
