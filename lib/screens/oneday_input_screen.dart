import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../main.dart';

import '../db/database.dart';
import '../utilities/utility.dart';

import 'detail_display_screen.dart';
import 'monthly_list_screen.dart';

class OnedayInputScreen extends StatefulWidget {
  final String date;
  OnedayInputScreen({@required this.date});

  @override
  _OnedayInputScreenState createState() => _OnedayInputScreenState();
}

class _OnedayInputScreenState extends State<OnedayInputScreen> {
  Utility _utility = Utility();
  String year;
  String month;
  String day;
  String youbiStr;

  String _date;

  DateTime prevDate;
  DateTime nextDate;

  List<Monie> _monieData;

  String _text = '';
  TextEditingController _teContDate = TextEditingController();

  TextEditingController _teCont10000 = TextEditingController();
  TextEditingController _teCont5000 = TextEditingController();
  TextEditingController _teCont2000 = TextEditingController();
  TextEditingController _teCont1000 = TextEditingController();
  TextEditingController _teCont500 = TextEditingController();
  TextEditingController _teCont100 = TextEditingController();
  TextEditingController _teCont50 = TextEditingController();
  TextEditingController _teCont10 = TextEditingController();
  TextEditingController _teCont5 = TextEditingController();
  TextEditingController _teCont1 = TextEditingController();

  TextEditingController _teContBankA = TextEditingController();
  TextEditingController _teContBankB = TextEditingController();
  TextEditingController _teContBankC = TextEditingController();
  TextEditingController _teContBankD = TextEditingController();
  TextEditingController _teContBankE = TextEditingController();
  TextEditingController _teContBankF = TextEditingController();
  TextEditingController _teContBankG = TextEditingController();
  TextEditingController _teContBankH = TextEditingController();

  TextEditingController _teContPayA = TextEditingController();
  TextEditingController _teContPayB = TextEditingController();
  TextEditingController _teContPayC = TextEditingController();
  TextEditingController _teContPayD = TextEditingController();
  TextEditingController _teContPayE = TextEditingController();
  TextEditingController _teContPayF = TextEditingController();
  TextEditingController _teContPayG = TextEditingController();
  TextEditingController _teContPayH = TextEditingController();

  bool _updateFlag = false;

  int _onedayTotal = 0;
  int _onedaySpend = 0;

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

