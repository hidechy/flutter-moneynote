import 'package:flutter/material.dart';
import 'package:moneynote/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

class UcSpendDisplayScreen extends StatefulWidget {
  final String date;
  final int sumprice;
  UcSpendDisplayScreen({@required this.date, @required this.sumprice});

  @override
  _UcSpendDisplayScreenState createState() => _UcSpendDisplayScreenState();
}

class _UcSpendDisplayScreenState extends State<UcSpendDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _ucCardSpendData = List();

  int _total = 0;

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
    ///////////////////////
    String url = "http://toyohide.work/BrainLog/api/uccardspend";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      _total = 0;
      for (var i = 0; i < data['data'].length; i++) {
        _ucCardSpendData.add(data['data'][i]);
        _total += int.parse(data['data'][i]['price']);
      }
    }
    ///////////////////////

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Uc Card [${_utility.year}-${_utility.month}]'),
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
          _spendDisplayBox(),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _spendDisplayBox() {
    int _diff = (widget.sumprice - _total);

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          padding: EdgeInsets.all(8),
          alignment: Alignment.topRight,
          width: double.infinity,
          color: Colors.orangeAccent.withOpacity(0.3),
          child: Text(
              '${_utility.makeCurrencyDisplay(_total.toString())} / ${_utility.makeCurrencyDisplay(widget.sumprice.toString())} / ${_utility.makeCurrencyDisplay(_diff.toString())}'),
        ),
        Expanded(
          child: _ucCardSpendList(),
        ),
      ],
    );
  }

  /**
   *
   */
  Widget _ucCardSpendList() {
    return ListView.builder(
      itemCount: _ucCardSpendData.length,
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
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_ucCardSpendData[position]['date']}'),
              Text('${_ucCardSpendData[position]['item']}'),
              Text(
                  '${_utility.makeCurrencyDisplay(_ucCardSpendData[position]['price'])}'),
            ],
          ),
        ),
      ),
    );
  }
}
