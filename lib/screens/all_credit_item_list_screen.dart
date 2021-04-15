import 'package:flutter/material.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';

import 'all_credit_list_screen.dart';
import 'seiyuu_purchase_list_screen.dart';
import 'amazon_purchase_list_screen.dart';

class AllCreditItemListScreen extends StatefulWidget {
  final String date;
  AllCreditItemListScreen({@required this.date});

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                                onPressed: () => _goAllCreditListScreen(),
                                color: Colors.greenAccent,
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
                  child: _creditCardItemList(),
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
  Widget _creditCardItemList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
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
    var ex_pm = (_creditCardItemData[position]['pay_month']).split('-');

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
            _getCreditTrailing(kind: _creditCardItemData[position]['kind']),
        title: Row(
          children: <Widget>[
            Expanded(
              child: DefaultTextStyle(
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
                '${_creditCardItemData[position]['month_diff']}',
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
  void _goAllCreditListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditListScreen(
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
