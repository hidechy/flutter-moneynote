import 'package:flutter/material.dart';

import '../main.dart';

import '../db/database.dart';
import '../utilities/utility.dart';

class SamedayListScreen extends StatefulWidget {
  final String date;
  SamedayListScreen({@required this.date});

  @override
  _SamedayListScreenState createState() => _SamedayListScreenState();
}

class _SamedayListScreenState extends State<SamedayListScreen> {
  List<DropdownMenuItem<String>> _menuItems = List();
  String _numberOfMenu = '';

  Utility _utility = Utility();

  //全データ取得用
  List<Monie> _monieData = List();

  //同日リスト作成用
  List<List<String>> _samedayData = List();

  /**
  * 初期動作
  */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
    _numberOfMenu = _menuItems[0].value;
  }

  /**
  * 初期データ作成
  */
  _makeDefaultDisplayData() async {
    _menuItems.add(
      DropdownMenuItem(
        value: '',
        child: Container(
          child: Text(''),
          width: 50,
        ),
      ),
    );
    for (int i = 1; i <= 31; i++) {
      _menuItems.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Container(
            child: Text(i.toString()),
          ),
        ),
      );
    }

    //全データ取得
    _monieData = await database.selectSortedAllRecord;
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Same Day List',
          style: TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 16.0, fontFamily: "Yomogi"),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: DropdownButton(
                          items: _menuItems,
                          value: _numberOfMenu,
                          onChanged: (value) => _makeSamedayList(value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () => _numberUpDown(1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () => _numberUpDown(-1),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _samedayData.length,
                    itemBuilder: (context, int position) => _listItem(position),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
  * リストアイテム表示
  */
  Widget _listItem(int position) {
    return Card(
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
                _getDisplayContainer(position, 0),
                _getDisplayContainer(position, 2),
                _getDisplayContainer(position, 1),
                _getDisplayContainer(position, 3),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * データコンテナ表示
   */
  Widget _getDisplayContainer(int position, int column) {
    return Container(
      alignment: _getDisplayAlign(column),
      child: Text(_samedayData[position][column]),
    );
  }

  /**
   * データ表示位置取得
   */
  _getDisplayAlign(int column) {
    switch (column) {
      case 0:
        return Alignment.topLeft;
        break;
      case 1:
        return Alignment.center;
        break;
      case 2:
        return Alignment.center;
        break;
      case 3:
        return Alignment.topRight;
        break;
    }
  }

  /**
  * プルダウン変更処理
  */
  _makeSamedayList(value) async {
    //プルダウンに選択された日付を表示する
    _numberOfMenu = value;

    //同日リスト作成
    _samedayData = List();
    if (_monieData.length > 0) {
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeYMDYData(_monieData[i].strDate, 0);

        //プルダウンと同日の場合のみリストに追加する
        if (int.parse(_utility.day) == int.parse(value)) {
          var samedata = await database.selectRecord(_monieData[i].strDate);
          _utility.makeTotal(samedata);
          var total = _utility.total;

          var firstDayData = await getFirstDayData(_monieData[i].strDate);

          _samedayData.add([
            _monieData[i].strDate,
            total.toString(),
            firstDayData.toString(),
            ((firstDayData - total) * -1).toString()
          ]);
        } //if (int.parse(_utility.day) == int.parse(value))
      } //for[i]
    }

    setState(() {});
  }

  Future<int> getFirstDayData(String dayDate) async {
    var ex_dayDate = (dayDate).split('-');
    var lastMonthLastDay =
        DateTime(int.parse(ex_dayDate[0]), int.parse(ex_dayDate[1]), 0);
    var ex_lmld = (lastMonthLastDay.toString()).split(' ');
    var value = await database.selectRecord(ex_lmld[0]);
    if (value.length == 0) {
      return 0;
    } else {
      _utility.makeTotal(value);
      return _utility.total;
    }
  }

  /**
  * 日付増減ボタン挙動
  */
  _numberUpDown(int i) {
    var number = (_numberOfMenu == '') ? 0 : int.parse(_numberOfMenu);
    var num = number + i;
    if (num < 1) {
      num = 1;
    }
    if (num > 31) {
      num = 31;
    }

    _makeSamedayList(num.toString());
  }
}
