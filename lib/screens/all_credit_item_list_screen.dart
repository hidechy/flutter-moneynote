import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'all_credit_list_screen.dart';

class AllCreditItemListScreen extends StatefulWidget {
  @override
  _AllCreditItemListScreenState createState() =>
      _AllCreditItemListScreenState();
}

class _AllCreditItemListScreenState extends State<AllCreditItemListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _creditCardItemData = List();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int maxNo = 0;

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
    String url = "http://toyohide.work/BrainLog/api/carditemlist";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _creditCardItemData.add(data['data'][i]);
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
        title: Text('All Credit（種別順）'),
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
                  onPressed: () => _goAllCreditListScreen(),
                  color: Colors.greenAccent,
                ),
              ),
              Expanded(
                child: _creditCardItemList(),
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
  Widget _creditCardItemList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return ListTile(title: _listItem(position: index));
      },
      itemCount: _creditCardItemData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var ex_date = (_creditCardItemData[position]['date']).split('-');

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
            color: Colors.orangeAccent.withOpacity(0.3),
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
        trailing:
            _getCreditTrailing(kind: _creditCardItemData[position]['kind']),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_creditCardItemData[position]['date']}'),
              Text('${_creditCardItemData[position]['item']}'),
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(_creditCardItemData[position]['price'])}'),
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
  void _goAllCreditListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditListScreen(),
      ),
    );
  }
}