    //データベースのレコードを取得
    _monieData = await database.selectRecord(_date);
    if (_monieData.length > 0) {
      _teCont10000 = new TextEditingController(text: _monieData[0].strYen10000);
      _teCont5000 = new TextEditingController(text: _monieData[0].strYen5000);
      _teCont2000 = new TextEditingController(text: _monieData[0].strYen2000);
      _teCont1000 = new TextEditingController(text: _monieData[0].strYen1000);
      _teCont500 = new TextEditingController(text: _monieData[0].strYen500);
      _teCont100 = new TextEditingController(text: _monieData[0].strYen100);
      _teCont50 = new TextEditingController(text: _monieData[0].strYen50);
      _teCont10 = new TextEditingController(text: _monieData[0].strYen10);
      _teCont5 = new TextEditingController(text: _monieData[0].strYen5);
      _teCont1 = new TextEditingController(text: _monieData[0].strYen1);

      _teContBankA = new TextEditingController(text: _monieData[0].strBankA);
      _teContBankB = new TextEditingController(text: _monieData[0].strBankB);
      _teContBankC = new TextEditingController(text: _monieData[0].strBankC);
      _teContBankD = new TextEditingController(text: _monieData[0].strBankD);
      _teContBankE = new TextEditingController(text: _monieData[0].strBankE);
      _teContBankF = new TextEditingController(text: _monieData[0].strBankF);
      _teContBankG = new TextEditingController(text: _monieData[0].strBankG);
      _teContBankH = new TextEditingController(text: _monieData[0].strBankH);

      _teContPayA = new TextEditingController(text: _monieData[0].strPayA);
      _teContPayB = new TextEditingController(text: _monieData[0].strPayB);
      _teContPayC = new TextEditingController(text: _monieData[0].strPayC);
      _teContPayD = new TextEditingController(text: _monieData[0].strPayD);
      _teContPayE = new TextEditingController(text: _monieData[0].strPayE);
      _teContPayF = new TextEditingController(text: _monieData[0].strPayF);
      _teContPayG = new TextEditingController(text: _monieData[0].strPayG);
      _teContPayH = new TextEditingController(text: _monieData[0].strPayH);

      _updateFlag = true;
    } else {
      _teCont10000 = new TextEditingController(text: '0');
      _teCont5000 = new TextEditingController(text: '0');
      _teCont2000 = new TextEditingController(text: '0');
      _teCont1000 = new TextEditingController(text: '0');
      _teCont500 = new TextEditingController(text: '0');
      _teCont100 = new TextEditingController(text: '0');
      _teCont50 = new TextEditingController(text: '0');
      _teCont10 = new TextEditingController(text: '0');
      _teCont5 = new TextEditingController(text: '0');
      _teCont1 = new TextEditingController(text: '0');

      _teContBankA = new TextEditingController(text: '0');
      _teContBankB = new TextEditingController(text: '0');
      _teContBankC = new TextEditingController(text: '0');
      _teContBankD = new TextEditingController(text: '0');
      _teContBankE = new TextEditingController(text: '0');
      _teContBankF = new TextEditingController(text: '0');
      _teContBankG = new TextEditingController(text: '0');
      _teContBankH = new TextEditingController(text: '0');

      _teContPayA = new TextEditingController(text: '0');
      _teContPayB = new TextEditingController(text: '0');
      _teContPayC = new TextEditingController(text: '0');
      _teContPayD = new TextEditingController(text: '0');
      _teContPayE = new TextEditingController(text: '0');
      _teContPayF = new TextEditingController(text: '0');
      _teContPayG = new TextEditingController(text: '0');
      _teContPayH = new TextEditingController(text: '0');
    }

