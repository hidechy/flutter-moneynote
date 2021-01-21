import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moneynote/screens/graph_display_screen.dart';

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

  String _year = '';
  String _month = '';
  String _yearmonth = '';

  DateTime _prevMonth = DateTime.now();
  DateTime _nextMonth = DateTime.now();

  String _prevMonthEndDateTime = '';
  String _prevMonthEndDate = '';
  String _thisMonthEndDateTime = '';
  String _thisMonthEndDay = '';

  List<Map<dynamic, dynamic>> _monthData = List();

  Map<String, dynamic> _holidayList = Map();

  int _monthTotal = 0;

  int _prevMonthEndTotal = 0;

  List<Map<dynamic, dynamic>> _graphData = List();

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
    _year = _utility.year;
    _month = _utility.month;

    _yearmonth = '${_year}-${_month}';

    _prevMonth = new DateTime(int.parse(_year), int.parse(_month) - 1, 1);
    _nextMonth = new DateTime(int.parse(_year), int.parse(_month) + 1, 1);

    //--------------------------------------//
    _utility.makeMonthEnd(int.parse(_year), int.parse(_month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    _utility.makeMonthEnd(int.parse(_year), int.parse(_month) + 1, 0);
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
      var _thisDay = '${_year}-${_month}-${i.toString().padLeft(2, '0')}';

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
      var _depoRec = await database.selectDepositDateRecord(_thisDay);
      if (_depoRec.length > 0) {
        _flag = '1';
      }
      var _beneRec = await database.selectBenefitRecord(_thisDay);
      if (_beneRec.length > 0) {
        _flag = '2';
      }

      if (_thisDayTotal > 0) {
        _monthSum += onedaySpend;
      }

      var _map = Map();
      _map['date'] = _thisDay;
      _map['total'] = _thisDayTotal.toString();
      _map['spend'] = onedaySpend.toString();
      _map['flag'] = _flag;

      _monthData.add(_map);

      _yesterdaySpend = _thisDayTotal;

      //////////////////////////////////////
      var _map2 = Map();
      _map2['date'] = _thisDay;
      _map2['total'] = _thisDayTotal.toString();
      _graphData.add(_map2);
      //////////////////////////////////////

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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('${_yearmonth}'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    tooltip: '前日',
                    onPressed: () => _goMonthlyListScreen(
                        context: context, date: _prevMonth.toString()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    tooltip: '翌日',
                    onPressed: () => _goMonthlyListScreen(
                        context: context, date: _nextMonth.toString()),
                  ),
                ],
                backgroundColor: Colors.black.withOpacity(0.1),
                pinned: true,
                expandedHeight: 100.0,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _totalContainer(),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, position) => _listItem(position: position),
                  childCount: _monthData.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _totalContainer() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      'start　${_utility.makeCurrencyDisplay(_prevMonthEndTotal.toString())}'),
                  Text(
                      'total　${_utility.makeCurrencyDisplay(_monthTotal.toString())}'),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 60,
          margin: EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => _goGraphDisplayScreen(),
              child: Icon(Icons.show_chart),
            ),
          ),
        ),
      ],
    );
  }

  /**
   * リスト表示
   */
  Widget _monthlyList() {
    return ListView.builder(
      itemCount: _monthData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: Card(
        color: _utility.getBgColor(_monthData[position]['date'], _holidayList),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: _getLeading(mark: _monthData[position]['flag']),
          title: DefaultTextStyle(
            style: TextStyle(fontSize: 10.0),
            child: Table(
              children: [
                TableRow(children: [
                  _getDisplayContainer(position: position, column: 'date'),
                  _getDisplayContainer(position: position, column: 'total'),
                  _getDisplayContainer(position: position, column: 'spend'),
                ]),
              ],
            ),
          ),
          onLongPress: () => _goOnedayInputScreen(
              context: context, date: _monthData[position]['date']),
        ),
      ),
      //actions: <Widget>[],
      secondaryActions: <Widget>[
        _getDetailDialogButton(position: position),
        IconSlideAction(
          color:
              _utility.getBgColor(_monthData[position]['date'], _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.details,
          onTap: () => _goDetailDisplayScreen(
              context: context, date: _monthData[position]['date']),
        ),
        IconSlideAction(
          color:
              _utility.getBgColor(_monthData[position]['date'], _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.input,
          onTap: () => _goOnedayInputScreen(
              context: context, date: _monthData[position]['date']),
        ),
      ],
    );
  }

  /**
   * ダイアログボタン表示
   */
  Widget _getDetailDialogButton({int position}) {
    var date = _monthData[position]['date'];
    switch (_monthData[position]['flag']) {
      case '1':
        return IconSlideAction(
          color: _utility.getBgColor(date, _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.business,
          onTap: () => _displayDialog(position: position),
        );
        break;

      case '2':
        return IconSlideAction(
          color: _utility.getBgColor(date, _holidayList),
          foregroundColor: Colors.orangeAccent,
          icon: Icons.beenhere,
          onTap: () => _displayDialog(position: position),
        );
        break;

      default:
        return IconSlideAction(
          color: _utility.getBgColor(date, _holidayList),
          foregroundColor: Color(0xFF2e2e2e),
          icon: Icons.check_box_outline_blank,
        );
        break;
    }
  }

  /**
   * ダイアログ表示
   */
  void _displayDialog({int position}) async {
    String _title = '';
    int _onedaySpend = 0;
    int _bankPrice = 0;

    //----------------//
    String _depositStr = '';
    var value =
        await database.selectDepositDateRecord(_monthData[position]['date']);
    if (value.length > 0) {
      List<String> _depo = List();
      for (var i = 0; i < value.length; i++) {
        _title = value[i].strDate;

        _depo.add("□${value[i].strItem}");
        _depo.add("${value[i].strBank}　${value[i].strPrice}");

        _bankPrice += int.parse(value[i].strPrice);
      }
      _depositStr = _depo.join('\n');
    }
    //----------------//

    //----------------//
    String _benefitStr = '';
    var value2 =
        await database.selectBenefitRecord(_monthData[position]['date']);
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
      _onedaySpend =
          (int.parse(_monthData[position]['spend']) * -1) - _bankPrice;
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
            (_depositStr == '')
                ? Container()
                : Text(
                    _depositStr,
                    style: TextStyle(
                      fontFamily: 'Loboto',
                      fontSize: 12.0,
                    ),
                  ),
            (_depositStr == '')
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
                (int.parse(_monthData[position]['spend']) * -1).toString(),
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
  Widget _getLeading({String mark}) {
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
   * データコンテナ表示
   */
  Widget _getDisplayContainer({int position, String column}) {
    return Container(
      alignment: _getDisplayAlign(column: column),
      child:
          _getDisplayText(column: column, text: _monthData[position][column]),
    );
  }

  /**
   * データ表示位置取得
   */
  Alignment _getDisplayAlign({String column}) {
    switch (column) {
      case 'date':
        return Alignment.topLeft;
        break;
      case 'total':
        return Alignment.topRight;
        break;
      case 'spend':
        return Alignment.topRight;
        break;
    }
  }

  /**
   * 表示文言取得
   */
  Widget _getDisplayText({String column, String text}) {
    switch (column) {
      case 'date':
        _utility.makeYMDYData(text, 0);

        return Text(
          text + '(${_utility.youbiStr})',
          style: TextStyle(fontSize: 10),
        );
        break;
      case 'total':
      case 'spend':
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
  void _goMonthlyListScreen({BuildContext context, String date}) {
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
  void _goOnedayInputScreen({BuildContext context, String date}) {
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
  void _goDetailDisplayScreen({BuildContext context, String date}) async {
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

  /**
   *
   */
  Widget _goGraphDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraphDisplayScreen(
          date: widget.date,
          graphdata: _graphData,
        ),
      ),
    );
  }
}
