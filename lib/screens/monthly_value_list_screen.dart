import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../main.dart';

class MonthlyValueListScreen extends StatefulWidget {
  final String date;
  MonthlyValueListScreen({@required this.date});

  @override
  _MonthlyValueListScreenState createState() => _MonthlyValueListScreenState();
}

class _MonthlyValueListScreenState extends State<MonthlyValueListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _monthlyValueData = List();

  String year;
  String month;

  String _month;

  Map<String, dynamic> _holidayList = Map();

  DateTime prevMonth;
  DateTime nextMonth;

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
    year = _utility.year;
    month = _utility.month;

    _month = '${year}-${month}';

    //全データ取得
    var _monieData = await database.selectSortedAllRecord;

    if (_monieData.length > 0) {
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeYMDYData(_monieData[i].strDate, 0);

        if ('${year}-${month}' == '${_utility.year}-${_utility.month}') {
          var _map = Map();
          _map["date"] = _utility.day;

          _map["strYen10000"] = _monieData[i].strYen10000;
          _map["strYen5000"] = _monieData[i].strYen5000;
          _map["strYen2000"] = _monieData[i].strYen2000;
          _map["strYen1000"] = _monieData[i].strYen1000;
          _map["strYen500"] = _monieData[i].strYen500;
          _map["strYen100"] = _monieData[i].strYen100;
          _map["strYen50"] = _monieData[i].strYen50;
          _map["strYen10"] = _monieData[i].strYen10;
          _map["strYen5"] = _monieData[i].strYen5;
          _map["strYen1"] = _monieData[i].strYen1;

          _map["strBankA"] = _monieData[i].strBankA;
          _map["strBankB"] = _monieData[i].strBankB;
          _map["strBankC"] = _monieData[i].strBankC;
          _map["strBankD"] = _monieData[i].strBankD;
          _map["strBankE"] = _monieData[i].strBankE;
          _map["strBankF"] = _monieData[i].strBankF;
          _map["strBankG"] = _monieData[i].strBankG;
          _map["strBankH"] = _monieData[i].strBankH;

          _map["strPayA"] = _monieData[i].strPayA;
          _map["strPayB"] = _monieData[i].strPayB;
          _map["strPayC"] = _monieData[i].strPayC;
          _map["strPayD"] = _monieData[i].strPayD;
          _map["strPayE"] = _monieData[i].strPayE;
          _map["strPayF"] = _monieData[i].strPayF;
          _map["strPayG"] = _monieData[i].strPayG;
          _map["strPayH"] = _monieData[i].strPayH;

          _monthlyValueData.add(_map);
        }
      }
    }

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    prevMonth = new DateTime(int.parse(year), int.parse(month) - 1, 1);
    nextMonth = new DateTime(int.parse(year), int.parse(month) + 1, 1);

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${_month}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goMonthlyValueListScreen(
                context: context, date: prevMonth.toString()),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goMonthlyValueListScreen(
                context: context, date: nextMonth.toString()),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          _monthlyValueList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _monthlyValueList() {
    return ListView.builder(
      itemCount: _monthlyValueData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: getBgColor('${_month}-${_monthlyValueData[position]['date']}'),
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
                Text(
                  '${_monthlyValueData[position]['date']}',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_monthlyValueData[position]['strYen10000']}',
                  style: TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  '${_monthlyValueData[position]['strYen5000']}',
                  style: TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  '${_monthlyValueData[position]['strYen2000']}',
                  style: TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  '${_monthlyValueData[position]['strYen1000']}',
                  style: TextStyle(color: Colors.greenAccent),
                ),
                Text('${_monthlyValueData[position]['strYen500']}'),
                Text('${_monthlyValueData[position]['strYen100']}'),
                Text('${_monthlyValueData[position]['strYen50']}'),
                Text(
                  '${_monthlyValueData[position]['strYen10']}',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                Text(
                  '${_monthlyValueData[position]['strYen5']}',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                Text(
                  '${_monthlyValueData[position]['strYen1']}',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ]),
            ],
          ),
        ),
      ),
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

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（MonthlyValueListScreen）
   */
  void _goMonthlyValueListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyValueListScreen(date: date),
      ),
    );
  }
}
