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

    List<dynamic> _value = List();
    _value.add(_utility.makeCurrencyDisplay(_total.toString()));
    _value.add(_utility.makeCurrencyDisplay(widget.sumprice.toString()));
    _value.add(_utility.makeCurrencyDisplay(_diff.toString()));

    List<dynamic> _value2 = List();
    _value2.add(_utility.makeCurrencyDisplay(_selectedTotal.toString()));
    _value2.add(_utility.makeCurrencyDisplay(_selectedDiff.toString()));

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.orangeAccent.withOpacity(0.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${_value2.join(' / ')}',
                style: TextStyle(color: Colors.greenAccent),
              ),
              Text('${_value.join(' / ')}'),
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
        onTap: () => _addSelectedAry(position: position),
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

  /**
   *
   */
  _addSelectedAry({position}) {
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
}
