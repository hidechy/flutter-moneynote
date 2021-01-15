import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'all_credit_item_list_screen.dart';

class AllCreditListScreen extends StatefulWidget {
  @override
  _AllCreditListScreenState createState() => _AllCreditListScreenState();
}

class _AllCreditListScreenState extends State<AllCreditListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _creditCardSpendData = List();

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
    String url = "http://toyohide.work/BrainLog/api/allcardspend";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _creditCardSpendData.add(data['data'][i]);
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('All Credit（日付順）'),
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
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.3),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () => _goAllCreditItemListScreen(),
                  color: Colors.greenAccent,
                ),
              ),
              Expanded(
                child: _creditCardSpendList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _creditCardSpendList() {
    return ListView.builder(
      itemCount: _creditCardSpendData.length,
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
        trailing:
            _getCreditTrailing(kind: _creditCardSpendData[position]['kind']),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_creditCardSpendData[position]['date']}'),
              Text('${_creditCardSpendData[position]['item']}'),
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(_creditCardSpendData[position]['price'])}'),
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
  Widget _getCreditTrailing({kind}) {
    switch (kind) {
      case 'uc':
        return Icon(
          Icons.grade,
          color: Colors.purpleAccent.withOpacity(0.3),
        );
        break;
      case 'rakuten':
        return Icon(
          Icons.grade,
          color: Colors.deepOrangeAccent.withOpacity(0.3),
        );
        break;
      case 'sumitomo':
        return Icon(
          Icons.grade,
          color: Colors.greenAccent.withOpacity(0.3),
        );
        break;
    }
  }

  /**
   *
   */
  _goAllCreditItemListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditItemListScreen(),
      ),
    );
  }
}
