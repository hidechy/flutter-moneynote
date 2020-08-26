import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:moneynote/screens/setting_base_screen.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  final int index;
  final Map detailDisplayArgs;
  DetailDisplayScreen(
      {@required this.date, this.index, this.detailDisplayArgs});

  @override
  _DetailDisplayScreenState createState() => _DetailDisplayScreenState();
}

class _DetailDisplayScreenState extends State<DetailDisplayScreen> {
  Utility _utility = Utility();

  String displayYear;
  String displayMonth;

  String displayDate;

  DateTime prevDate;
  DateTime nextDate;

  List<List<dynamic>> _monthDays = List();

  AutoScrollController controller;

  int thisMonthEndDate;

  String youbiStr;

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

  int _total = 0;
  int _temochi = 0;
  int _undercoin = 0;

  int _spend = 0;
  int _monthSpend = 0;

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

    displayYear = _utility.year;
    displayMonth = _utility.month;

    youbiStr = _utility.youbiStr;

    displayDate =
        '${_utility.year}-${_utility.month}-${_utility.day.padLeft(2, '0')}';

    prevDate = new DateTime(int.parse(_utility.year), int.parse(_utility.month),
        int.parse(_utility.day) - 1);
    nextDate = new DateTime(int.parse(_utility.year), int.parse(_utility.month),
        int.parse(_utility.day) + 1);

    ////////////////////////////////////////////////
    _utility.makeMonthEnd(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
    _utility.makeYMDYData(_utility.monthEndDateTime, 0);

    thisMonthEndDate = int.parse(_utility.day);

    for (int i = 0; i <= int.parse(_utility.day); i++) {
      _monthDays.add([
        i,
        i.toString().padLeft(2, '0'),
      ]);
    }
    ////////////////////////////////////////////////

    /////////////////////////////////////////////////////
    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      axis: Axis.vertical,
    );

    await controller.scrollToIndex(widget.index,
        preferPosition: AutoScrollPosition.begin);
    /////////////////////////////////////////////////////

    if (widget.detailDisplayArgs['today'] != null) {
      _yen10000 = widget.detailDisplayArgs['today'][0].strYen10000;
      _yen5000 = widget.detailDisplayArgs['today'][0].strYen5000;
      _yen2000 = widget.detailDisplayArgs['today'][0].strYen2000;
      _yen1000 = widget.detailDisplayArgs['today'][0].strYen1000;
      _yen500 = widget.detailDisplayArgs['today'][0].strYen500;
      _yen100 = widget.detailDisplayArgs['today'][0].strYen100;
      _yen50 = widget.detailDisplayArgs['today'][0].strYen50;
      _yen10 = widget.detailDisplayArgs['today'][0].strYen10;
      _yen5 = widget.detailDisplayArgs['today'][0].strYen5;
      _yen1 = widget.detailDisplayArgs['today'][0].strYen1;

      _bankA = widget.detailDisplayArgs['today'][0].strBankA;
      _bankB = widget.detailDisplayArgs['today'][0].strBankB;
      _bankC = widget.detailDisplayArgs['today'][0].strBankC;
      _bankD = widget.detailDisplayArgs['today'][0].strBankD;
      _bankE = widget.detailDisplayArgs['today'][0].strBankE;
      _bankF = widget.detailDisplayArgs['today'][0].strBankF;
      _bankG = widget.detailDisplayArgs['today'][0].strBankG;
      _bankH = widget.detailDisplayArgs['today'][0].strBankH;

      _payA = widget.detailDisplayArgs['today'][0].strPayA;
      _payB = widget.detailDisplayArgs['today'][0].strPayB;
      _payC = widget.detailDisplayArgs['today'][0].strPayC;
      _payD = widget.detailDisplayArgs['today'][0].strPayD;
      _payE = widget.detailDisplayArgs['today'][0].strPayE;
      _payF = widget.detailDisplayArgs['today'][0].strPayF;
      _payG = widget.detailDisplayArgs['today'][0].strPayG;
      _payH = widget.detailDisplayArgs['today'][0].strPayH;

      _utility.makeTotal(widget.detailDisplayArgs['today'][0]);
      _total = _utility.total;
      _temochi = _utility.temochi;
      _undercoin = _utility.undercoin;
    }

