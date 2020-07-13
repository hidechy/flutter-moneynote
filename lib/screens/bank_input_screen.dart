import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

import '../utilities/utility.dart';
import '../db/database.dart';

class BankInputScreen extends StatefulWidget {
  final String date;
  BankInputScreen({@required this.date});

  @override
  _BankInputScreenState createState() => _BankInputScreenState();
}

class _BankInputScreenState extends State<BankInputScreen> {
  String _chipValue = 'bank_a';

  Utility _utility = Utility();
  String year;
  String month;
  String day;

  String _date;

  String _dialogSelectedDate = "";

  List<List<String>> _bankData = List();

  String _text = '';
  TextEditingController _teContPrice = TextEditingController();

  String _lastRecordDate;

  Map _dispFlag = Map();

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

    _teContPrice.text = '0';

    _getBankValue();
  }

  /**
  * 表示データ作成
  */
  _getBankValue() async {
    var _monieData = await database.selectSortedAllRecord;
    int _value = 0;
    int _prevValue = 0;
    if (_monieData.length > 0) {
      _bankData = List();
      for (int i = 0; i < _monieData.length; i++) {
        _dispFlag['bank_a'] =
            _makeDispFlag(_monieData[i].strBankA, _dispFlag['bank_a']);
        _dispFlag['bank_b'] =
            _makeDispFlag(_monieData[i].strBankB, _dispFlag['bank_b']);
        _dispFlag['bank_c'] =
            _makeDispFlag(_monieData[i].strBankC, _dispFlag['bank_c']);
        _dispFlag['bank_d'] =
            _makeDispFlag(_monieData[i].strBankD, _dispFlag['bank_d']);
        _dispFlag['bank_e'] =
            _makeDispFlag(_monieData[i].strBankE, _dispFlag['bank_e']);
        _dispFlag['bank_f'] =
            _makeDispFlag(_monieData[i].strBankF, _dispFlag['bank_f']);
        _dispFlag['bank_g'] =
            _makeDispFlag(_monieData[i].strBankG, _dispFlag['bank_g']);
        _dispFlag['bank_h'] =
            _makeDispFlag(_monieData[i].strBankH, _dispFlag['bank_h']);

        _dispFlag['pay_a'] =
            _makeDispFlag(_monieData[i].strPayA, _dispFlag['pay_a']);
        _dispFlag['pay_b'] =
            _makeDispFlag(_monieData[i].strPayB, _dispFlag['pay_b']);
        _dispFlag['pay_c'] =
            _makeDispFlag(_monieData[i].strPayC, _dispFlag['pay_c']);
        _dispFlag['pay_d'] =
            _makeDispFlag(_monieData[i].strPayD, _dispFlag['pay_d']);
        _dispFlag['pay_e'] =
            _makeDispFlag(_monieData[i].strPayE, _dispFlag['pay_e']);
        _dispFlag['pay_f'] =
            _makeDispFlag(_monieData[i].strPayF, _dispFlag['pay_f']);
        _dispFlag['pay_g'] =
            _makeDispFlag(_monieData[i].strPayG, _dispFlag['pay_g']);
        _dispFlag['pay_h'] =
            _makeDispFlag(_monieData[i].strPayH, _dispFlag['pay_h']);

        switch (_chipValue) {
          case 'bank_a':
            _value = int.parse(_monieData[i].strBankA);
            break;
          case 'bank_b':
            _value = int.parse(_monieData[i].strBankB);
            break;
          case 'bank_c':
            _value = int.parse(_monieData[i].strBankC);
            break;
          case 'bank_d':
            _value = int.parse(_monieData[i].strBankD);
            break;
          case 'bank_e':
            _value = int.parse(_monieData[i].strBankE);
            break;
          case 'bank_f':
            _value = int.parse(_monieData[i].strBankF);
            break;
          case 'bank_g':
            _value = int.parse(_monieData[i].strBankG);
            break;
          case 'bank_h':
            _value = int.parse(_monieData[i].strBankH);
            break;

          case 'pay_a':
            _value = int.parse(_monieData[i].strPayA);
            break;
          case 'pay_b':
            _value = int.parse(_monieData[i].strPayB);
            break;
          case 'pay_c':
            _value = int.parse(_monieData[i].strPayC);
            break;
          case 'pay_d':
            _value = int.parse(_monieData[i].strPayD);
            break;
          case 'pay_e':
            _value = int.parse(_monieData[i].strPayE);
            break;
          case 'pay_f':
            _value = int.parse(_monieData[i].strPayF);
            break;
          case 'pay_g':
            _value = int.parse(_monieData[i].strPayG);
            break;
          case 'pay_h':
            _value = int.parse(_monieData[i].strPayH);
            break;
        }

        _utility.makeYMDYData(_monieData[i].strDate, 0);

        var _diffMark = (_prevValue != _value) ? 1 : 0;
        _bankData.add([
          _monieData[i].strDate,
          _value.toString(),
          _diffMark.toString(),
          _utility.youbiNo.toString()
        ]);
        _prevValue = _value;

        _lastRecordDate = _monieData[i].strDate;
      }
    }

    setState(() {});
  }

  /**
   * 表示フラグ作成
   */
  int _makeDispFlag(String value, int nowFlag) {
    if (nowFlag == 1) {
      return 1;
    }

    if (value == null) {
      return 0;
    } else {
      return (int.parse(value) > 0) ? 1 : 0;
    }
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '銀行預金',
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
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _getChoiceChip('bank_a'),
                        _getChoiceChip('bank_b'),
                        _getChoiceChip('bank_c'),
                        _getChoiceChip('bank_d'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _getChoiceChip('bank_e'),
                        _getChoiceChip('bank_f'),
                        _getChoiceChip('bank_g'),
                        _getChoiceChip('bank_h'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _getChoiceChip('pay_a'),
                        _getChoiceChip('pay_b'),
                        _getChoiceChip('pay_c'),
                        _getChoiceChip('pay_d'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _getChoiceChip('pay_e'),
                        _getChoiceChip('pay_f'),
                        _getChoiceChip('pay_g'),
                        _getChoiceChip('pay_h'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: TextField(
                        controller: _teContPrice,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        onChanged: (value) {
                          setState(
                            () {
                              _text = value;
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'jump',
                          onPressed: () => _showDatepicker(context),
                          color: Colors.blueAccent,
                        ),
                        Text('${_dialogSelectedDate}'),
                        IconButton(
                          icon: const Icon(Icons.input),
                          tooltip: 'input',
                          onPressed: () => _updateRecord(context),
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _bankData.length,
                  itemBuilder: (context, int position) => _listItem(position),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
  * リストアイテム表示
  */
  Widget _listItem(int position) {
    return InkWell(
      child: Card(
        color: _getBgColor(int.parse(_bankData[position][3])),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: _getLeading(_bankData[position][2]),
          title: Text(
            '${_bankData[position][0]}　${_bankData[position][1]}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Yomogi',
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  /**
   * 背景色取得
   */
  _getBgColor(int youbiNo) {
    switch (youbiNo) {
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
  * リーディングマーク取得
  */
  Widget _getLeading(String mark) {
    if (int.parse(mark) == 1) {
      return const Icon(
        Icons.refresh,
        color: Colors.greenAccent,
      );
    } else {
      return const Icon(
        Icons.check_box_outline_blank,
        color: Color(0xFF2e2e2e),
      );
    }
  }

  /**
  * チョイスチップ作成
  */
  Widget _getChoiceChip(String _selectedChip) {
    return (_dispFlag[_selectedChip] == 0)
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ChoiceChip(
              backgroundColor: Colors.blueAccent.withOpacity(0.5),
              label: Text(
                _selectedChip,
                style: const TextStyle(color: Colors.white),
              ),
              selected: _chipValue == _selectedChip,
              onSelected: (bool isSelected) {
                _chipValue = _selectedChip;
                _getBankValue();
              },
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
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
    );

    if (selectedDate != null) {
      _utility.makeYMDYData(selectedDate.toString(), 0);
      _dialogSelectedDate =
          _utility.year + "-" + _utility.month + "-" + _utility.day;
      setState(() {});
    }
  }

  /**
  * レコード更新
  */
  _updateRecord(BuildContext context) async {
    if (_teContPrice.text == '0') {
      Toast.show('金額が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    //----------------------------------//更新日付リスト作成
    List<String> _upDates = List();

    int diffDays = DateTime.parse(_lastRecordDate)
        .difference(DateTime.parse(_dialogSelectedDate))
        .inDays;

    _utility.makeYMDYData(_dialogSelectedDate.toString(), 0);
    var baseYear = _utility.year;
    var baseMonth = _utility.month;
    var baseDay = _utility.day;

    for (int i = 0; i <= diffDays; i++) {
      var genDate = new DateTime(
          int.parse(baseYear), int.parse(baseMonth), (int.parse(baseDay) + i));
      _utility.makeYMDYData(genDate.toString(), 0);
      _upDates.add(_utility.year + "-" + _utility.month + "-" + _utility.day);
    }
    //----------------------------------//更新日付リスト作成

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
          strBankA:
              (_chipValue == 'bank_a') ? _teContPrice.text : record[0].strBankA,
          strBankB:
              (_chipValue == 'bank_b') ? _teContPrice.text : record[0].strBankB,
          strBankC:
              (_chipValue == 'bank_c') ? _teContPrice.text : record[0].strBankC,
          strBankD:
              (_chipValue == 'bank_d') ? _teContPrice.text : record[0].strBankD,
          strBankE:
              (_chipValue == 'bank_e') ? _teContPrice.text : record[0].strBankE,
          strBankF:
              (_chipValue == 'bank_f') ? _teContPrice.text : record[0].strBankF,
          strBankG:
              (_chipValue == 'bank_g') ? _teContPrice.text : record[0].strBankG,
          strBankH:
              (_chipValue == 'bank_h') ? _teContPrice.text : record[0].strBankH,
          strPayA:
              (_chipValue == 'pay_a') ? _teContPrice.text : record[0].strPayA,
          strPayB:
              (_chipValue == 'pay_b') ? _teContPrice.text : record[0].strPayB,
          strPayC:
              (_chipValue == 'pay_c') ? _teContPrice.text : record[0].strPayC,
          strPayD:
              (_chipValue == 'pay_d') ? _teContPrice.text : record[0].strPayD,
          strPayE:
              (_chipValue == 'pay_e') ? _teContPrice.text : record[0].strPayE,
          strPayF:
              (_chipValue == 'pay_f') ? _teContPrice.text : record[0].strPayF,
          strPayG:
              (_chipValue == 'pay_g') ? _teContPrice.text : record[0].strPayG,
          strPayH:
              (_chipValue == 'pay_h') ? _teContPrice.text : record[0].strPayH,
        );

        await database.updateRecord(monie);
      }
    } //for[i]

    _teContPrice.text = '0';

    _getBankValue();
  }

  /**
  * リストからの日付選択
  */
  _dayPickup(int position) {
    _dialogSelectedDate = _bankData[position][0];
    setState(() {});
  }
}
