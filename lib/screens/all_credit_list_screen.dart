import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';

import 'all_credit_item_list_screen.dart';
import 'amazon_purchase_list_screen.dart';
import 'seiyuu_purchase_list_screen.dart';

class AllCreditListScreen extends StatefulWidget {
  final String date;
  AllCreditListScreen({@required this.date});

  @override
  _AllCreditListScreenState createState() => _AllCreditListScreenState();
}

class _AllCreditListScreenState extends State<AllCreditListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _creditCardSpendData = List();

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

    maxNo = _creditCardSpendData.length;

    setState(() {});
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
          _utility.getBackGround(context: context),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.withOpacity(0.3),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.list),
                                onPressed: () => _goAllCreditItemListScreen(),
                                color: Colors.greenAccent,
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_downward),
                                color: Colors.greenAccent,
                                onPressed: () => _scroll(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(FontAwesomeIcons.amazon),
                                color: Colors.greenAccent,
                                onPressed: () => _goAmazonPurchaseListScreen(),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.bullseye),
                                color: Colors.greenAccent,
                                onPressed: () => _goSeiyuuPurchaseListScreen(),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Expanded(
                  child: _creditCardSpendList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  void _scroll() {
    _itemScrollController.scrollTo(
      index: maxNo,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  /**
   *
   */
  Widget _creditCardSpendList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
      },
      itemCount: _creditCardSpendData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var ex_pm = (_creditCardSpendData[position]['pay_month']).split('-');

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
            color: _getLeadingBgColor(month: ex_pm[1]),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${ex_pm[0]}'),
              Text('${ex_pm[1]}'),
            ],
          ),
        ),
        trailing:
            _getCreditTrailing(kind: _creditCardSpendData[position]['kind']),
        title: Row(
          children: <Widget>[
            Expanded(
              child: DefaultTextStyle(
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
            Container(
              width: 20,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${_creditCardSpendData[position]['month_diff']}',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
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
  void _goAllCreditItemListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditItemListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  /**
   *
   */
  void _goAmazonPurchaseListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmazonPurchaseListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  /**
   *
   */
  void _goSeiyuuPurchaseListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeiyuuPurchaseListScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
