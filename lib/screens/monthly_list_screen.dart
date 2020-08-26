import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

import '../utilities/utility.dart';

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

  Map<String, dynamic> _holidayList = Map();

  int _monthTotal = 0;

  int _prevMonthEndTotal = 0;

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

    _month = '${year}-${month}';

    youbiStr = _utility.youbiStr;

    prevMonth = new DateTime(int.parse(year), int.parse(month) - 1, 1);
    nextMonth = new DateTime(int.parse(year), int.parse(month) + 1, 1);

    //--------------------------------------//
    _utility.makeMonthEnd(int.parse(year), int.parse(month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    _utility.makeMonthEnd(int.parse(year), int.parse(month) + 1, 0);
    _thisMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_thisMonthEndDateTime, 0);
    _thisMonthEndDay = _utility.day;

    ///////////////////////////
    var val = await database.selectRecord(_prevMonthEndDate);
    if (val.length > 0) {
      _utility.makeTotal(val[0]);
      _prevMonthEndTotal = _utility.total;
    }
    ///////////////////////////
    int _monthSum = 0;
    var _yesterdaySpend = 0;
    _monthData = List();
    for (int i = 1; i <= int.parse(_thisMonthEndDay); i++) {
      var _thisDay = '${year}-${month}-${i.toString().padLeft(2, '0')}';

      var _thisDayTotal = 0;
      var _monieData = await database.selectRecord(_thisDay);

      if (_monieData.length > 0) {
        _utility.makeTotal(_monieData[0]);
        _thisDayTotal = _utility.total;
      }

      var onedaySpend = (i == 1)
          ? (_prevMonthEndTotal - _thisDayTotal) * -1
          : (_yesterdaySpend - _thisDayTotal) * -1;

      var _flag = '0';
      var _creRec = await database.selectCreditDateRecord(_thisDay);
      if (_creRec.length > 0) {
        _flag = '1';
      }
      var _beneRec = await database.selectBenefitRecord(_thisDay);
      if (_beneRec.length > 0) {
        _flag = '2';
      }

      if (_thisDayTotal > 0) {
        _monthSum += onedaySpend;
      }

      _monthData.add(
          [_thisDay, _thisDayTotal.toString(), onedaySpend.toString(), _flag]);

      _yesterdaySpend = _thisDayTotal;
    }

    _monthTotal = _monthSum;

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
        title: Text(_month),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () =>
                _goMonthlyListScreen(context, prevMonth.toString()),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () =>
                _goMonthlyListScreen(context, nextMonth.toString()),
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Column(
            children: <Widget>[
              Container(
                color: Colors.yellow,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'start　${_utility.makeCurrencyDisplay(_prevMonthEndTotal.toString())}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'total　${_monthTotal}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _monthlyList(),
              ),
            ],
          ),
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
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: Card(
        color: getBgColor(_monthData[position][0]),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          child: ListTile(
            leading: _getLeading(_monthData[position][3]),
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
            onLongPress: () => _goOnedayInputScreen(
              context,
              _monthData[position][0],
            ),
          ),
        ),
      ),
      //actions: <Widget>[],
      secondaryActions: <Widget>[
        _getDetailDialogButton(position),
        IconSlideAction(
          color: getBgColor(_monthData[position][0]),
          foregroundColor: Colors.blueAccent,
          icon: Icons.details,
          onTap: () => _goDetailDisplayScreen(
            context,
            _monthData[position][0],
          ),
        ),
        IconSlideAction(
          color: getBgColor(_monthData[position][0]),
          foregroundColor: Colors.blueAccent,
          icon: Icons.input,
          onTap: () => _goOnedayInputScreen(
            context,
            _monthData[position][0],
          ),
        ),
      ],
    );
  }

  /**
   * ダイアログボタン表示
   */
  _getDetailDialogButton(int position) {
    var date = _monthData[position][0];
    switch (_monthData[position][3]) {
      case '1':
        return IconSlideAction(
          color: getBgColor(date),
          foregroundColor: Colors.blueAccent,
          icon: Icons.business,
          onTap: () => _displayDialog(position),
        );
        break;

      case '2':
        return IconSlideAction(
          color: getBgColor(date),
          foregroundColor: Colors.orangeAccent,
          icon: Icons.beenhere,
          onTap: () => _displayDialog(position),
        );
        break;

      default:
        return IconSlideAction(
          color: getBgColor(date),
          foregroundColor: Color(0xFF2e2e2e),
          icon: Icons.check_box_outline_blank,
        );
        break;
    }
  }

  /**
   * ダイアログ表示
   */
  _displayDialog(int position) async {
    String _title = '';
    int _onedaySpend = 0;
    int _bankPrice = 0;

    //----------------//
    String _creditStr = '';
    var value = await database.selectCreditDateRecord(_monthData[position][0]);
    if (value.length > 0) {
      List<String> _cre = List();
      for (var i = 0; i < value.length; i++) {
        _title = value[i].strDate;

        _cre.add("□${value[i].strItem}");
        _cre.add("${value[i].strBank}　${value[i].strPrice}");

        _bankPrice += int.parse(value[i].strPrice);
      }
      _creditStr = _cre.join('\n');
    }
    //----------------//

    //----------------//
    String _benefitStr = '';
    var value2 = await database.selectBenefitRecord(_monthData[position][0]);
    if (value2.length > 0) {
      List<String> _bene = List();
      for (var i = 0; i < value2.length; i++) {
        if (_title == '') {
          _title = value2[0].strDate;
        }
//
        _bene.add("${value2[i].strCompany}　${value2[i].strPrice}");
//
        _bankPrice += int.parse(value2[i].strPrice) * -1;
      }
      _benefitStr = _bene.join('\n');
    }
    //----------------//

    if (_bankPrice != 0) {
      _onedaySpend = (int.parse(_monthData[position][2]) * -1) - _bankPrice;
      if (value2.length > 0) {
        _onedaySpend *= -1;
      }
    }

    _utility.makeYMDYData(_title, 0);
    _title += "（${_utility.youbiStr}）";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.3),
        title: Text(
          _title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Loboto',
            fontSize: 14,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (_creditStr == '')
                ? Container()
                : Text(
                    _creditStr,
                    style: TextStyle(
                      fontFamily: 'Loboto',
                      fontSize: 12.0,
                    ),
                  ),
            (_creditStr == '')
                ? Container()
                : Divider(
                    color: Colors.indigo,
                    height: 20.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
            (_benefitStr == '')
                ? Container()
                : Text(
                    _benefitStr,
                    style: TextStyle(
                      fontFamily: 'Loboto',
                      fontSize: 12.0,
                    ),
                  ),
            (_benefitStr == '')
                ? Container()
                : Divider(
                    color: Colors.indigo,
                    height: 20.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
            Text(
              'Oneday Spend：${_onedaySpend.toString()}',
              style: TextStyle(
                fontFamily: 'Loboto',
                fontSize: 12.0,
              ),
            ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                (int.parse(_monthData[position][2]) * -1).toString(),
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '閉じる',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /**
   * リーディングマーク取得
   */
  Widget _getLeading(String mark) {
    switch (mark) {
      case '1':
        return const Icon(
          Icons.business,
          color: Colors.blueAccent,
        );
        break;

      case '2':
        return const Icon(
          Icons.beenhere,
          color: Colors.orangeAccent,
        );
        break;

      default:
        return const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        );
        break;
    }
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
      alignment: _getDisplayAlign(column),
      child: getDisplayText(column, _monthData[position][column]),
    );
  }

  /**
   * データ表示位置取得
   */
  _getDisplayAlign(int column) {
    switch (column) {
      case 0:
        return Alignment.topLeft;
        break;
      case 1:
        return Alignment.topRight;
        break;
      case 2:
        return Alignment.topRight;
        break;
    }
  }

  /**
   * 表示文言取得
   */
  Widget getDisplayText(int column, String text) {
    switch (column) {
      case 0:
        _utility.makeYMDYData(text, 0);

        return Text(
          text + '(${_utility.youbiStr})',
          style: TextStyle(fontSize: 10),
        );
        break;
      case 1:
      case 2:
        return Text(
          _utility.makeCurrencyDisplay(text),
          style: TextStyle(fontSize: 10),
        );
        break;
    }
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（MonthlyListScreen）
   */
  _goMonthlyListScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（OnedayInputScreen）
   */
  _goOnedayInputScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen(BuildContext context, String date) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);
    _utility.makeYMDYData(date, 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: int.parse(_utility.day),
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }
}