    if (widget.detailDisplayArgs['yesterday'] != null) {
      _utility.makeTotal(widget.detailDisplayArgs['yesterday'][0]);
      var _yesterdayTotal = _utility.total;
      _spend = (_yesterdayTotal - _total) * -1;
    }

    var _lastMonthTotal = 0;
    if (widget.detailDisplayArgs['lastMonthEnd'] != null) {
      _utility.makeTotal(widget.detailDisplayArgs['lastMonthEnd'][0]);
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
                      //------------------------------------------------------------------------//
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Yomogi",
                            ),
                            child: Text('${displayDate}（${youbiStr}）'),
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
                          padding: const EdgeInsets.only(right: 30.0),
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
                          padding: const EdgeInsets.only(right: 30.0),
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
                      //------------------------------------------------------------------------//
                    ],
                  ),
                ),
              ),
              //------------------------------------------------------------------------//
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
              //------------------------------------------------------------------------//
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
                      onPressed: () => _goDetailDisplayScreen(
                        context,
                        displayDate,
                        widget.index,
                      ),
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
                      Text('${displayYear}'),
                      Text('${displayMonth}'),
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
    return ListView(
      scrollDirection: Axis.vertical,
      controller: controller,
      children: _monthDays.map<Widget>((data) {
        return (data[0] == 0)
            ? Container()
            : Card(
                color: _utility.getListBgColor(
                    '${displayYear}-${displayMonth}-${data[1]}'),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  child: ListTile(
                    onTap: () => _goMonthDay(context, data[0]),
                    title: AutoScrollTag(
                      index: data[0],
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${data[1]}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      key: ValueKey(data[0]),
                      controller: controller,
                    ),
                  ),
                ),
              );
      }).toList(),
    );
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
                  leading: const Icon(Icons.input),
                  title: const Text(
                    'Oneday Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goOnedayInputScreen(context, displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Monthly List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goMonthlyListScreen(context, displayDate),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text(
                    'Bank Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goBankInputScreen(context, displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text(
                    'Bank Record Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goBankRecordInputScreen(context, displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.beenhere),
                  title: const Text(
                    'Benefit Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goBenefitInputScreen(context, displayDate),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text(
                    'Score List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goScoreListScreen(context, displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.all_out),
                  title: const Text(
                    'AllDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goAlldayListScreen(context, displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.all_inclusive),
                  title: const Text(
                    'SameDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goSamedayListScreen(context, displayDate),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
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
      _goDetailDisplayScreen(context, selectedDate.toString(), 1);
    }
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（前日）
   */
  _goPrevDate(BuildContext context) {
    _utility.makeYMDYData(prevDate.toString(), 0);

    _goDetailDisplayScreen(
      context,
      prevDate.toString(),
      int.parse(_utility.day),
    );
  }

  /**
   * 画面遷移（翌日）
   */
  _goNextDate(BuildContext context) {
    _utility.makeYMDYData(nextDate.toString(), 0);

    _goDetailDisplayScreen(
      context,
      nextDate.toString(),
      int.parse(_utility.day),
    );
  }

  /**
   * 画面遷移（月内指定日）
   */
  _goMonthDay(BuildContext context, int position) {
    _goDetailDisplayScreen(
        context,
        '${displayYear}-${displayMonth}-${_monthDays[position][0].toString().padLeft(2, '0')}',
        position);
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen(BuildContext context, String date, int index) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: index,
          detailDisplayArgs: detailDisplayArgs,
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
  _goBankRecordInputScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BankRecordInputScreen(
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
