import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../utilities/utility.dart';

class SpendDetailDisplayScreen extends StatefulWidget {
  final String date;
  SpendDetailDisplayScreen({@required this.date});

  @override
  _SpendDetailDisplayScreenState createState() =>
      _SpendDetailDisplayScreenState();
}

class _SpendDetailDisplayScreenState extends State<SpendDetailDisplayScreen> {
  Utility _utility = Utility();

  String _spendSum = '0';
  List<List<String>> _spendDetailData = List();

  List<String> _trainData = List();

  List<Map<dynamic, dynamic>> _timePlaceData = List();

  /**
   * 初期動作
   */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /**
   * 初期データ作成
   */
  void _makeDefaultDisplayData() async {
    /////////////////////////////////////////////////////
    Response response = await get(
        'http://toyohide.work/BrainLog/money/${widget.date}/spenditemapi');

    if (response != null) {
      Map data = jsonDecode(response.body);
      if (data['data']['date'] == widget.date) {
        var ex_data = (data['data']['item']).split(";");
        for (var i = 0; i < ex_data.length; i++) {
          _spendDetailData.add((ex_data[i]).split("|"));
        }
        _spendSum = data['data']['sum'];
      }
    }

    /////////////////////////////////////////////////////
    Response response2 = await get(
        'http://toyohide.work/BrainLog/article/${widget.date}/traindataapi');

    if (response2 != null) {
      Map data2 = jsonDecode(response2.body);
      for (var i = 0; i < data2['data']['article'].length; i++) {
        _trainData.add(data2['data']['article'][i]);
      }
    }

    /////////////////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/timeplace";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response3 = await post(url, headers: headers, body: body);

    if (response3 != null) {
      Map data3 = jsonDecode(response3.body);

      for (var i = 0; i < data3['data'].length; i++) {
        var _map = Map();
        _map['time'] = data3['data'][i]['time'];
        _map['place'] = data3['data'][i]['place'];
        _map['price'] = data3['data'][i]['price'];
        _map['inTrain'] = (data3['data'][i]['place'] == "移動中") ? 1 : 0;
        _timePlaceData.add(_map);
      }
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Spend Detail'),
        centerTitle: true,
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        _utility.getBackGround(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.black.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text('${widget.date}（${_utility.youbiStr}）'),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                Text('${_spendSum}'),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                (_spendDetailData.length == 0)
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _spendDetailData.length,
                          itemBuilder: (context, int position) =>
                              _listItem(position: position),
                        ),
                      ),
                (_timePlaceData.length == 0)
                    ? Container()
                    : const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                (_timePlaceData.length == 0)
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _timePlaceData.length,
                          itemBuilder: (context, int position) =>
                              _listItem3(position: position),
                        ),
                      ),
                (_trainData.length == 0)
                    ? Container()
                    : const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                (_trainData.length == 0)
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _trainData.length,
                          itemBuilder: (context, int position) =>
                              _listItem2(position: position),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  /**
   * リストアイテム表示
   */
  _listItem({int position}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Table(
        children: [
          TableRow(children: [
            Text('${_spendDetailData[position][0]}'),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                  '${_utility.makeCurrencyDisplay(_spendDetailData[position][1])}'),
            ),
            Align(),
          ]),
        ],
      ),
    );
  }

  /**
   * リストアイテム表示
   */
  _listItem2({int position}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Table(
        children: [
          TableRow(children: [
            Text('${_trainData[position]}'),
          ]),
        ],
      ),
    );
  }

  /**
   * リストアイテム表示
   */
  _listItem3({int position}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Table(
        children: [
          TableRow(children: [
            Container(
              child: Text('${_timePlaceData[position]['time']}'),
              color: (_timePlaceData[position]['inTrain'] == 1)
                  ? Colors.greenAccent.withOpacity(0.3)
                  : Colors.black,
            ),
            Container(
              child: Text('${_timePlaceData[position]['place']}'),
              color: (_timePlaceData[position]['inTrain'] == 1)
                  ? Colors.greenAccent.withOpacity(0.3)
                  : Colors.black,
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text('${_timePlaceData[position]['price']}'),
              color: (_timePlaceData[position]['inTrain'] == 1)
                  ? Colors.greenAccent.withOpacity(0.3)
                  : Colors.black,
            ),
          ]),
        ],
      ),
    );
  }
}
