import 'package:flutter/material.dart';
import 'package:moneynote/screens/allday_list_screen.dart';

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

class DetailDisplayScreen extends StatefulWidget {
  final String date;
  DetailDisplayScreen({@required this.date});

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

    _date = year + "-" + month + "-" + day;

    prevDate =
        new DateTime(int.parse(year), int.parse(month), int.parse(day) - 1);
    nextDate =
        new DateTime(int.parse(year), int.parse(month), int.parse(day) + 1);

    _prevMonthEndDate = new DateTime(int.parse(year), int.parse(month), 0);

    ////////////////////////////////////////////////
    //本日分のレコードを取得
    _monieData = await database.selectRecord(_date);

    print(_monieData);

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

      _utility.makeTotal(_monieData);
      _total = _utility.total;
      _temochi = _utility.temochi;

      ////////////////////////////////////////////////
      //昨日分のレコードを取得
      _utility.makeYMDYData(prevDate.toString(), 0);
      var yYear = _utility.year;
      var yMonth = _utility.month;
      var yDay = _utility.day;

      var _yesterdayData =
          await database.selectRecord(yYear + "-" + yMonth + "-" + yDay);

      if (_yesterdayData.length > 0) {
        _utility.makeTotal(_yesterdayData);
        var _yesterdayTotal = _utility.total;
        _spend = (_yesterdayTotal - _total) * -1;
      }
    }

    ////////////////////////////////////////////////
    //当月の使用金額
    _utility.makeYMDYData(_prevMonthEndDate.toString(), 0);
    var _lastMonthEndData = await database.selectRecord(
        _utility.year + "-" + _utility.month + "-" + _utility.day);

    var _lastMonthTotal = 0;
    if (_lastMonthEndData.length > 0) {
      _utility.makeTotal(_lastMonthEndData);
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
        title: const Text(
          '所持金額',
          style: TextStyle(fontFamily: "Yomogi"),
        ),
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
          Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.black.withOpacity(0.3),
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
                          child: Text(
                            _date + '（' + youbiStr + '）',
                          ),
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
                            _getTextDispWidget('total', false, ''),
                            _getTextDispWidget(_total.toString(), false, ''),
                            const Align(),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('spend', false, ''),
                            _getTextDispWidget(_spend.toString(), false, ''),
                            const Align(),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('month spend', false, ''),
                            _getTextDispWidget(
                                _monthSpend.toString(), false, ''),
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
                            _getTextDispWidget('10000', false, ''),
                            _getTextDispWidget(_yen10000, false, ''),
                            _getTextDispWidget('100', false, ''),
                            _getTextDispWidget(_yen100, false, ''),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('5000', false, ''),
                            _getTextDispWidget(_yen5000, false, ''),
                            _getTextDispWidget('50', false, ''),
                            _getTextDispWidget(_yen50, false, ''),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('2000', false, ''),
                            _getTextDispWidget(_yen2000, false, ''),
                            _getTextDispWidget('10', false, ''),
                            _getTextDispWidget(_yen10, false, ''),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('1000', false, ''),
                            _getTextDispWidget(_yen1000, false, ''),
                            _getTextDispWidget('5', false, ''),
                            _getTextDispWidget(_yen5, false, ''),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('500', false, ''),
                            _getTextDispWidget(_yen500, false, ''),
                            _getTextDispWidget('1', false, ''),
                            _getTextDispWidget(_yen1, false, ''),
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
                          _temochi.toString(),
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontFamily: "Yomogi",
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
                            _getTextDispWidget('bank_a', true, _bankA),
                            _getTextDispWidget(_bankA, true, _bankA),
                            _getTextDispWidget('bank_e', true, _bankE),
                            _getTextDispWidget(_bankE, true, _bankE),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('bank_b', true, _bankD),
                            _getTextDispWidget(_bankB, true, _bankD),
                            _getTextDispWidget('bank_f', true, _bankF),
                            _getTextDispWidget(_bankF, true, _bankF),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('bank_c', true, _bankC),
                            _getTextDispWidget(_bankC, true, _bankC),
                            _getTextDispWidget('bank_g', true, _bankG),
                            _getTextDispWidget(_bankG, true, _bankG),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('bank_d', true, _bankD),
                            _getTextDispWidget(_bankD, true, _bankD),
                            _getTextDispWidget('bank_h', true, _bankH),
                            _getTextDispWidget(_bankH, true, _bankH),
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
                            _getTextDispWidget('pay_a', true, _payA),
                            _getTextDispWidget(_payA, true, _payA),
                            _getTextDispWidget('pay_e', true, _payE),
                            _getTextDispWidget(_payE, true, _payE),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('pay_b', true, _payB),
                            _getTextDispWidget(_payB, true, _payB),
                            _getTextDispWidget('pay_f', true, _payF),
                            _getTextDispWidget(_payF, true, _payF),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('pay_c', true, _payC),
                            _getTextDispWidget(_payC, true, _payC),
                            _getTextDispWidget('pay_g', true, _payG),
                            _getTextDispWidget(_payG, true, _payG),
                          ]),
                          TableRow(children: [
                            _getTextDispWidget('pay_d', true, _payD),
                            _getTextDispWidget(_payD, true, _payD),
                            _getTextDispWidget('pay_h', true, _payH),
                            _getTextDispWidget(_payH, true, _payH),
                          ]),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _showDatepicker(context),
                          color: Colors.blueAccent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _goDetailDisplayScreen(),
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_up),
                    tooltip: 'menu',
                    color: Colors.blue,
                    onPressed: () => _showUnderMenu(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
  * テキスト部分表示
  */
  Widget _getTextDispWidget(String text, bool greyDisp, String value) {
    if (greyDisp == true && value == '0') {
      return Center(
        child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
              fontFamily: "Yomogi",
            ),
            child: Text(text)),
      );
    } else {
      return Center(
        child: Text(text),
      );
    }
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
      _goAnotherDate(context, selectedDate.toString());
    }
  }

  /**
  * 画面遷移（前日）
  */
  _goPrevDate(BuildContext context) {
    _goAnotherDate(context, prevDate.toString());
  }

  /**
  * 画面遷移（翌日）
  */
  _goNextDate(BuildContext context) {
    _goAnotherDate(context, nextDate.toString());
  }

  /**
  * 画面遷移（指定日）
  */
  _goAnotherDate(BuildContext context, String date) {
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
  * 下部メニュー表示
  */
  Future<Widget> _showUnderMenu() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Score List'),
                onTap: () => _goScoreListScreen(),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Monthly List'),
                onTap: () => _goMonthlyListScreen(),
              ),
              ListTile(
                leading: const Icon(Icons.all_out),
                title: const Text('AllDay List'),
                onTap: () => _goAlldayListScreen(),
              ),
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('SameDay List'),
                onTap: () => _goSamedayListScreen(),
              ),
              Container(
                color: Colors.grey[900],
                child: ListTile(
                  leading: const Icon(Icons.input),
                  title: const Text('Oneday Input'),
                  onTap: () => _goOnedayInputScreen(),
                ),
              ),
              Container(
                color: Colors.grey[900],
                child: ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Bank Input'),
                  onTap: () => _goBankInputScreen(),
                ),
              ),
              Container(
                color: Colors.grey[900],
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Bank Record Input'),
                  onTap: () => _goCreditRecordInputScreen(),
                ),
              ),
              Container(
                color: Colors.grey[900],
                child: ListTile(
                  leading: const Icon(Icons.beenhere),
                  title: const Text('Benefit Input'),
                  onTap: () => _goBenefitInputScreen(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /**
  * 画面遷移（DetailDisplayScreen）
  */
  _goDetailDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（OnedayInputScreen）
  */
  _goOnedayInputScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（ScoreListScreen）
  */
  _goScoreListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreListScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（MonthlyListScreen）
  */
  _goMonthlyListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（BankInputScreen）
  */
  _goBankInputScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BankInputScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（SamedayDisplayScreen）
  */
  _goSamedayListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SamedayListScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（BenefitInputScreen）
  */
  _goBenefitInputScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BenefitInputScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（AlldayListScreen）
  */
  _goAlldayListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AlldayListScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
  * 画面遷移（CreditRecordInputScreen）
  */
  _goCreditRecordInputScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditRecordInputScreen(
          date: _date,
          searchitem: null,
        ),
      ),
    );
  }
}
