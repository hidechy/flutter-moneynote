import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';

class MercariDataDisplayScreen extends StatefulWidget {
  @override
  _MercariDataDisplayScreenState createState() =>
      _MercariDataDisplayScreenState();
}

class _MercariDataDisplayScreenState extends State<MercariDataDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _mercariData = List();

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
    //----------------------------//
    Map mercaridata = Map();

    String url = "http://toyohide.work/BrainLog/api/mercaridata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ""});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      mercaridata = jsonDecode(response.body);

      for (var i = 0; i < mercaridata['data'].length; i++) {
        _mercariData.add(mercaridata['data'][i]);
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('mercari'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: EdgeInsets.only(top: 5, left: 6),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          _mercariList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _mercariList() {
    return ListView.builder(
      itemCount: _mercariData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    _utility.makeYMDYData(_mercariData[position]['date'], 0);

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${_mercariData[position]['date']}（${_utility.youbiStr}）'),
                  Text(
                      '${_utility.makeCurrencyDisplay(_mercariData[position]['day_total'].toString())}'),
                ],
              ),
              _dispDailyItem(
                date: _mercariData[position]['date'],
                record: _mercariData[position]['record'],
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        '${_utility.makeCurrencyDisplay(_mercariData[position]['total'].toString())}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  Widget _dispDailyItem({date, record}) {
    var ex_record = (record).split('/');

    List<Widget> _list = [];
    for (var i = 0; i < ex_record.length; i++) {
      var ex_oneline = (ex_record[i]).split('|');

      _list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                child: _getBuySellMark(buy_sell: ex_oneline[0]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${ex_oneline[1]}'),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              (ex_oneline[0] == 'sell')
                                  ? Text(
                                      '${_utility.makeCurrencyDisplay(ex_oneline[5])}')
                                  : Text(
                                      '-${_utility.makeCurrencyDisplay(ex_oneline[5])}'),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '決済日：${ex_oneline[7]}',
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8)),
                              ),
                              (ex_oneline[0] == 'sell')
                                  ? Text(
                                      '送付日：${ex_oneline[6]}',
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.8)),
                                    )
                                  : Text(
                                      '到着日：${ex_oneline[8]}',
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.8)),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }

  /**
   *
   */
  Widget _getBuySellMark({buy_sell}) {
    switch (buy_sell) {
      case "sell":
        return Icon(Icons.arrow_upward, size: 20, color: Colors.yellowAccent);
        break;
      case "buy":
        return Icon(Icons.arrow_downward, size: 20, color: Colors.redAccent);
        break;
    }
  }
}
