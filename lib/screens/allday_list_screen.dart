import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import '../main.dart';

class AlldayListScreen extends StatefulWidget {
  final String date;
  AlldayListScreen({@required this.date});

  @override
  _AlldayListScreenState createState() => _AlldayListScreenState();
}

class _AlldayListScreenState extends State<AlldayListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _alldayData = List();

  Map<String, dynamic> _holidayList = Map();

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
    //全データ取得
    var _monieData = await database.selectSortedAllRecord;
    if (_monieData.length > 0) {
      int _keepTotal = 0;
      int total = 0;
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeTotal(_monieData[i]);
        total = _utility.total;

        var _map = Map();
        _map['date'] = _monieData[i].strDate;
        _map['total'] = total.toString();
        _map['diff'] = ((_keepTotal - total) * -1).toString();

        _alldayData.add(_map);

        _keepTotal = total;
      }
    }

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Day List'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          _alldayList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _alldayList() {
    return ListView.builder(
      itemCount: _alldayData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: _utility.getListBgColor(_alldayData[position]['date']),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Table(
            children: [
              TableRow(children: [
                _getDisplayContainer(position: position, column: 'date'),
                _getDisplayContainer(position: position, column: 'total'),
                _getDisplayContainer(position: position, column: 'diff'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * データコンテナ表示
   */
  Widget _getDisplayContainer({int position, String column}) {
    return Container(
      alignment: (column == 'total') ? Alignment.topCenter : Alignment.topLeft,
      child: Text(
        _getDisplayText(
          text: _alldayData[position][column],
          column: column,
        ),
      ),
    );
  }

  /**
   * 表示テキスト取得
   */
  String _getDisplayText({String text, String column}) {
    switch (column) {
      case 'date':
        _utility.makeYMDYData(text, 0);
        return '${text}（${_utility.youbiStr}）';
        break;
      case 'total':
      case 'diff':
        return _utility.makeCurrencyDisplay(text);
        break;
    }
  }
}
