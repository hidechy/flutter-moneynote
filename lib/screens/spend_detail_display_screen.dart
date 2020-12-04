import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../main.dart';
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

  String _yen10000 = '0';
  String _yen5000 = '0';
  String _yen2000 = '0';
  String _yen1000 = '0';
  String _yen500 = '0';
  String _yen100 = '0';
  String _yen50 = '0';
  String _yen10 = '0';
  String _yen5 = '0';
  String _yen1 = '0';

  String _bankA = '0';
  String _bankB = '0';
  String _bankC = '0';
  String _bankD = '0';
  String _bankE = '0';
  String _bankF = '0';
  String _bankG = '0';
  String _bankH = '0';

  String _payA = '0';
  String _payB = '0';
  String _payC = '0';
  String _payD = '0';
  String _payE = '0';
  String _payF = '0';
  String _payG = '0';
  String _payH = '0';

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
      if (data['data'] != "nodata") {
        if (data['data']['date'] == widget.date) {
          var ex_data = (data['data']['item']).split(";");
          for (var i = 0; i < ex_data.length; i++) {
            _spendDetailData.add((ex_data[i]).split("|"));
          }
          _spendSum = data['data']['sum'];
        }
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

    /////////////////////////////////////////////////////
    var _money = await database.selectRecord('${widget.date}');

    _yen10000 = _money[0].strYen10000;
    _yen5000 = _money[0].strYen5000;
    _yen2000 = _money[0].strYen2000;
    _yen1000 = _money[0].strYen1000;
    _yen500 = _money[0].strYen500;
    _yen100 = _money[0].strYen100;
    _yen50 = _money[0].strYen50;
    _yen10 = _money[0].strYen10;
    _yen5 = _money[0].strYen5;
    _yen1 = _money[0].strYen1;

    _bankA = _money[0].strBankA;
    _bankB = _money[0].strBankB;
    _bankC = _money[0].strBankC;
    _bankD = _money[0].strBankD;
    _bankE = _money[0].strBankE;
    _bankF = _money[0].strBankF;
    _bankG = _money[0].strBankG;
    _bankH = _money[0].strBankH;

    _payA = _money[0].strPayA;
    _payB = _money[0].strPayB;
    _payC = _money[0].strPayC;
    _payD = _money[0].strPayD;
    _payE = _money[0].strPayE;
    _payF = _money[0].strPayF;
    _payG = _money[0].strPayG;
    _payH = _money[0].strPayH;

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
            padding: const EdgeInsets.only(
              top: 5,
              right: 20,
              left: 20,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check_box_outline_blank),
                      color: Colors.black,
                      onPressed: () => null,
                    ),
                    Text('${widget.date}（${_utility.youbiStr}）'),
                    IconButton(
                      icon: const Icon(Icons.cloud_upload),
                      tooltip: 'synchro',
                      onPressed: () => _uploadDailyData(date: widget.date),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                _makeDisplayMoneyItem(),
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

  /**
   * マネーデータアップロード
   */
  void _uploadDailyData({String date}) async {
    Map<String, dynamic> _uploadData = Map();

    _uploadData['date'] = date;

    _uploadData['yen_10000'] = _yen10000;
    _uploadData['yen_5000'] = _yen5000;
    _uploadData['yen_2000'] = _yen2000;
    _uploadData['yen_1000'] = _yen1000;
    _uploadData['yen_500'] = _yen500;
    _uploadData['yen_100'] = _yen100;
    _uploadData['yen_50'] = _yen50;
    _uploadData['yen_10'] = _yen10;
    _uploadData['yen_5'] = _yen5;
    _uploadData['yen_1'] = _yen1;

    _uploadData['bank_a'] = _bankA;
    _uploadData['bank_b'] = _bankB;
    _uploadData['bank_c'] = _bankC;
    _uploadData['bank_d'] = _bankD;
    _uploadData['bank_e'] = _bankE;
    _uploadData['bank_f'] = _bankF;
    _uploadData['bank_g'] = _bankG;
    _uploadData['bank_h'] = _bankH;

    _uploadData['pay_a'] = _payA;
    _uploadData['pay_b'] = _payB;
    _uploadData['pay_c'] = _payC;
    _uploadData['pay_d'] = _payD;
    _uploadData['pay_e'] = _payE;
    _uploadData['pay_f'] = _payF;
    _uploadData['pay_g'] = _payG;
    _uploadData['pay_h'] = _payH;

    String url = "http://toyohide.work/BrainLog/api/moneyinsert";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(_uploadData);
    await post(url, headers: headers, body: body);

    Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
  }

  /**
   * アップロードデータ表示
   */
  Widget _makeDisplayMoneyItem() {
    return Container(
      color: Colors.blueAccent.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Text('${_yen10000}'),
                    Text('${_yen5000}'),
                    Text('${_yen2000}'),
                    Text('${_yen1000}'),
                    Text('${_yen500}'),
                    Text('${_yen100}'),
                    Text('${_yen50}'),
                    Text('${_yen10}'),
                    Text('${_yen5}'),
                    Text('${_yen1}'),
                  ])
                ],
              ),
              const Divider(
                color: Colors.indigo,
                height: 20.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              (int.parse(_bankA) == 0)
                  ? Container()
                  : Table(
                      children: [
                        TableRow(children: [
                          Text('${_bankA}'),
                          Text('${_bankB}'),
                          Text('${_bankC}'),
                          Text('${_bankD}')
                        ])
                      ],
                    ),
              (int.parse(_bankE) == 0)
                  ? Container()
                  : Table(
                      children: [
                        TableRow(children: [
                          Text('${_bankE}'),
                          Text('${_bankF}'),
                          Text('${_bankG}'),
                          Text('${_bankH}')
                        ])
                      ],
                    ),
              const Divider(
                color: Colors.indigo,
                height: 20.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              (int.parse(_payA) == 0)
                  ? Container()
                  : Table(
                      children: [
                        TableRow(children: [
                          Text('${_payA}'),
                          Text('${_payB}'),
                          Text('${_payC}'),
                          Text('${_payD}')
                        ])
                      ],
                    ),
              (int.parse(_payE) == 0)
                  ? Container()
                  : Table(
                      children: [
                        TableRow(children: [
                          Text('${_payE}'),
                          Text('${_payF}'),
                          Text('${_payG}'),
                          Text('${_payH}')
                        ])
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
