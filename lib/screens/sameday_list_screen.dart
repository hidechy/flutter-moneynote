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
          Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
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
        title: Text(
          '${_samedayData[position][0]}　${_samedayData[position][1]}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Yomogi',
            fontSize: 12.0,
          ),
        ),
      ),
    );
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
          _utility.makeTotal(_monieData);
          var total = _utility.total;
          _samedayData.add([_monieData[i].strDate, total.toString()]);
        } //if (int.parse(_utility.day) == int.parse(value))
      } //for[i]
    }

    setState(() {});
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
