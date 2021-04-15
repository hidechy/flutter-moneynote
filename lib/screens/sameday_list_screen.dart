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
  Utility _utility = Utility();

  List<DropdownMenuItem<String>> _menuItems = List();
  String _numberOfMenu = '';

  //全データ取得用
  List<Monie> _monieData = List();

  //同日リスト作成用
  List<Map<dynamic, dynamic>> _samedayData = List();

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
  void _makeDefaultDisplayData() async {
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
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Same Day List'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 16.0),
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
                          dropdownColor: Colors.black.withOpacity(0.1),
                          items: _menuItems,
                          value: _numberOfMenu,
                          onChanged: (value) => _makeSamedayList(value: value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () => _numberUpDown(add: 1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () => _numberUpDown(add: -1),
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
                    itemBuilder: (context, int position) =>
                        _listItem(position: position),
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
  Widget _listItem({int position}) {
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
                _getDisplayContainer(position: position, column: 'date'),
                _getDisplayContainer(position: position, column: 'first'),
                _getDisplayContainer(position: position, column: 'total'),
                _getDisplayContainer(position: position, column: 'diff'),
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
  Widget _getDisplayContainer({int position, String column}) {
    return Container(
      alignment: _getDisplayAlign(column: column),
      child: (column == 'date')
          ? Text(_samedayData[position][column])
          : Text(_utility.makeCurrencyDisplay(_samedayData[position][column])),
    );
  }

  /**
   * データ表示位置取得
   */
  Alignment _getDisplayAlign({String column}) {
    switch (column) {
      case 'date':
        return Alignment.topLeft;
        break;
      case 'total':
        return Alignment.center;
        break;
      case 'first':
        return Alignment.center;
        break;
      case 'diff':
        return Alignment.topRight;
        break;
    }
  }

  /**
  * プルダウン変更処理
  */
  void _makeSamedayList({value}) async {
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
          _utility.makeTotal(samedata[0]);
          var total = _utility.total;

          var firstDayData =
              await _getFirstDayData(dayDate: _monieData[i].strDate);

          var _map = Map();
          _map['date'] = _monieData[i].strDate;
          _map['total'] = total.toString();
          _map['first'] = firstDayData.toString();
          _map['diff'] = ((firstDayData - total) * -1).toString();

          _samedayData.add(_map);
        } //if (int.parse(_utility.day) == int.parse(value))
      } //for[i]
    }

    setState(() {});
  }

  Future<int> _getFirstDayData({String dayDate}) async {
    var ex_dayDate = (dayDate).split('-');
    var lastMonthLastDay =
        DateTime(int.parse(ex_dayDate[0]), int.parse(ex_dayDate[1]), 0);
    var ex_lmld = (lastMonthLastDay.toString()).split(' ');
    var value = await database.selectRecord(ex_lmld[0]);
    if (value.length == 0) {
      return 0;
    } else {
      _utility.makeTotal(value[0]);
      return _utility.total;
    }
  }

  /**
  * 日付増減ボタン挙動
  */
  void _numberUpDown({int add}) {
    var number = (_numberOfMenu == '') ? 0 : int.parse(_numberOfMenu);
    var num = number + add;
    if (num < 1) {
      num = 1;
    }
    if (num > 31) {
      num = 31;
    }

    _makeSamedayList(value: num.toString());
  }
}
