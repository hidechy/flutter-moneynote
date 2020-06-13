import 'package:flutter/material.dart';
import 'detail_display_screen.dart';
import 'package:toast/toast.dart';
import '../db/database.dart';
import '../main.dart';
import '../utilities/utility.dart';

class BankInputScreen extends StatefulWidget {
  final String date;
  BankInputScreen({@required this.date});

  @override
  _BankInputScreenState createState() => _BankInputScreenState();
}

class _BankInputScreenState extends State<BankInputScreen> {
  Utility _utility = Utility();
  String year;
  String month;
  String day;

  String _date;

  String _dialogSelectedDate = "";

  Monie _bankData;
  String _bankA = "";
  String _bankB = "";
  String _bankC = "";
  String _bankD = "";
  String _payA = "";
  String _payB = "";

  TextEditingController _teContBank = TextEditingController();

  var _isContinue = false;

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

    _dialogSelectedDate = year + "-" + month + "-01";

    //////////////////////////////
    var val = await database.selectSortedAllRecord;
    if (val.length > 0) {
      for (int i = 0; i < val.length; i++) {
        _bankData = val[i];
      }

      _date = _bankData.strDate;
      _bankA = _bankData.strBankA;
      _bankB = _bankData.strBankB;
      _bankC = _bankData.strBankC;
      _bankD = _bankData.strBankD;
      _payA = _bankData.strPayA;
      _payB = _bankData.strPayB;
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
          '${_date}',
          style: const TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
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
              color: Colors.black.withOpacity(0.3),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 16.0, fontFamily: "Yomogi"),
                child: Column(
                  children: <Widget>[
                    Table(
                      children: [
                        _displayBankRecord('BankA', _bankA),
                        _displayBankRecord('BankB', _bankB),
                        _displayBankRecord('BankC', _bankC),
                        _displayBankRecord('BankD', _bankD),
                        _displayBankRecord('PayA', _payA),
                        _displayBankRecord('PayB', _payB),
                      ],
                    ),
                    const Divider(
                      color: Colors.indigo,
                      height: 20.0,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _showDatepicker(context),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(_dialogSelectedDate),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _teContBank,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: const Text('Update'),
                          onPressed: () => _bankDataUpdate(),
                        ),
                        Checkbox(
                          value: _isContinue,
                          onChanged: (value) {
                            setState(() {
                              _isContinue = value;
                            });
                          },
                        ),
                        const Text('Continue'),
                        const SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          icon: const Icon(Icons.star),
                          onPressed: () => _goDetailScreen(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 入力部品表示
   */
  _displayBankRecord(String _bankName, String _bankValue) {
    return TableRow(children: [
      new Radio(
        value: _bankName,
        groupValue: _radioValue,
        onChanged: _radioChange,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(_bankName),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(_bankValue),
      ),
      const Align(),
    ]);
  }

  /**
   * ラジオボタンの挙動
   */
  String _radioValue = '';
  void _radioChange(String e) => setState(
        () {
          _radioValue = e;
        },
      );

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
      _utility.makeYMDYData(selectedDate.toString(), 0);
      year = _utility.year;
      month = _utility.month;
      day = _utility.day;

      _dialogSelectedDate = year + "-" + month + "-" + day;

      setState(() {});
    }
  }

  /**
   * バンクデータ更新
   */
  _bankDataUpdate() async {
    if (_radioValue.length == 0) {
      Toast.show('Bankが選択されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    if (_teContBank.text.length == 0) {
      Toast.show('金額が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    //-----------------------------------------//
    _utility.makeYMDYData(_dialogSelectedDate.toString(), 0);
    var baseYear = _utility.year;
    var baseMonth = _utility.month;
    var baseDay = _utility.day;

    int diffDays = DateTime.parse(_date)
        .difference(DateTime.parse(_dialogSelectedDate))
        .inDays;

    List<String> _upDates = List();
    for (int i = 0; i <= diffDays; i++) {
      var genDate = new DateTime(
          int.parse(baseYear), int.parse(baseMonth), (int.parse(baseDay) + i));

      _utility.makeYMDYData(genDate.toString(), 0);
      var genYear = _utility.year;
      var genMonth = _utility.month;
      var genDay = _utility.day;

      _upDates.add(genYear + "-" + genMonth + "-" + genDay);
    }
    //-----------------------------------------//

    for (int i = 0; i < _upDates.length; i++) {
      var record = await database.selectRecord(_upDates[i]);

      if (record.length > 0) {
        var monie = Monie(
            strDate: _upDates[i],
            strYen10000: record[0].strYen10000,
            strYen5000: record[0].strYen5000,
            strYen2000: record[0].strYen2000,
            strYen1000: record[0].strYen1000,
            strYen500: record[0].strYen500,
            strYen100: record[0].strYen100,
            strYen50: record[0].strYen50,
            strYen10: record[0].strYen10,
            strYen5: record[0].strYen5,
            strYen1: record[0].strYen1,
            strBankA: (_radioValue == 'BankA')
                ? _teContBank.text
                : record[0].strBankA,
            strBankB: (_radioValue == 'BankB')
                ? _teContBank.text
                : record[0].strBankB,
            strBankC: (_radioValue == 'BankC')
                ? _teContBank.text
                : record[0].strBankC,
            strBankD: (_radioValue == 'BankD')
                ? _teContBank.text
                : record[0].strBankD,
            strPayA:
                (_radioValue == 'PayA') ? _teContBank.text : record[0].strPayA,
            strPayB:
                (_radioValue == 'PayB') ? _teContBank.text : record[0].strPayB);

        await database.updateRecord(monie);
      }
    } //for

    if (_isContinue == true) {
      _goBankInputScreen();
    } else {
      _goDetailScreen();
    }
  }

  /**
   * 画面遷移（自画面）
   */
  void _goBankInputScreen() {
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
   * 画面遷移（DetailDisplayScreen）
   */
  void _goDetailScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: _date,
        ),
      ),
    );
  }
}
