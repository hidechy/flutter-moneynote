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

  List<List<String>> _alldayData = List();

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
  _makeDefaultDisplayData() async {
    //全データ取得
    var _monieData = await database.selectSortedAllRecord;
    if (_monieData.length > 0) {
      int _keepTotal = 0;
      int total = 0;
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeTotal(_monieData[i]);
        total = _utility.total;

        _alldayData.add([
          _monieData[i].strDate,
          total.toString(),
          ((_keepTotal - total) * -1).toString()
        ]);

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
  _alldayList() {
    return ListView.builder(
      itemCount: _alldayData.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  /**
   * リストアイテム表示
   */
  _listItem(int position) {
    return InkWell(
      child: Card(
        color: getBgColor(_alldayData[position][0]),
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
                  _getDisplayContainer(position, 0),
                  _getDisplayContainer(position, 1),
                  _getDisplayContainer(position, 2),
                ]),
              ],
            ),
          ),
        ),
      ),
      //actions: <Widget>[],
    );
  }

  /**
   * 背景色取得
   */
  getBgColor(String date) {
    _utility.makeYMDYData(date, 0);

    Color _color = null;

    switch (_utility.youbiNo) {
      case 0:
        _color = Colors.redAccent[700].withOpacity(0.3);
        break;

      case 6:
        _color = Colors.blueAccent[700].withOpacity(0.3);
        break;

      default:
        _color = Colors.black.withOpacity(0.3);
        break;
    }

    if (_holidayList[date] != null) {
      _color = Colors.greenAccent[700].withOpacity(0.3);
    }

    return _color;
  }

  /**
   * データコンテナ表示
   */
  Widget _getDisplayContainer(int position, int column) {
    return Container(
      alignment: (column == 1) ? Alignment.topCenter : Alignment.topLeft,
      child: Text(getDisplayText(_alldayData[position][column], column)),
    );
  }

  /**
   * 表示テキスト取得
   */
  String getDisplayText(String text, int column) {
    switch (column) {
      case 0:
        _utility.makeYMDYData(text, 0);
        return '${text}（${_utility.youbiStr}）';
        break;
      case 1:
      case 2:
        return _utility.makeCurrencyDisplay(text);
        break;
    }
  }
}
