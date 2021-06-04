import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';

import 'dart:convert';

import '../utilities/utility.dart';

class FoodExpensesDisplayScreen extends StatefulWidget {
  final String year;
  final String month;
  FoodExpensesDisplayScreen({
    @required this.year,
    @required this.month,
  });

  @override
  _FoodExpensesDisplayScreenState createState() =>
      _FoodExpensesDisplayScreenState();
}

class _FoodExpensesDisplayScreenState extends State<FoodExpensesDisplayScreen> {
  Utility _utility = Utility();

  int _foodExpenses = 0;
  int _seiyuPurchase = 0;

  int _monthEndDay = 0;

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
    DateTime _today = DateTime.now();
    _utility.makeYMDYData(_today.toString(), 0);

    print(_utility.year);
    print(_utility.month);

    var __year = null;
    var __month = null;
    if (_utility.year == widget.year && _utility.month == widget.month) {
      _monthEndDay = int.parse(_utility.day);
    } else {
      _utility.makeMonthEnd(
          int.parse(widget.year), int.parse(widget.month) + 1, 0);
      _utility.makeYMDYData(_utility.monthEndDateTime, 0);
      _monthEndDay = int.parse(_utility.day);
    }

    ////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/monthsummary";
    Map<String, String> headers = {'content-type': 'application/json'};
    String date = "${widget.year}-${widget.month}-01";
    String body = json.encode({"date": date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (int i = 0; i < data['data'].length; i++) {
        if (data['data'][i]['item'] == "食費") {
          _foodExpenses = data['data'][i]['sum'];
          break;
        }
      }
    }
    ////////////////////////////////////////

    //----------------------------
    String url2 = "http://toyohide.work/BrainLog/api/seiyuuPurchaseList";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    String body2 = json.encode({"date": '${widget.year}-${widget.month}-01'});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      Map data2 = jsonDecode(response2.body);

      for (int i = 0; i < data2['data'].length; i++) {
        var ex_date = (data2['data'][i]['date']).split('-');
        if (ex_date[0] == widget.year && ex_date[1] == widget.month) {
          _seiyuPurchase += int.parse(data2['data'][i]['price']);
        }
      }
    }
    //----------------------------

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var sum = (_foodExpenses + _seiyuPurchase);
    var ave = (sum / _monthEndDay).floor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Food Expenses'),
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
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                child: Text('${widget.year}-${widget.month}'),
              ),
              Divider(color: Colors.indigo, indent: 10.0, endIndent: 10.0),
              Container(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: Table(
                  children: [
                    TableRow(children: [
                      Text('食費'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_foodExpenses.toString())}'),
                      ),
                    ]),
                    TableRow(children: [
                      Text('西友購入'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_seiyuPurchase.toString())}'),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text('計'),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(sum.toString())}'),
                      ),
                    ]),
                  ],
                ),
              ),
              Divider(color: Colors.indigo, indent: 10.0, endIndent: 10.0),
              Container(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text('平均（${_monthEndDay}日間）'),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(ave.toString())}'),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
