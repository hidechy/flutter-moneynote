import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

class CreditMonthlyListScreen extends StatefulWidget {
  final String date;
  CreditMonthlyListScreen({@required this.date});

  @override
  _CreditMonthlyListScreenState createState() =>
      _CreditMonthlyListScreenState();
}

class _CreditMonthlyListScreenState extends State<CreditMonthlyListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _monthlyCreditData = List();

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
    var _ym = _getYm();

    for (var i = 0; i < _ym.length; i++) {
      int _monthTotal = 0;
      int _creditUc = 0;
      int _creditRakuten = 0;
      int _creditSumitomo = 0;

      ///////////////////////
      String url = "http://toyohide.work/BrainLog/api/uccardspend";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"date": '${_ym[i]}-01'});
      Response response = await post(url, headers: headers, body: body);

      if (response != null) {
        Map data = jsonDecode(response.body);

        for (var i = 0; i < data['data'].length; i++) {
          _monthTotal += int.parse(data['data'][i]['price']);

          if (data['data'][i]['kind'] == "uc") {
            _creditUc += int.parse(data['data'][i]['price']);
          }

          if (data['data'][i]['kind'] == "rakuten") {
            _creditRakuten += int.parse(data['data'][i]['price']);
          }

          if (data['data'][i]['kind'] == "sumitomo") {
            _creditSumitomo += int.parse(data['data'][i]['price']);
          }
        }
      }
      ///////////////////////

      Map _map = Map();
      _map['date'] = _ym[i];
      _map['monthTotal'] = _monthTotal;
      _map['creditUc'] = _creditUc;
      _map['creditRakuten'] = _creditRakuten;
      _map['creditSumitomo'] = _creditSumitomo;

      _monthlyCreditData.add(_map);
    }

    setState(() {});
  }

  /**
   *
   */
  List _getYm() {
    List _ym = List();

    final start = DateTime(2020, 1, 1);
    final today = DateTime.now();

    int diffDays = today.difference(start).inDays;

    _utility.makeYMDYData(start.toString(), 0);
    var baseYear = _utility.year;
    var baseMonth = _utility.month;
    var baseDay = _utility.day;

    for (int i = 0; i <= diffDays; i++) {
      var genDate = new DateTime(
          int.parse(baseYear), int.parse(baseMonth), (int.parse(baseDay) + i));
      _utility.makeYMDYData(genDate.toString(), 0);

      if (!_ym.contains(_utility.year + "-" + _utility.month)) {
        _ym.add(_utility.year + "-" + _utility.month);
      }
    }

    return _ym;
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Monthly Credit'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          _monthlyCreditList(),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _monthlyCreditList() {
    return ListView.builder(
      itemCount: _monthlyCreditData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
//        trailing: _getCreditTrailing(kind: _ucCardSpendData[position]['kind']),
//        onTap: () => _addSelectedAry(position: position),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${_monthlyCreditData[position]['date']}'),
                  Text(
                      '${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['monthTotal'].toString())}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 60,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Container(
                              child: Text(
                                  'UC　${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['creditUc'].toString())}'),
                            ),
                            Container(
                              child: Text(
                                  '楽天　${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['creditRakuten'].toString())}'),
                            ),
                            Container(
                              child: Text(
                                  '住友　${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['creditSumitomo'].toString())}'),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
