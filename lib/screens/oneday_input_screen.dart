import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../db/database.dart';
import '../main.dart';
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

  TextEditingController _teContPayA = TextEditingController();
  TextEditingController _teContPayB = TextEditingController();

  bool _updateFlag = false;

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

      _teContPayA = new TextEditingController(text: _monieData[0].strPayA);
      _teContPayB = new TextEditingController(text: _monieData[0].strPayB);

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

      _teContPayA = new TextEditingController(text: '0');
      _teContPayB = new TextEditingController(text: '0');
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
          _date + '(' + youbiStr + ')',
          style: TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goPrevDate(context),
          ),
          IconButton(
            icon: Icon(Icons.skip_next),
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
          SingleChildScrollView(
            child: Card(
              color: Colors.black.withOpacity(0.7),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Table(
                    children: [
                      TableRow(children: [
                        _getDisplayYen('10000'),
                        _getDisplayYen('5000'),
                        _getDisplayYen('2000'),
                        _getDisplayYen('1000'),
                      ]),
                      TableRow(children: [
                        _getTextField(_teCont10000),
                        _getTextField(_teCont5000),
                        _getTextField(_teCont2000),
                        _getTextField(_teCont1000),
                      ]),
                      TableRow(children: [
                        _getDisplayYen('500'),
                        _getDisplayYen('100'),
                        _getDisplayYen('50'),
                        _getDisplayYen('10'),
                      ]),
                      TableRow(children: [
                        _getTextField(_teCont500),
                        _getTextField(_teCont100),
                        _getTextField(_teCont50),
                        _getTextField(_teCont10),
                      ]),
                      TableRow(children: [
                        _getDisplayYen('5'),
                        _getDisplayYen('1'),
                        Align(),
                        Align(),
                      ]),
                      TableRow(children: [
                        _getTextField(_teCont5),
                        _getTextField(_teCont1),
                        Align(),
                        Align(),
                      ]),
                      TableRow(children: [
                        _getDisplayYen('BankA'),
                        _getDisplayYen('BankB'),
                        _getDisplayYen('BankC'),
                        _getDisplayYen('BankD'),
                      ]),
                      TableRow(children: [
                        _getTextField(_teContBankA),
                        _getTextField(_teContBankB),
                        _getTextField(_teContBankC),
                        _getTextField(_teContBankD),
                      ]),
                      TableRow(children: [
                        _getDisplayYen('PayA'),
                        _getDisplayYen('PayB'),
                        Align(),
                        Align(),
                      ]),
                      TableRow(children: [
                        _getTextField(_teContPayA),
                        _getTextField(_teContPayB),
                        Align(),
                        Align(),
                      ]),
                      TableRow(
                        children: [
                          Align(
                            child: RaisedButton(
                              child: Text('list'),
                              color: Colors.green,
                              onPressed: () => _goMonthlyScreen(),
                            ),
                          ),
                          Align(
                            child: RaisedButton(
                              child: Text('detail'),
                              color: Colors.green,
                              onPressed: () => _goDetailScreen(),
                            ),
                          ),
                          Align(
                            child: RaisedButton(
                              child: Text('jump'),
                              color: Colors.green,
                              onPressed: () => _showDatepicker(context),
                            ),
                          ),
                          Align(
                            child: RaisedButton(
                              child: Text('input'),
                              onPressed: () => _insertRecord(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * テキスト部分表示
   */
  Widget _getDisplayYen(String yen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        yen,
        style: TextStyle(
          color: Colors.yellowAccent,
        ),
      ),
    );
  }

  /**
   * テキストフィールド部分表示
   */
  Widget _getTextField(TextEditingController con) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: con,
        textAlign: TextAlign.end,
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
        builder: (context) => OnedayInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（MonthlyListScreen）
   */
  _goMonthlyScreen() {
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
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: _date,
        ),
      ),
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
        strBankA: _teContBankA.text != "" ? _teContBankA.text : '0',
        strBankB: _teContBankB.text != "" ? _teContBankB.text : '0',
        strBankC: _teContBankC.text != "" ? _teContBankC.text : '0',
        strBankD: _teContBankD.text != "" ? _teContBankD.text : '0',
        strPayA: _teContPayA.text != "" ? _teContPayA.text : '0',
        strPayB: _teContPayB.text != "" ? _teContPayB.text : '0');

    if (_updateFlag == false) {
      await database.insertRecord(monie);
      Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    } else {
      await database.updateRecord(monie);
      Toast.show('更新が完了しました', context, duration: Toast.LENGTH_LONG);
    }

    _makeDefaultDisplayData();
  }
}
