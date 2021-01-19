import 'package:flutter/material.dart';
import 'package:moneynote/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'all_credit_list_screen.dart';

class CreditSpendDisplayScreen extends StatefulWidget {
  final String date;
  final int sumprice;
  CreditSpendDisplayScreen({@required this.date, @required this.sumprice});

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

    _selectedDiff = _total;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

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
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.3),
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
                            '${_utility.makeCurrencyDisplay(widget.sumprice.toString())}'),
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
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => _goAllCreditListScreen(),
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
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
}
