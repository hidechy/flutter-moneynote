import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';

class AmazonPurchaseListScreen extends StatefulWidget {
  final String date;
  AmazonPurchaseListScreen({@required this.date});

  @override
  _AmazonPurchaseListScreenState createState() =>
      _AmazonPurchaseListScreenState();
}

class _AmazonPurchaseListScreenState extends State<AmazonPurchaseListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _amazonPurchaseData = List();

  int _total = 0;

  int _prevYear = 0;
  int _nextYear = 0;

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
    _utility.makeYMDYData(widget.date, 0);
    _prevYear = int.parse(_utility.year) - 1;
    _nextYear = int.parse(_utility.year) + 1;

    String url = "http://toyohide.work/BrainLog/api/amazonPurchaseList";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _amazonPurchaseData.add(data['data'][i]);

        _total += int.parse(data['data'][i]['price']);
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Amazon(${_utility.year})'),
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
          _utility.getBackGround(context: context),
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              tooltip: '前年',
                              onPressed: () => _goPrevYear(context: context),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              tooltip: '翌年',
                              onPressed: () => _goNextYear(context: context),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 20),
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_total.toString())}'),
                      ),
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: _amazonPurchaseList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _amazonPurchaseList() {
    return ListView.builder(
      itemCount: _amazonPurchaseData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    var ex_date = (_amazonPurchaseData[position]['date']).split('-');

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: _getLeadingBgColor(month: ex_date[1]),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${ex_date[0]}'),
              Text('${ex_date[1]}'),
            ],
          ),
        ),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_amazonPurchaseData[position]['date']}'),
              Text('${_amazonPurchaseData[position]['item']}'),
              Container(
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(_amazonPurchaseData[position]['price'])}'),
              ),
              Container(
                alignment: Alignment.topRight,
                child: Text(
                  '${_amazonPurchaseData[position]['order_number']}',
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                  ),
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
  Color _getLeadingBgColor({String month}) {
    switch (int.parse(month) % 6) {
      case 0:
        return Colors.orangeAccent.withOpacity(0.3);
        break;
      case 1:
        return Colors.blueAccent.withOpacity(0.3);
        break;
      case 2:
        return Colors.redAccent.withOpacity(0.3);
        break;
      case 3:
        return Colors.purpleAccent.withOpacity(0.3);
        break;
      case 4:
        return Colors.greenAccent.withOpacity(0.3);
        break;
      case 5:
        return Colors.yellowAccent.withOpacity(0.3);
        break;
    }
  }

  /**
   * 画面遷移（前年）
   */
  void _goPrevYear({BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AmazonPurchaseListScreen(date: '${_prevYear}-01-01'),
      ),
    );
  }

  /**
   * 画面遷移（翌年）
   */
  void _goNextYear({BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AmazonPurchaseListScreen(date: '${_nextYear}-01-01'),
      ),
    );
  }
}