    setState(() {});
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_date}(${youbiStr})'),
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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            _getTextField('10000', _teCont10000),
                            _getTextField('5000', _teCont5000),
                            _getTextField('2000', _teCont2000),
                            _getTextField('1000', _teCont1000),
                          ]),
                          TableRow(children: [
                            _getTextField('500', _teCont500),
                            _getTextField('100', _teCont100),
                            _getTextField('50', _teCont50),
                            const Align(),
                          ]),
                          TableRow(children: [
                            _getTextField('10', _teCont10),
                            _getTextField('5', _teCont5),
                            _getTextField('1', _teCont1),
                            const Align(),
                          ]),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            _getTextField('bank_a', _teContBankA),
                            _getTextField('bank_b', _teContBankB),
                            _getTextField('bank_c', _teContBankC),
                            _getTextField('bank_d', _teContBankD),
                          ]),
                          TableRow(children: [
                            _getTextField('bank_e', _teContBankE),
                            _getTextField('bank_f', _teContBankF),
                            _getTextField('bank_g', _teContBankG),
                            _getTextField('bank_h', _teContBankH),
                          ]),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            _getTextField('pay_a', _teContPayA),
                            _getTextField('pay_b', _teContPayB),
                            _getTextField('pay_c', _teContPayC),
                            _getTextField('pay_d', _teContPayD),
                          ]),
                          TableRow(children: [
                            _getTextField('pay_e', _teContPayE),
                            _getTextField('pay_f', _teContPayF),
                            _getTextField('pay_g', _teContPayG),
                            _getTextField('pay_h', _teContPayH),
                          ]),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.content_copy),
                            tooltip: 'copy',
                            onPressed: () => _dataCopy(),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.list),
                            tooltip: 'list',
                            onPressed: () =>
                                _goMonthlyListScreen(context, _date),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.details),
                            tooltip: 'detail',
                            onPressed: () =>
                                _goDetailDisplayScreen(context, _date),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            tooltip: 'jump',
                            onPressed: () => _showDatepicker(context),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_box),
                            tooltip: 'total',
                            onPressed: () => _displayTotal(),
                            color: Colors.greenAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.input),
                            tooltip: 'input',
                            onPressed: () => _insertRecord(context),
                            color: Colors.greenAccent,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                        ),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('onedayTotal'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${_utility.makeCurrencyDisplay(_onedayTotal.toString())}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('onedaySpend'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${_utility.makeCurrencyDisplay(_onedaySpend.toString())}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height / 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
  * テキストフィールド部分表示
  */
  Widget _getTextField(String yen, TextEditingController con) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: con,
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          labelText: yen,
        ),
        style: TextStyle(
          fontSize: 12.0,
        ),
        onChanged: (value) {
          setState(
            () {
              _text = value;
            },
          );
        },
      ),
    );
  }

  /**
  * 前日データのコピー
  */
  _dataCopy() async {
    _utility.makeYMDYData(prevDate.toString(), 0);
    _monieData = await database
        .selectRecord('${_utility.year}-${_utility.month}-${_utility.day}');

    if (_monieData.length > 0) {
      _teCont10000 = new TextEditingController(text: _monieData[0].strYen10000);
      _teCont5000 = new TextEditingController(text: _monieData[0].strYen5000);
      _teCont2000 = new TextEditingController(text: _monieData[0].strYen2000);
      _teCont1000 = new TextEditingController(text: _monieData[0].strYen1000);
      _teCont500 = new TextEditingController(text: _monieData[0].strYen500);
      _teCont100 = new TextEditingController(text: _monieData[0].strYen100);
      _teCont50 = new TextEditingController(text: _monieData[0].strYen50);
      _teCont10 = new TextEditingController(text: _monieData[0].strYen10);
      _teCont5 = new TextEditingController(text: _monieData[0].strYen5);
      _teCont1 = new TextEditingController(text: _monieData[0].strYen1);

      _teContBankA = new TextEditingController(text: _monieData[0].strBankA);
      _teContBankB = new TextEditingController(text: _monieData[0].strBankB);
      _teContBankC = new TextEditingController(text: _monieData[0].strBankC);
      _teContBankD = new TextEditingController(text: _monieData[0].strBankD);
      _teContBankE = new TextEditingController(text: _monieData[0].strBankE);
      _teContBankF = new TextEditingController(text: _monieData[0].strBankF);
      _teContBankG = new TextEditingController(text: _monieData[0].strBankG);
      _teContBankH = new TextEditingController(text: _monieData[0].strBankH);

      _teContPayA = new TextEditingController(text: _monieData[0].strPayA);
      _teContPayB = new TextEditingController(text: _monieData[0].strPayB);
      _teContPayC = new TextEditingController(text: _monieData[0].strPayC);
      _teContPayD = new TextEditingController(text: _monieData[0].strPayD);
      _teContPayE = new TextEditingController(text: _monieData[0].strPayE);
      _teContPayF = new TextEditingController(text: _monieData[0].strPayF);
      _teContPayG = new TextEditingController(text: _monieData[0].strPayG);
      _teContPayH = new TextEditingController(text: _monieData[0].strPayH);
    }

    setState(() {});
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
  * データ作成/更新
  */
  _insertRecord(BuildContext context) async {
    var monie = Monie(
      strDate: _date,
      strYen10000: _teCont10000.text != "" ? _teCont10000.text : '0',
      strYen5000: _teCont5000.text != "" ? _teCont5000.text : '0',
      strYen2000: _teCont2000.text != "" ? _teCont2000.text : '0',
      strYen1000: _teCont1000.text != "" ? _teCont1000.text : '0',
      strYen500: _teCont500.text != "" ? _teCont500.text : '0',
      strYen100: _teCont100.text != "" ? _teCont100.text : '0',
      strYen50: _teCont50.text != "" ? _teCont50.text : '0',
      strYen10: _teCont10.text != "" ? _teCont10.text : '0',
      strYen5: _teCont5.text != "" ? _teCont5.text : '0',
      strYen1: _teCont1.text != "" ? _teCont1.text : '0',
      //
      strBankA: _teContBankA.text != "" ? _teContBankA.text : '0',
      strBankB: _teContBankB.text != "" ? _teContBankB.text : '0',
      strBankC: _teContBankC.text != "" ? _teContBankC.text : '0',
      strBankD: _teContBankD.text != "" ? _teContBankD.text : '0',
      strBankE: _teContBankE.text != "" ? _teContBankE.text : '0',
      strBankF: _teContBankF.text != "" ? _teContBankF.text : '0',
      strBankG: _teContBankG.text != "" ? _teContBankG.text : '0',
      strBankH: _teContBankH.text != "" ? _teContBankH.text : '0',
      //
      strPayA: _teContPayA.text != "" ? _teContPayA.text : '0',
      strPayB: _teContPayB.text != "" ? _teContPayB.text : '0',
      strPayC: _teContPayC.text != "" ? _teContPayC.text : '0',
      strPayD: _teContPayD.text != "" ? _teContPayD.text : '0',
      strPayE: _teContPayE.text != "" ? _teContPayE.text : '0',
      strPayF: _teContPayF.text != "" ? _teContPayF.text : '0',
      strPayG: _teContPayG.text != "" ? _teContPayG.text : '0',
      strPayH: _teContPayH.text != "" ? _teContPayH.text : '0',
    );

    if (_updateFlag == false) {
      await database.insertRecord(monie);
      Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    } else {
      await database.updateRecord(monie);
      Toast.show('更新が完了しました', context, duration: Toast.LENGTH_LONG);
    }

    _makeDefaultDisplayData();
  }

  /**
  * 合計金額表示
  */
  _displayTotal() async {
    //-------------------------------//現在の合計値
    _onedayTotal = 0;

    List<List<String>> _totalValue = List();
    _totalValue.add(['10000', _teCont10000.text]);
    _totalValue.add(['5000', _teCont5000.text]);
    _totalValue.add(['2000', _teCont2000.text]);
    _totalValue.add(['1000', _teCont1000.text]);
    _totalValue.add(['500', _teCont500.text]);
    _totalValue.add(['100', _teCont100.text]);
    _totalValue.add(['50', _teCont50.text]);
    _totalValue.add(['10', _teCont10.text]);
    _totalValue.add(['5', _teCont5.text]);
    _totalValue.add(['1', _teCont1.text]);

    _totalValue.add(['1', _teContBankA.text]);
    _totalValue.add(['1', _teContBankB.text]);
    _totalValue.add(['1', _teContBankC.text]);
    _totalValue.add(['1', _teContBankD.text]);
    _totalValue.add(['1', _teContBankE.text]);
    _totalValue.add(['1', _teContBankF.text]);
    _totalValue.add(['1', _teContBankG.text]);
    _totalValue.add(['1', _teContBankH.text]);

    _totalValue.add(['1', _teContPayA.text]);
    _totalValue.add(['1', _teContPayB.text]);
    _totalValue.add(['1', _teContPayC.text]);
    _totalValue.add(['1', _teContPayD.text]);
    _totalValue.add(['1', _teContPayE.text]);
    _totalValue.add(['1', _teContPayF.text]);
    _totalValue.add(['1', _teContPayG.text]);
    _totalValue.add(['1', _teContPayH.text]);

    for (int i = 0; i < _totalValue.length; i++) {
      _onedayTotal +=
          (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
    }
    //-------------------------------//現在の合計値

    //-------------------------------//前日の合計値
    _utility.makeYMDYData(prevDate.toString(), 0);
    var prevDayData = await database
        .selectRecord('${_utility.year}-${_utility.month}-${_utility.day}');
    _utility.makeTotal(prevDayData[0]);
    var _prevDayTotal = _utility.total;
    _onedaySpend = (_prevDayTotal - _onedayTotal);
    //-------------------------------//前日の合計値

    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
  * 画面遷移（指定日）
  */
  _goAnotherDate(BuildContext context, String date) {
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
  * 画面遷移（DetailDisplayScreen）
  */
  _goDetailDisplayScreen(BuildContext context, String date) async {
    //①　当日データ
    //②　前日データ
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
}
