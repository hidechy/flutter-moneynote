import 'package:flutter/material.dart';
import 'package:moneynote/db/database.dart';
import '../main.dart';
import 'bank_input_screen.dart';
import 'monthly_list_screen.dart';
import '../utilities/utility.dart';
import 'oneday_input_screen.dart';
import 'score_list_screen.dart';

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

  String _payA = '0';
  String _payB = '0';

  List<Monie> _monieData = List();

  int _total = 0;
  int _spend = 0;

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

    ////////////////////////////////////////////////
    //本日分のレコードを取得
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

      _payA = _monieData[0].strPayA;
      _payB = _monieData[0].strPayB;

      _utility.makeTotal(_monieData);
      _total = _utility.total;

      ////////////////////////////////////////////////
      //昨日分のレコードを取得
      _utility.makeYMDYData(prevDate.toString(), 0);
      var yYear = _utility.year;
      var yMonth = _utility.month;
      var yDay = _utility.day;

      var _yesterdayData =
          await database.selectRecord(yYear + "-" + yMonth + "-" + yDay);

      if (_yesterdayData.length > 0) {
        List<List<String>> _totalValue = List();

        _totalValue.add(['10000', _yesterdayData[0].strYen10000]);
        _totalValue.add(['5000', _yesterdayData[0].strYen5000]);
        _totalValue.add(['2000', _yesterdayData[0].strYen2000]);
        _totalValue.add(['1000', _yesterdayData[0].strYen1000]);
        _totalValue.add(['500', _yesterdayData[0].strYen500]);
        _totalValue.add(['100', _yesterdayData[0].strYen100]);
        _totalValue.add(['50', _yesterdayData[0].strYen50]);
        _totalValue.add(['10', _yesterdayData[0].strYen10]);
        _totalValue.add(['5', _yesterdayData[0].strYen5]);
        _totalValue.add(['1', _yesterdayData[0].strYen1]);

        _totalValue.add(['1', _yesterdayData[0].strBankA]);
        _totalValue.add(['1', _yesterdayData[0].strBankB]);
        _totalValue.add(['1', _yesterdayData[0].strBankC]);
        _totalValue.add(['1', _yesterdayData[0].strBankD]);

        _totalValue.add(['1', _yesterdayData[0].strPayA]);
        _totalValue.add(['1', _yesterdayData[0].strPayB]);

        var _yesterdayTotal = 0;
        for (int i = 0; i < _totalValue.length; i++) {
          _yesterdayTotal +=
              (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
        }

        _spend = (_yesterdayTotal - _total) * -1;
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
        title: Text(
          '所持金額',
          style: TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _goDetailScreen(),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _showDatepicker(context),
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
          DefaultTextStyle(
            style: TextStyle(fontSize: 16.0, fontFamily: "Yomogi"),
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.black.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.skip_previous),
                                  Text(
                                    '前日',
                                  ),
                                ],
                              ),
                              onPressed: () => _goPrevDate(context),
                            ),
                            Text(
                              _date + '（' + youbiStr + '）',
                            ),
                            FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '翌日',
                                  ),
                                  Icon(Icons.skip_next),
                                ],
                              ),
                              onPressed: () => _goNextDate(context),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.indigo,
                          height: 20.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              _getTextDispWidget('total'),
                              _getTextDispWidget(_total.toString()),
                              Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('spend'),
                              _getTextDispWidget(_spend.toString()),
                              Align(),
                            ]),
                          ],
                        ),
                        Divider(
                          color: Colors.indigo,
                          height: 20.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              _getTextDispWidget('10000'),
                              _getTextDispWidget(_yen10000),
                              _getTextDispWidget('100'),
                              _getTextDispWidget(_yen100),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('5000'),
                              _getTextDispWidget(_yen5000),
                              _getTextDispWidget('50'),
                              _getTextDispWidget(_yen50),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('2000'),
                              _getTextDispWidget(_yen2000),
                              _getTextDispWidget('10'),
                              _getTextDispWidget(_yen10),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('1000'),
                              _getTextDispWidget(_yen1000),
                              _getTextDispWidget('5'),
                              _getTextDispWidget(_yen5),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('500'),
                              _getTextDispWidget(_yen500),
                              _getTextDispWidget('1'),
                              _getTextDispWidget(_yen1),
                            ]),
                          ],
                        ),
                        Divider(
                          color: Colors.indigo,
                          height: 20.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              _getTextDispWidget('bank_a'),
                              _getTextDispWidget(_bankA),
                              Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('bank_b'),
                              _getTextDispWidget(_bankB),
                              Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('bank_c'),
                              _getTextDispWidget(_bankC),
                              Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('bank_d'),
                              _getTextDispWidget(_bankD),
                              Align(),
                            ]),
                          ],
                        ),
                        Divider(
                          color: Colors.indigo,
                          height: 20.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              _getTextDispWidget('pay_a'),
                              _getTextDispWidget(_payA),
                              Align(),
                            ]),
                            TableRow(children: [
                              _getTextDispWidget('pay_b'),
                              _getTextDispWidget(_payB),
                              Align(),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_up),
                      tooltip: 'menu',
                      color: Colors.blue,
                      onPressed: () => _showUnderMenu(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * テキスト部分表示
   */
  Widget _getTextDispWidget(String text) {
    return Center(
      child: Text(text),
    );
  }

  /**
   * デートピッカー表示
   */
  _showDatepicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Score'),
              onTap: () => _goScoreDisplayScreen(),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Monthly'),
              onTap: () => _goMonthlyDisplayScreen(),
            ),
            Container(
              color: Colors.grey[900],
              child: ListTile(
                leading: Icon(Icons.input),
                title: Text('Oneday Input'),
                onTap: () => _goOnedayInputScreen(),
              ),
            ),
            Container(
              color: Colors.grey[900],
              child: ListTile(
                leading: Icon(Icons.business),
                title: Text('Bank Input'),
                onTap: () => _goBankInputScreen(),
              ),
            ),
          ],
        );
      },
    );
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailScreen() {
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
  _goScoreDisplayScreen() {
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
  _goMonthlyDisplayScreen() {
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
}
