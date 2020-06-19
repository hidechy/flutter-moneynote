import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utilities/utility.dart';
import '../main.dart';

import 'detail_display_screen.dart';
import 'oneday_input_screen.dart';

class MonthlyListScreen extends StatefulWidget {
  final String date;
  MonthlyListScreen({@required this.date});

  @override
  _MonthlyListScreenState createState() => _MonthlyListScreenState();
}

class _MonthlyListScreenState extends State<MonthlyListScreen> {
  Utility _utility = Utility();
  String year;
  String month;
  String day;
  String _month;
  String youbiStr;

  DateTime prevMonth;
  DateTime nextMonth;

  String _prevMonthEndDateTime;
  String _prevMonthEndDate;
  String _thisMonthEndDateTime;
  String _thisMonthEndDay;

  List<List<String>> _monthData = List();

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
    _utility.makeYMDYData(widget.date, 0);
    year = _utility.year;
    month = _utility.month;
    day = _utility.day;

    _month = year + "-" + month;

    youbiStr = _utility.youbiStr;

    prevMonth = new DateTime(int.parse(year), int.parse(month) - 1, 1);
    nextMonth = new DateTime(int.parse(year), int.parse(month) + 1, 1);

    //--------------------------------------//
    _utility.makeMonthEnd(int.parse(year), int.parse(month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate =
        _utility.year + "-" + _utility.month + "-" + _utility.day;

    _utility.makeMonthEnd(int.parse(year), int.parse(month) + 1, 0);
    _thisMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_thisMonthEndDateTime, 0);
    _thisMonthEndDay = _utility.day;

    ///////////////////////////
    var _prevMonthEndTotal = 0;
    var val = await database.selectRecord(_prevMonthEndDate);
    if (val.length > 0) {
      _utility.makeTotal(val);
      _prevMonthEndTotal = _utility.total;
    }
    ///////////////////////////

    var _yesterdaySpend = 0;
    _monthData = List();
    for (int i = 1; i <= int.parse(_thisMonthEndDay); i++) {
      var _thisDay = year + "-" + month + "-" + i.toString().padLeft(2, "0");

      var _thisDayTotal = 0;
      var _monieData = await database.selectRecord(_thisDay);

      if (_monieData.length > 0) {
        List<List<String>> _totalValue = List();
        _totalValue.add(['10000', _monieData[0].strYen10000]);
        _totalValue.add(['5000', _monieData[0].strYen5000]);
        _totalValue.add(['2000', _monieData[0].strYen2000]);
        _totalValue.add(['1000', _monieData[0].strYen1000]);
        _totalValue.add(['500', _monieData[0].strYen500]);
        _totalValue.add(['100', _monieData[0].strYen100]);
        _totalValue.add(['50', _monieData[0].strYen50]);
        _totalValue.add(['10', _monieData[0].strYen10]);
        _totalValue.add(['5', _monieData[0].strYen5]);
        _totalValue.add(['1', _monieData[0].strYen1]);

        _totalValue.add(['1', _monieData[0].strBankA]);
        _totalValue.add(['1', _monieData[0].strBankB]);
        _totalValue.add(['1', _monieData[0].strBankC]);
        _totalValue.add(['1', _monieData[0].strBankD]);

        _totalValue.add(['1', _monieData[0].strPayA]);
        _totalValue.add(['1', _monieData[0].strPayB]);

        for (int i = 0; i < _totalValue.length; i++) {
          _thisDayTotal +=
              (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
        }
      }

      var onedaySpend = (i == 1)
          ? (_prevMonthEndTotal - _thisDayTotal) * -1
          : (_yesterdaySpend - _thisDayTotal) * -1;

      _monthData
          .add([_thisDay, _thisDayTotal.toString(), onedaySpend.toString()]);
      _yesterdaySpend = _thisDayTotal;
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
        title: Text(
          _month,
          style: const TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goPrevMonth(context),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goNextMonth(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
          _monthlyList()
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  _monthlyList() {
    return ListView.builder(
      itemCount: _monthData.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem(int position) {
    return InkWell(
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: Card(
          color: getBgColor(position),
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
            onLongPress: () => _goOnedayInputScreen(position),
          ),
        ),
        //actions: <Widget>[],
        secondaryActions: <Widget>[
          IconSlideAction(
            color: getBgColor(position),
            foregroundColor: Colors.blueAccent,
            icon: Icons.details,
            onTap: () => _goDetailDisplayScreen(position),
          ),
          IconSlideAction(
            color: getBgColor(position),
            foregroundColor: Colors.blueAccent,
            icon: Icons.input,
            onTap: () => _goOnedayInputScreen(position),
          ),
        ],
      ),
    );
  }

  /**
   * 背景色取得
   */
  getBgColor(int position) {
    _utility.makeYMDYData(_monthData[position][0], 0);
    switch (_utility.youbiNo) {
      case 0:
        return Colors.redAccent[700].withOpacity(0.3);
        break;

      case 6:
        return Colors.blueAccent[700].withOpacity(0.3);
        break;

      default:
        return Colors.black.withOpacity(0.3);
        break;
    }
  }

  /**
   * データコンテナ表示
   */
  Widget _getDisplayContainer(int position, int column) {
    if (column == 0) {
      _utility.makeYMDYData(_monthData[position][0], 0);
      youbiStr = _utility.youbiStr;
    }

    return Container(
      alignment: (column == 1) ? Alignment.topCenter : Alignment.topLeft,
      child: (column == 0)
          ? Text(_monthData[position][column] + '（' + youbiStr + '）')
          : Text(_monthData[position][column]),
    );
  }

  /**
   * 画面遷移（前月）
   */
  _goPrevMonth(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: prevMonth.toString(),
        ),
      ),
    );
  }

  /**
   * 画面遷移（翌月）
   */
  _goNextMonth(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: nextMonth.toString(),
        ),
      ),
    );
  }

  /**
   * 画面遷移（OnedayInputScreen）
   */
  _goOnedayInputScreen(int position) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: _monthData[position][0],
        ),
      ),
    );
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen(int position) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: _monthData[position][0],
        ),
      ),
    );
  }
}
