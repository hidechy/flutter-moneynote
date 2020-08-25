import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:moneynote/screens/setting_base_screen.dart';

import '../main.dart';

import '../utilities/utility.dart';
import '../db/database.dart';

import 'bank_input_screen.dart';
import 'bank_record_input_screen.dart';
import 'monthly_list_screen.dart';
import 'oneday_input_screen.dart';
import 'score_list_screen.dart';
import 'benefit_input_screen.dart';
import 'sameday_list_screen.dart';
import 'allday_list_screen.dart';

class DetailDisplayScreen extends StatefulWidget {
  final String date;
  final Map moneyArgs;
  DetailDisplayScreen({@required this.date, this.moneyArgs});

  @override
  _DetailDisplayScreenState createState() => _DetailDisplayScreenState();
}

class _DetailDisplayScreenState extends State<DetailDisplayScreen> {
  Utility _utility = Utility();
  String year;
  String month;
  String day;

  String youbiStr;

  String _date;

  DateTime prevDate;
  DateTime nextDate;

  DateTime _prevMonthEndDate;

  String _yen10000 = '0';
  String _yen5000 = '0';
  String _yen2000 = '0';
  String _yen1000 = '0';
  String _yen500 = '0';
  String _yen100 = '0';
  String _yen50 = '0';
  String _yen10 = '0';
  String _yen5 = '0';
  String _yen1 = '0';

  String _bankA = '0';
  String _bankB = '0';
  String _bankC = '0';
  String _bankD = '0';
  String _bankE = '0';
  String _bankF = '0';
  String _bankG = '0';
  String _bankH = '0';

  String _payA = '0';
  String _payB = '0';
  String _payC = '0';
  String _payD = '0';
  String _payE = '0';
  String _payF = '0';
  String _payG = '0';
  String _payH = '0';

  List<Monie> _monieData = List();

  int _total = 0;
  int _spend = 0;
  int _temochi = 0;
  int _monthSpend = 0;
  int _undercoin = 0;

  List<String> _monthDays = List();

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
    youbiStr = _utility.youbiStr;

    _date = '${year}-${month}-${day}';

    prevDate =
        new DateTime(int.parse(year), int.parse(month), int.parse(day) - 1);
    nextDate =
        new DateTime(int.parse(year), int.parse(month), int.parse(day) + 1);

    _prevMonthEndDate = new DateTime(int.parse(year), int.parse(month), 0);

