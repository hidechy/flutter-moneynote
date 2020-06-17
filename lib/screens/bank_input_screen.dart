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
          case 'pay_a':
            _value = int.parse(_monieData[i].strPayA);
            break;
          case 'pay_b':
            _value = int.parse(_monieData[i].strPayB);
            break;
        }

        var _diffMark = (_prevValue != _value) ? 1 : 0;
        _bankData.add(
            [_monieData[i].strDate, _value.toString(), _diffMark.toString()]);
        _prevValue = _value;

        _lastRecordDate = _monieData[i].strDate;
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
          'Bank Input',
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
                        _getChoiceChip('pay_a'),
                        _getChoiceChip('pay_b'),
                      ],
                    ),
                    const Divider(
                      color: Colors.indigo,
                      height: 20.0,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            '${_chipValue}',
                            style: TextStyle(
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    )
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
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: Card(
          color: Colors.black.withOpacity(0.3),
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

        //actions: <Widget>[],
        secondaryActions: <Widget>[
          IconSlideAction(
            color: Colors.black.withOpacity(0.3),
            foregroundColor: Colors.blueAccent,
            icon: Icons.check,
            onTap: () => _dayPickup(position),
          ),
        ],
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        backgroundColor: Colors.black,
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
            strBankA: (_chipValue == 'bank_a')
                ? _teContPrice.text
                : record[0].strBankA,
            strBankB: (_chipValue == 'bank_b')
                ? _teContPrice.text
                : record[0].strBankB,
            strBankC: (_chipValue == 'bank_c')
                ? _teContPrice.text
                : record[0].strBankC,
            strBankD: (_chipValue == 'bank_d')
                ? _teContPrice.text
                : record[0].strBankD,
            strPayA:
                (_chipValue == 'pay_a') ? _teContPrice.text : record[0].strPayA,
            strPayB: (_chipValue == 'pay_b')
                ? _teContPrice.text
                : record[0].strPayB);

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
