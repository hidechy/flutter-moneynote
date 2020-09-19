import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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
  Utility _utility = Utility();

  String _chipValue = 'bank_a';

  String _dialogSelectedDate = "";

  List<Map<dynamic, dynamic>> _bankData = List();

  String _text = '';
  TextEditingController _teContPrice = TextEditingController();

  String _lastRecordDate;

  Map _dispFlag = Map();

  Map<String, dynamic> _holidayList = Map();

  Map<String, String> bankNames = Map();

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

    _dialogSelectedDate = '${_utility.year}-${_utility.month}-01';

    _teContPrice.text = '0';

    _getBankValue();
  }

  /**
   * 表示データ作成
   */
  void _getBankValue() async {
    var _monieData = await database.selectSortedAllRecord;
    int _value = 0;
    int _prevValue = 0;
    if (_monieData.length > 0) {
      _bankData = List();
      for (int i = 0; i < _monieData.length; i++) {
        _dispFlag['bank_a'] = _makeDispFlag(
            value: _monieData[i].strBankA, nowFlag: _dispFlag['bank_a']);
        _dispFlag['bank_b'] = _makeDispFlag(
            value: _monieData[i].strBankB, nowFlag: _dispFlag['bank_b']);
        _dispFlag['bank_c'] = _makeDispFlag(
            value: _monieData[i].strBankC, nowFlag: _dispFlag['bank_c']);
        _dispFlag['bank_d'] = _makeDispFlag(
            value: _monieData[i].strBankD, nowFlag: _dispFlag['bank_d']);
        _dispFlag['bank_e'] = _makeDispFlag(
            value: _monieData[i].strBankE, nowFlag: _dispFlag['bank_e']);
        _dispFlag['bank_f'] = _makeDispFlag(
            value: _monieData[i].strBankF, nowFlag: _dispFlag['bank_f']);
        _dispFlag['bank_g'] = _makeDispFlag(
            value: _monieData[i].strBankG, nowFlag: _dispFlag['bank_g']);
        _dispFlag['bank_h'] = _makeDispFlag(
            value: _monieData[i].strBankH, nowFlag: _dispFlag['bank_h']);

        _dispFlag['pay_a'] = _makeDispFlag(
            value: _monieData[i].strPayA, nowFlag: _dispFlag['pay_a']);
        _dispFlag['pay_b'] = _makeDispFlag(
            value: _monieData[i].strPayB, nowFlag: _dispFlag['pay_b']);
        _dispFlag['pay_c'] = _makeDispFlag(
            value: _monieData[i].strPayC, nowFlag: _dispFlag['pay_c']);
        _dispFlag['pay_d'] = _makeDispFlag(
            value: _monieData[i].strPayD, nowFlag: _dispFlag['pay_d']);
        _dispFlag['pay_e'] = _makeDispFlag(
            value: _monieData[i].strPayE, nowFlag: _dispFlag['pay_e']);
        _dispFlag['pay_f'] = _makeDispFlag(
            value: _monieData[i].strPayF, nowFlag: _dispFlag['pay_f']);
        _dispFlag['pay_g'] = _makeDispFlag(
            value: _monieData[i].strPayG, nowFlag: _dispFlag['pay_g']);
        _dispFlag['pay_h'] = _makeDispFlag(
            value: _monieData[i].strPayH, nowFlag: _dispFlag['pay_h']);

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

        var _map = Map();
        _map['date'] = _monieData[i].strDate;
        _map['value'] = _value.toString();
        _map['diffMark'] = _diffMark.toString();
        _map['youbiNo'] = _utility.youbiNo.toString();

        _bankData..add(_map);

        _prevValue = _value;

        _lastRecordDate = _monieData[i].strDate;
      }
    }

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    ///////////////////////////////////////////////////////////////////
    var values = await database.selectBanknameSortedAllRecord;

    if (values.length > 0) {
      for (int i = 0; i < values.length; i++) {
        bankNames[values[i].strBank] = values[i].strName;
      }
    }

    setState(() {});
  }

  /**
   * 表示フラグ作成
   */
  int _makeDispFlag({String value, int nowFlag}) {
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('銀行預金'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: Colors.greenAccent,
                    onPressed: () => _goBankInputScreen(context),
                  ),
                ],
                backgroundColor: Colors.black.withOpacity(0.1),
                pinned: true,
                expandedHeight: 370,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.black.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _getChoiceChip(selectedChip: 'bank_a'),
                              _getChoiceChip(selectedChip: 'bank_b'),
                              _getChoiceChip(selectedChip: 'bank_c'),
                              _getChoiceChip(selectedChip: 'bank_d'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _getChoiceChip(selectedChip: 'bank_e'),
                              _getChoiceChip(selectedChip: 'bank_f'),
                              _getChoiceChip(selectedChip: 'bank_g'),
                              _getChoiceChip(selectedChip: 'bank_h'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _getChoiceChip(selectedChip: 'pay_a'),
                              _getChoiceChip(selectedChip: 'pay_b'),
                              _getChoiceChip(selectedChip: 'pay_c'),
                              _getChoiceChip(selectedChip: 'pay_d'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _getChoiceChip(selectedChip: 'pay_e'),
                              _getChoiceChip(selectedChip: 'pay_f'),
                              _getChoiceChip(selectedChip: 'pay_g'),
                              _getChoiceChip(selectedChip: 'pay_h'),
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
                                onPressed: () =>
                                    _showDatepicker(context: context),
                                color: Colors.blueAccent,
                              ),
                              Text('${_dialogSelectedDate}'),
                              IconButton(
                                icon: const Icon(Icons.input),
                                tooltip: 'input',
                                onPressed: () =>
                                    _updateRecord(context: context),
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, position) => _listItem(position: position),
                  childCount: _bankData.length,
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
  Widget _listItem({int position}) {
    return Card(
      color: getBgColor(_bankData[position]['date']),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: _getLeading(mark: _bankData[position]['diffMark']),
        title: Text(
          '${_bankData[position]['date']}　${_utility.makeCurrencyDisplay(_bankData[position]['value'])}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
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
   * リーディングマーク取得
   */
  Widget _getLeading({String mark}) {
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
  Widget _getChoiceChip({String selectedChip}) {
    var dispBank = selectedChip;
    var btnActive = false;
    if (bankNames[selectedChip] != "" && bankNames[selectedChip] != null) {
      dispBank = bankNames[selectedChip];
      btnActive = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: (btnActive)
          ? ChoiceChip(
              backgroundColor: Colors.greenAccent.withOpacity(0.5),
              label: Text(
                '${dispBank}',
                style: TextStyle(color: Colors.white),
              ),
              selected: _chipValue == selectedChip,
              onSelected: (bool isSelected) {
                _chipValue = selectedChip;
                _getBankValue();
              },
            )
          : ChoiceChip(
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
              label: Text(
                '${dispBank}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              selected: _chipValue == selectedChip,
              onSelected: null,
            ),
    );
  }

  /**
   * デートピッカー表示
   */
  void _showDatepicker({BuildContext context}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            backgroundColor: Colors.black.withOpacity(0.1),
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            cursorColor: Colors.white,
            buttonColor: Colors.black.withOpacity(0.1),
            bottomAppBarColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            accentColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            textSelectionColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            selectedRowColor: Colors.black.withOpacity(0.1),
          ),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      _utility.makeYMDYData(selectedDate.toString(), 0);
      _dialogSelectedDate =
          '${_utility.year}-${_utility.month}-${_utility.day}';
      setState(() {});
    }
  }

  /**
   * レコード更新
   */
  dynamic _updateRecord({BuildContext context}) async {
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
      _upDates.add('${_utility.year}-${_utility.month}-${_utility.day}');
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

  _goBankInputScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BankInputScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
