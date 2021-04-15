import 'package:flutter/material.dart';
import 'package:moneynote/screens/credit_monthly_list_screen.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';
import 'package:moneynote/utilities/utility.dart';
import 'package:http/http.dart';

import 'dart:convert';

import 'all_credit_list_screen.dart';

class CreditSpendDisplayScreen extends StatefulWidget {
  final String date;
  CreditSpendDisplayScreen({@required this.date});

  @override
  _CreditSpendDisplayScreenState createState() =>
      _CreditSpendDisplayScreenState();
}

class _CreditSpendDisplayScreenState extends State<CreditSpendDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _ucCardSpendData = List();

  int _total = 0;

  List<int> _selectedList = List();
  int _selectedTotal = 0;
  int _selectedDiff = 0;

  DateTime _prevDate = DateTime.now();
  DateTime _nextDate = DateTime.now();

  int _sumprice = 0;

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

    _prevDate = new DateTime(
        int.parse(_utility.year), int.parse(_utility.month) - 1, 1);
    _nextDate = new DateTime(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 1);

    //--------------------------------//
    String url2 = "http://toyohide.work/BrainLog/api/monthsummary";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    var date2 = '${_utility.year}-${_utility.month}-${_utility.day}';
    String body2 = json.encode({"date": date2});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      Map data2 = jsonDecode(response2.body);

      for (var i = 0; i < data2['data'].length; i++) {
        if (data2['data'][i]['item'] == 'credit') {
          _sumprice = data2['data'][i]['sum'];
        }
      }
    }
    //--------------------------------//

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

    _selectedDiff = _total;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Credit Card [${_utility.year}-${_utility.month}]'),
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
          _spendDisplayBox(),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _spendDisplayBox() {
    int _diff = (_sumprice - _total);

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellowAccent.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Table(
                  children: [
                    TableRow(children: [
                      Text('list total'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_total.toString())}'),
                      ),
                    ]),
                    TableRow(children: [
                      Text('sumprice'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_sumprice.toString())}'),
                      ),
                    ]),
                    TableRow(children: [
                      Text('diff'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_diff.toString())}'),
                      ),
                    ]),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Table(
                  children: [
                    TableRow(children: [
                      Text('select total'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_selectedTotal.toString())}'),
                      ),
                    ]),
                    TableRow(children: [
                      Text('select diff'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                            '${_utility.makeCurrencyDisplay(_selectedDiff.toString())}'),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      tooltip: '前月',
                      onPressed: () => _goPrevMonth(context: context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      tooltip: '翌月',
                      onPressed: () => _goNextMonth(context: context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => _goAllCreditListScreen(),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.3),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text('All Credit'),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => _goMonthlyCreditListScreen(),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.3),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text('Monthly List'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      color: _getSelectedBgColor(position: position),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        trailing: _getCreditTrailing(kind: _ucCardSpendData[position]['kind']),
        onTap: () => _addSelectedAry(position: position),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_ucCardSpendData[position]['date']}'),
              Text('${_ucCardSpendData[position]['item']}'),
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(_ucCardSpendData[position]['price'])}'),
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
  void _addSelectedAry({position}) {
    if (_selectedList.contains(position)) {
      _selectedList.remove(position);
      _selectedTotal -= int.parse(_ucCardSpendData[position]['price']);
    } else {
      _selectedList.add(position);
      _selectedTotal += int.parse(_ucCardSpendData[position]['price']);
    }

    _selectedDiff = (_total - _selectedTotal);

    setState(() {});
  }

  /**
   *
   */
  Color _getSelectedBgColor({position}) {
    if (_selectedList.contains(position)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.3);
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
    Navigator.push(
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
  void _goMonthlyCreditListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditMonthlyListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（前月）
   */
  void _goPrevMonth({BuildContext context}) {
    _utility.makeYMDYData(_prevDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditSpendDisplayScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }

  /**
   * 画面遷移（翌月）
   */
  void _goNextMonth({BuildContext context}) {
    _utility.makeYMDYData(_nextDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditSpendDisplayScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }
}
