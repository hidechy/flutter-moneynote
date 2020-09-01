import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

import '../db/database.dart';
import '../utilities/utility.dart';

class DepositInputScreen extends StatefulWidget {
  final String date;
  final String searchitem;
  DepositInputScreen({@required this.date, this.searchitem});

  @override
  _DepositInputScreenState createState() => _DepositInputScreenState();
}

class _DepositInputScreenState extends State<DepositInputScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _creditData = List();

  String _dialogSelectedDate = "";

  List<DropdownMenuItem<String>> _bankItems = List();

  String _numberOfMenu = '';

  String _chipValue = 'bank_a';

  String _text = '';
  TextEditingController _teContPrice = TextEditingController();

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
    _dialogSelectedDate = widget.date;

//------------------------------------//プルダウンデータ取得
    var _items;
    await loadAsset('assets/file/bankitems.txt').then((dynamic output) {
      _items = output;
    });
    var _explodedItems = _items.toString().split('|');

    _bankItems.add(
      DropdownMenuItem(
        value: '',
        child: Container(
          child: Text(''),
          width: 50,
        ),
      ),
    );

    for (int i = 0; i < _explodedItems.length; i++) {
      _bankItems.add(
        DropdownMenuItem(
          value: _explodedItems[i],
          child: Container(
            child: Text(_explodedItems[i]),
          ),
        ),
      );
    }

    _numberOfMenu = _bankItems[0].value;

    //------------------------------------//リストデータ取得
    var credits = null;
    if (widget.searchitem == null) {
      credits = await database.selectDepositSortedAllRecord;
    } else {
      credits = await database.selectDepositItemRecord(widget.searchitem);
    }

    if (credits != null) {
      for (int i = 0; i < credits.length; i++) {
        var _map = Map();
        _map['id'] = credits[i].intId.toString();
        _map['date'] = credits[i].strDate;
        _map['bank'] = credits[i].strBank;
        _map['item'] = credits[i].strItem;
        _map['price'] = credits[i].strPrice;

        _creditData.add(_map);
      }
    }

    _teContPrice.text = '0';

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
  * ファイル読み込み
  */
  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
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
      child: ChoiceChip(
        backgroundColor: (btnActive)
            ? Colors.greenAccent.withOpacity(0.5)
            : Colors.blueAccent.withOpacity(0.1),
        label: Text(
          selectedChip,
          style: const TextStyle(color: Colors.white),
        ),
        selected: _chipValue == selectedChip,
        onSelected: (bool isSelected) {
          _chipValue = selectedChip;
          setState(() {});
        },
      ),
    );
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通帳履歴'),
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
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.yellowAccent.withOpacity(0.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: DropdownButton(
                              items: _bankItems,
                              value: _numberOfMenu,
                              onChanged: (value) =>
                                  _makeCreditItemList(value: value),
                            ),
                          ),
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'で検索可能',
                                  style: TextStyle(color: Colors.yellowAccent),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.yellowAccent,
                                ),
                              ],
                            ),
                            onPressed: () => _searchRecord(
                                context: context, date: widget.date),
                          ),
                        ],
                      ),
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
                          icon: const Icon(Icons.refresh),
                          tooltip: 'reload',
                          onPressed: () => _goCreditRecordInputScreen(
                              context: context, date: widget.date),
                          color: Colors.blueAccent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'jump',
                          onPressed: () => _showDatepicker(context: context),
                          color: Colors.blueAccent,
                        ),
                        Text('${_dialogSelectedDate}'),
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
                child: _creditList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
  * プルダウン変更処理
  */
  void _makeCreditItemList({value}) async {
    //プルダウンに選択された日付を表示する
    _numberOfMenu = value;

    setState(() {});
  }

  /**
  * リスト表示
  */
  Widget _creditList() {
    return ListView.builder(
      itemCount: _creditData.length,
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
                TableRow(children: [
                  _getDisplayContainer(position: position, column: 'date'),
                  _getDisplayContainer(position: position, column: 'item'),
                  _getDisplayContainer(position: position, column: 'price'),
                  _getDisplayContainer(position: position, column: 'bank'),
                ]),
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
      alignment: (column == 'price' || column == 'bank')
          ? Alignment.topRight
          : Alignment.topLeft,
      child: (column == 'price')
          ? Text(_utility.makeCurrencyDisplay(_creditData[position][column]))
          : Text(_creditData[position][column]),
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
  * データ作成/更新
  */
  dynamic _insertRecord({BuildContext context}) async {
    if (_teContPrice.text == '0') {
      Toast.show('金額が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    if (_numberOfMenu == '') {
      Toast.show('勘定科目が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    var _credit = Deposit(
        strDate: _dialogSelectedDate,
        strBank: _chipValue,
        strItem: _numberOfMenu,
        strPrice: _teContPrice.text);

    await database.insertDepositRecord(_credit);
    Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    _goCreditRecordInputScreen(context: context, date: widget.date);
  }

  /**
  * データ削除
  */
  void _deleteRecord({int position}) async {
    var credit = Deposit(
        intId: int.parse(_creditData[position]['id']),
        strDate: _creditData[position]['date'],
        strBank: _creditData[position]['bank'],
        strItem: _creditData[position]['item'],
        strPrice: _creditData[position]['price']);

    await database.deleteDepositIdRecord(credit);
    Toast.show('データを削除しました', context, duration: Toast.LENGTH_LONG);
    _goCreditRecordInputScreen(context: context, date: widget.date);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
  * データ検索
  */
  dynamic _searchRecord({BuildContext context, String date}) {
    if (_numberOfMenu == '') {
      Toast.show('勘定科目が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DepositInputScreen(
          date: date,
          searchitem: _numberOfMenu,
        ),
      ),
    );
  }

  /**
  * 画面遷移（CreditRecordInputScreen）
  */
  void _goCreditRecordInputScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DepositInputScreen(
          date: date,
          searchitem: null,
        ),
      ),
    );
  }
}
