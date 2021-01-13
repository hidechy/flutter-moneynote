import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

import '../db/database.dart';
import '../utilities/utility.dart';

class BenefitInputScreen extends StatefulWidget {
  final String date;
  BenefitInputScreen({@required this.date});

  @override
  _BenefitInputScreenState createState() => _BenefitInputScreenState();
}

class _BenefitInputScreenState extends State<BenefitInputScreen> {
  Utility _utility = Utility();

  String _text = '';
  TextEditingController _teContCompany = TextEditingController();
  TextEditingController _teContPrice = TextEditingController();

  String _dialogSelectedDate = "";

  bool _updateFlag = false;

  List<Map<dynamic, dynamic>> _benefitData = List();

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
    _dialogSelectedDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    //レコード取得
    var _benefit = await database.selectBenefitRecord(_dialogSelectedDate);
    if (_benefit.length > 0) {
      _teContCompany = new TextEditingController(text: _benefit[0].strCompany);
      _teContPrice = new TextEditingController(text: _benefit[0].strPrice);

      _updateFlag = true;
    }

    //リストデータ取得
    var benefits = await database.selectBenefitSortedAllRecord;
    if (benefits.length > 0) {
      for (int i = 0; i < benefits.length; i++) {
        var _map = Map();
        _map['date'] = benefits[i].strDate;
        _map['company'] = benefits[i].strCompany;
        _map['price'] = benefits[i].strPrice;

        _benefitData.add(_map);
      }
    }

    _teContCompany = new TextEditingController(text: '');
    _teContPrice = new TextEditingController(text: '0');

    setState(() {});
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Benefit'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  children: <Widget>[
                    _getTextField(
                        text: 'company',
                        con: _teContCompany,
                        valueAlign: 'left'),
                    _getTextField(
                        text: 'price', con: _teContPrice, valueAlign: 'right'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'reload',
                          onPressed: () => _goBenefitInputScreen(
                              context: context, date: widget.date),
                          color: Colors.blueAccent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'jump',
                          onPressed: () => _showDatepicker(context: context),
                          color: Colors.blueAccent,
                        ),
                        Text(_dialogSelectedDate),
                        IconButton(
                          icon: const Icon(Icons.input),
                          tooltip: 'input',
                          onPressed: () => _insertRecord(context: context),
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _benefitList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
  * リスト表示
  */
  Widget _benefitList() {
    return ListView.builder(
      itemCount: _benefitData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
  * リストアイテム表示
  */
  Widget _listItem({int position}) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: Card(
        color: Colors.black.withOpacity(0.3),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: DefaultTextStyle(
            style: TextStyle(fontSize: 10.0),
            child: Table(
              children: [
                TableRow(
                  children: [
                    _getDisplayContainer(position: position, column: 'date'),
                    _getDisplayContainer(position: position, column: 'company'),
                    _getDisplayContainer(position: position, column: 'price'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      //actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.black.withOpacity(0.3),
          foregroundColor: Colors.blueAccent,
          icon: Icons.delete,
          onTap: () => _deleteRecord(position: position),
        ),
      ],
    );
  }

  /**
  * データコンテナ表示
  */
  Widget _getDisplayContainer({int position, String column}) {
    return Container(
      alignment: (column == 'price') ? Alignment.topRight : Alignment.topLeft,
      child: Text(
        _getDisplayText(text: _benefitData[position][column], column: column),
      ),
    );
  }

  /**
   * 表示テキスト取得
   */
  String _getDisplayText({String text, String column}) {
    switch (column) {
      case 'date':
        _utility.makeYMDYData(text, 0);
        return '${text}（${_utility.youbiStr}）';
        break;
      case 'company':
        return text;
        break;
      case 'price':
        return _utility.makeCurrencyDisplay(text);
        break;
    }
  }

  /**
  * テキストフィールド部分表示
  */
  Widget _getTextField(
      {String text, TextEditingController con, String valueAlign}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: TextStyle(fontSize: 10),
        keyboardType:
            (valueAlign == 'right') ? TextInputType.number : TextInputType.text,
        controller: con,
        textAlign: (valueAlign == 'right') ? TextAlign.end : TextAlign.start,
        decoration: InputDecoration(labelText: text),
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

      //レコード取得
      var _benefit = await database.selectBenefitRecord(_dialogSelectedDate);
      if (_benefit.length > 0) {
        _teContCompany =
            new TextEditingController(text: _benefit[0].strCompany);
        _teContPrice = new TextEditingController(text: _benefit[0].strPrice);

        _updateFlag = true;
      }

      setState(() {});
    }
  }

  /**
  * データ作成/更新
  */
  void _insertRecord({BuildContext context}) async {
    if (_teContCompany.text == '') {
      Toast.show('companyが入力されていないため登録できません。', context,
          duration: Toast.LENGTH_LONG);
      return;
    }

    if (_teContPrice.text == '0') {
      Toast.show('priceが入力されていないため登録できません。', context,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var benefit = Benefit(
      strDate: _dialogSelectedDate,
      strCompany: _teContCompany.text,
      strPrice: _teContPrice.text,
    );

    if (_updateFlag == false) {
      await database.insertBenefitRecord(benefit);
      Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    } else {
      await database.updateBenefitRecord(benefit);
      Toast.show('更新が完了しました', context, duration: Toast.LENGTH_LONG);
    }

    _goBenefitInputScreen(context: context, date: widget.date);
  }

  /**
  * データ削除
  */
  void _deleteRecord({int position}) async {
    var benefit = Benefit(
      strDate: _benefitData[position]['date'],
      strCompany: _benefitData[position]['company'],
      strPrice: _benefitData[position]['price'],
    );

    await database.deleteBenefitRecord(benefit);
    Toast.show('データを削除しました', context, duration: Toast.LENGTH_LONG);
    _goBenefitInputScreen(context: context, date: widget.date);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
  * 画面遷移（BenefitInputScreen）
  */
  void _goBenefitInputScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BenefitInputScreen(
          date: date,
        ),
      ),
    );
  }
}
