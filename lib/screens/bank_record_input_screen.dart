import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

import '../db/database.dart';
import '../utilities/utility.dart';

class CreditRecordInputScreen extends StatefulWidget {
  final String date;
  final String searchitem;
  CreditRecordInputScreen({@required this.date, this.searchitem});

  @override
  _CreditRecordInputScreenState createState() =>
      _CreditRecordInputScreenState();
}

class _CreditRecordInputScreenState extends State<CreditRecordInputScreen> {
  List<List<String>> _creditData = List();

  Utility _utility = Utility();
  String _dialogSelectedDate = "";

  List<DropdownMenuItem<String>> _bankItems = List();

  String _numberOfMenu = '';

  String _chipValue = 'bank_a';

  String _text = '';
  TextEditingController _teContPrice = TextEditingController();

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
      credits = await database.selectCreditSortedAllRecord;
    } else {
      credits = await database.selectCreditItemRecord(widget.searchitem);
    }

    if (credits != null) {
      for (int i = 0; i < credits.length; i++) {
        _creditData.add([
          credits[i].intId.toString(),
          credits[i].strDate,
          credits[i].strBank,
          credits[i].strItem,
          credits[i].strPrice,
        ]);
      }
    }

    _teContPrice.text = '0';

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
  Widget _getChoiceChip(String _selectedChip) {
    return Padding(
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
                              onChanged: (value) => _makeCreditItemList(value),
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
                            onPressed: () =>
                                _searchRecord(context, widget.date),
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
                          onPressed: () =>
                              _goCreditRecordInputScreen(context, widget.date),
                          color: Colors.blueAccent,
                        ),
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
                          onPressed: () => _insertRecord(context),
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
  _makeCreditItemList(value) async {
    //プルダウンに選択された日付を表示する
    _numberOfMenu = value;

    setState(() {});
  }

  /**
  * リスト表示
  */
  _creditList() {
    return ListView.builder(
      itemCount: _creditData.length,
      itemBuilder: (context, int position) => _listItem(position),
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
            title: DefaultTextStyle(
              style: TextStyle(fontSize: 10.0),
              child: Table(
                children: [
                  TableRow(children: [
                    _getDisplayContainer(position, 1),
                    _getDisplayContainer(position, 3),
                    _getDisplayContainer(position, 4),
                    _getDisplayContainer(position, 2),
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
            onTap: () => _deleteRecord(position),
          ),
        ],
      ),
    );
  }

  /**
  * データコンテナ表示
  */
  Widget _getDisplayContainer(int position, int column) {
    return Container(
      alignment:
          (column == 4 || column == 2) ? Alignment.topRight : Alignment.topLeft,
      child: (column == 4)
          ? Text(_utility.makeCurrencyDisplay(_creditData[position][column]))
          : Text(_creditData[position][column]),
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
  * データ作成/更新
  */
  _insertRecord(BuildContext context) async {
    if (_teContPrice.text == '0') {
      Toast.show('金額が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    if (_numberOfMenu == '') {
      Toast.show('勘定科目が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    var _credit = Credit(
        strDate: _dialogSelectedDate,
        strBank: _chipValue,
        strItem: _numberOfMenu,
        strPrice: _teContPrice.text);

    await database.insertCreditRecord(_credit);
    Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    _goCreditRecordInputScreen(context, widget.date);
  }

  /**
  * データ削除
  */
  _deleteRecord(int position) async {
    var credit = Credit(
        intId: int.parse(_creditData[position][0]),
        strDate: _creditData[position][1],
        strBank: _creditData[position][2],
        strItem: _creditData[position][3],
        strPrice: _creditData[position][4]);

    await database.deleteCreditIdRecord(credit);
    Toast.show('データを削除しました', context, duration: Toast.LENGTH_LONG);
    _goCreditRecordInputScreen(context, widget.date);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
  * データ検索
  */
  _searchRecord(BuildContext context, String date) {
    if (_numberOfMenu == '') {
      Toast.show('勘定科目が入力されていません', context, duration: Toast.LENGTH_LONG);
      return false;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditRecordInputScreen(
          date: date,
          searchitem: _numberOfMenu,
        ),
      ),
    );
  }

  /**
  * 画面遷移（CreditRecordInputScreen）
  */
  _goCreditRecordInputScreen(BuildContext context, String date) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditRecordInputScreen(
          date: date,
          searchitem: null,
        ),
      ),
    );
  }
}