    ////////////////////////////////////////////////
    _utility.makeMonthEnd(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
    _utility.makeYMDYData(_utility.monthEndDateTime, 0);

    for (int i = 1; i <= int.parse(_utility.day); i++) {
      var value = (i < 10) ? '0${i.toString()}' : i.toString();
      _monthDays.add(value);
    }

    ////////////////////////////////////////////////
    //本日分のレコードを取得

    //マネーレコード①　当日日付で検索
    _monieData = await database.selectRecord(_date);

    if (_monieData.length > 0) {
      _yen10000 = _monieData[0].strYen10000;
      _yen5000 = _monieData[0].strYen5000;
      _yen2000 = _monieData[0].strYen2000;
      _yen1000 = _monieData[0].strYen1000;
      _yen500 = _monieData[0].strYen500;
      _yen100 = _monieData[0].strYen100;
      _yen50 = _monieData[0].strYen50;
      _yen10 = _monieData[0].strYen10;
      _yen5 = _monieData[0].strYen5;
      _yen1 = _monieData[0].strYen1;

      _bankA = _monieData[0].strBankA;
      _bankB = _monieData[0].strBankB;
      _bankC = _monieData[0].strBankC;
      _bankD = _monieData[0].strBankD;
      _bankE = _monieData[0].strBankE;
      _bankF = _monieData[0].strBankF;
      _bankG = _monieData[0].strBankG;
      _bankH = _monieData[0].strBankH;

      _payA = _monieData[0].strPayA;
      _payB = _monieData[0].strPayB;
      _payC = _monieData[0].strPayC;
      _payD = _monieData[0].strPayD;
      _payE = _monieData[0].strPayE;
      _payF = _monieData[0].strPayF;
      _payG = _monieData[0].strPayG;
      _payH = _monieData[0].strPayH;

      _utility.makeTotal(_monieData[0]);
      _total = _utility.total;
      _temochi = _utility.temochi;
      _undercoin = _utility.undercoin;

      ////////////////////////////////////////////////
      //昨日分のレコードを取得
      _utility.makeYMDYData(prevDate.toString(), 0);
      var yYear = _utility.year;
      var yMonth = _utility.month;
      var yDay = _utility.day;

      //マネーレコード②　前日日付で検索
      var _yesterdayData =
          await database.selectRecord('${yYear}-${yMonth}-${yDay}');

      if (_yesterdayData.length > 0) {
        _utility.makeTotal(_yesterdayData[0]);
        var _yesterdayTotal = _utility.total;
        _spend = (_yesterdayTotal - _total) * -1;
      }
    }

    ////////////////////////////////////////////////
    //当月の使用金額
    _utility.makeYMDYData(_prevMonthEndDate.toString(), 0);

    //マネーレコード③　先月末日付で検索
    var _lastMonthEndData = await database
        .selectRecord('${_utility.year}-${_utility.month}-${_utility.day}');

    var _lastMonthTotal = 0;
    if (_lastMonthEndData.length > 0) {
      _utility.makeTotal(_lastMonthEndData[0]);
      _lastMonthTotal = _utility.total;
    }

    _monthSpend = (_lastMonthTotal - _total) * -1;

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('所持金額'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goPrevDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goNextDate(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          DetailDisplayBox(context),
        ],
      ),
    );
  }

  Row DetailDisplayBox(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Yomogi",
                            ),
                            child: Text('${_date}（${youbiStr}）'),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Yomogi",
                        ),
                        child: Table(
                          children: [
                            TableRow(children: [
                              _getTextDispWidget(
                                  'total', false, '', false, false),
                              _getTextDispWidget(
                                  _total.toString(), false, '', false, true),
                              const Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'spend', false, '', false, false),
                              _getTextDispWidget(
                                  _spend.toString(), false, '', false, true),
                              const Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'month spend', false, '', false, false),
                              _getTextDispWidget(_monthSpend.toString(), false,
                                  '', false, true),
                              const Align(),
                            ]),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "Yomogi",
                        ),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.green[900].withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Text('currency'),
                                  ),
                                ),
                              ),
                              Container(),
                              Container(),
                              Container(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  '10000', false, '', false, false),
                              _getTextDispWidget(
                                  _yen10000, false, '', false, false),
                              _getTextDispWidget(
                                  '100', false, '', false, false),
                              _getTextDispWidget(
                                  _yen100, false, '', false, false),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  '5000', false, '', false, false),
                              _getTextDispWidget(
                                  _yen5000, false, '', false, false),
                              _getTextDispWidget('50', false, '', false, false),
                              _getTextDispWidget(
                                  _yen50, false, '', false, false),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  '2000', false, '', false, false),
                              _getTextDispWidget(
                                  _yen2000, false, '', false, false),
                              _getTextDispWidget('10', false, '', true, false),
                              _getTextDispWidget(
                                  _yen10, false, '', true, false),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  '1000', false, '', false, false),
                              _getTextDispWidget(
                                  _yen1000, false, '', false, false),
                              _getTextDispWidget('5', false, '', true, false),
                              _getTextDispWidget(_yen5, false, '', true, false),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  '500', false, '', false, false),
                              _getTextDispWidget(
                                  _yen500, false, '', false, false),
                              _getTextDispWidget('1', false, '', true, false),
                              _getTextDispWidget(_yen1, false, '', true, false),
                            ]),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: Text(
                            _utility.makeCurrencyDisplay(_temochi.toString()),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: Text(
                            _utility.makeCurrencyDisplay(_undercoin.toString()),
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "Yomogi",
                        ),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.green[900].withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Text('deposit'),
                                  ),
                                ),
                              ),
                              Container(),
                              Container(),
                              Container(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'bank_a', true, _bankA, false, false),
                              _getTextDispWidget(
                                  _bankA, true, _bankA, false, true),
                              _getTextDispWidget(
                                  'bank_e', true, _bankE, false, false),
                              _getTextDispWidget(
                                  _bankE, true, _bankE, false, true),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'bank_b', true, _bankD, false, false),
                              _getTextDispWidget(
                                  _bankB, true, _bankD, false, true),
                              _getTextDispWidget(
                                  'bank_f', true, _bankF, false, false),
                              _getTextDispWidget(
                                  _bankF, true, _bankF, false, true),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'bank_c', true, _bankC, false, false),
                              _getTextDispWidget(
                                  _bankC, true, _bankC, false, true),
                              _getTextDispWidget(
                                  'bank_g', true, _bankG, false, false),
                              _getTextDispWidget(
                                  _bankG, true, _bankG, false, true),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'bank_d', true, _bankD, false, false),
                              _getTextDispWidget(
                                  _bankD, true, _bankD, false, true),
                              _getTextDispWidget(
                                  'bank_h', true, _bankH, false, false),
                              _getTextDispWidget(
                                  _bankH, true, _bankH, false, true),
                            ]),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "Yomogi",
                        ),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.green[900].withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Text('e-money'),
                                  ),
                                ),
                              ),
                              Container(),
                              Container(),
                              Container(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'pay_a', true, _payA, false, false),
                              _getTextDispWidget(
                                  _payA, true, _payA, false, true),
                              _getTextDispWidget(
                                  'pay_e', true, _payE, false, false),
                              _getTextDispWidget(
                                  _payE, true, _payE, false, true),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'pay_b', true, _payB, false, false),
                              _getTextDispWidget(
                                  _payB, true, _payB, false, true),
                              _getTextDispWidget(
                                  'pay_f', true, _payF, false, false),
                              _getTextDispWidget(
                                  _payF, true, _payF, false, true),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'pay_c', true, _payC, false, false),
                              _getTextDispWidget(
                                  _payC, true, _payC, false, true),
                              _getTextDispWidget(
                                  'pay_g', true, _payG, false, false),
                              _getTextDispWidget(
                                  _payG, true, _payG, false, true),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget(
                                  'pay_d', true, _payD, false, false),
                              _getTextDispWidget(
                                  _payD, true, _payD, false, true),
                              _getTextDispWidget(
                                  'pay_h', true, _payH, false, false),
                              _getTextDispWidget(
                                  _payH, true, _payH, false, true),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.black.withOpacity(0.3),
                    onPressed: () => _showUnderMenu(),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.greenAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ///////////////////////////////
        Container(
          width: 60,
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.only(top: 5),
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _goDetailDisplayScreen(context, _date),
                      color: Colors.blueAccent,
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _showDatepicker(context),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.only(top: 5),
                color: Colors.black.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('${year}'),
                      Text('${month}'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _monthDaysList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /**
   * リスト表示
   */
  _monthDaysList() {
    return ListView.builder(
      itemCount: _monthDays.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  /**
   * リストアイテム表示
   */
  _listItem(int position) {
    return InkWell(
      child: Card(
        color: getBgColor(position),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: DefaultTextStyle(
            style: TextStyle(fontSize: 10.0),
            child: Center(
              child: Text(
                _monthDays[position],
              ),
            ),
          ),
          onTap: () => _goMonthDay(context, position),
        ),
      ),
      //actions: <Widget>[],
    );
  }

  /**
   * 背景色取得
   */
  getBgColor(int position) {
    _utility.makeYMDYData('${year}-${month}-${_monthDays[position]}', 0);

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

    return _color;
  }

  /**
   * テキスト部分表示
   */
  Widget _getTextDispWidget(String text, bool greyDisp, String value,
      bool undercoin, bool currencyDisp) {
    if (greyDisp == true && value == '0') {
      return Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 12,
          ),
          child: Text(
            getDisplayText(text, currencyDisp),
          ),
        ),
      );
    } else {
      if (undercoin == true) {
        return Center(
          child: Text(
            getDisplayText(text, currencyDisp),
            style: TextStyle(color: Colors.orangeAccent),
          ),
        );
      } else {
        return Center(
          child: Text(
            getDisplayText(text, currencyDisp),
          ),
        );
      }
    }
  }

  /**
   * 表示テキスト取得
   */
  String getDisplayText(String text, bool currencyDisp) {
    return (currencyDisp) ? _utility.makeCurrencyDisplay(text) : text;
  }

  /**
   * 下部メニュー表示
   */
  Future<Widget> _showUnderMenu() {
    return showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.black.withOpacity(0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text(
                    'Score List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goScoreListScreen(context, _date),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Monthly List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goMonthlyListScreen(context, _date),
                ),
                ListTile(
                  leading: const Icon(Icons.all_out),
                  title: const Text(
                    'AllDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goAlldayListScreen(context, _date),
                ),
                ListTile(
                  leading: const Icon(Icons.all_inclusive),
                  title: const Text(
                    'SameDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goSamedayListScreen(context, _date),
                ),
                Container(
                  color: Colors.blueAccent.withOpacity(0.1),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.input),
                        title: const Text(
                          'Oneday Input',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () => _goOnedayInputScreen(context, _date),
                      ),
                      ListTile(
                        leading: const Icon(Icons.business),
                        title: const Text(
                          'Bank Input',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () => _goBankInputScreen(context, _date),
                      ),
                      ListTile(
                        leading: const Icon(Icons.category),
                        title: const Text(
                          'Bank Record Input',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () => _goCreditRecordInputScreen(context, _date),
                      ),
                      ListTile(
                        leading: const Icon(Icons.beenhere),
                        title: const Text(
                          'Benefit Input',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () => _goBenefitInputScreen(context, _date),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.greenAccent.withOpacity(0.1),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text(
                          'Settings',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () => _goSettingBaseScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /**
   * デートピッカー表示
   */
  _showDatepicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
    );

    if (selectedDate != null) {
      _goDetailDisplayScreen(context, selectedDate.toString());
    }
  }

  /**
   * 画面遷移（前日）
   */
  _goPrevDate(BuildContext context) {
    _goDetailDisplayScreen(context, prevDate.toString());
  }

  /**
   * 画面遷移（翌日）
   */
  _goNextDate(BuildContext context) {
    _goDetailDisplayScreen(context, nextDate.toString());
  }

  /**
   * 画面遷移（月内指定日）
   */
  _goMonthDay(BuildContext context, int position) {
    _goDetailDisplayScreen(context, '${year}-${month}-${_monthDays[position]}');
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen(BuildContext context, String date) async {
    //①　当日データ
    //②　前日データ
    _utility.makeYMDYData(date, 0);
    var zenjitsu = new DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) - 1);

    //③　先月末データ

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
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
   * 画面遷移（ScoreListScreen）
   */
  _goScoreListScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreListScreen(
          date: date,
        ),
      ),
    );
  }

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
   * 画面遷移（BankInputScreen）
   */
  _goBankInputScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BankInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（SamedayDisplayScreen）
   */
  _goSamedayListScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SamedayListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（BenefitInputScreen）
   */
  _goBenefitInputScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BenefitInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（AlldayListScreen）
   */
  _goAlldayListScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AlldayListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（CreditRecordInputScreen）
   */
  _goCreditRecordInputScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditRecordInputScreen(
          date: date,
          searchitem: null,
        ),
      ),
    );
  }

  /**
   * 画面遷移（SettingBaseScreen）
   */
  _goSettingBaseScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SettingBaseScreen(),
      ),
    );
  }
}
