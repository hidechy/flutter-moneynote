import 'package:flutter/material.dart';

import '../db/database.dart';
import '../utilities/utility.dart';
import '../main.dart';

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

  List<Monie> _monieData = List();
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
          'Same Day',
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
                  child: Center(
                    child: DropdownButton(
                      items: _menuItems,
                      value: _numberOfMenu,
                      onChanged: (value) => _makeSamedayList(value),
                    ),
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
          '${_samedayData[position][0]}　${_samedayData[position][1]}　${_samedayData[position][2]}',
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

    //リストデータ作成
    var _monthData = List();
    if (_monieData.length > 0) {
      for (int i = 0; i < _monieData.length; i++) {
        //--------------------------------------------//total
        List<List<String>> _totalValue = List();

        _totalValue.add(['10000', _monieData[i].strYen10000]);
        _totalValue.add(['5000', _monieData[i].strYen5000]);
        _totalValue.add(['2000', _monieData[i].strYen2000]);
        _totalValue.add(['1000', _monieData[i].strYen1000]);
        _totalValue.add(['500', _monieData[i].strYen500]);
        _totalValue.add(['100', _monieData[i].strYen100]);
        _totalValue.add(['50', _monieData[i].strYen50]);
        _totalValue.add(['10', _monieData[i].strYen10]);
        _totalValue.add(['5', _monieData[i].strYen5]);
        _totalValue.add(['1', _monieData[i].strYen1]);

        _totalValue.add(['1', _monieData[i].strBankA]);
        _totalValue.add(['1', _monieData[i].strBankB]);
        _totalValue.add(['1', _monieData[i].strBankC]);
        _totalValue.add(['1', _monieData[i].strBankD]);

        _totalValue.add(['1', _monieData[i].strPayA]);
        _totalValue.add(['1', _monieData[i].strPayB]);

        var total = 0;
        for (int j = 0; j < _totalValue.length; j++) {
          total +=
              (int.parse(_totalValue[j][0]) * int.parse(_totalValue[j][1]));
        }
        //--------------------------------------------//total

        _utility.makeYMDYData(_monieData[i].strDate, 0);

        if (int.parse(_utility.day) > int.parse(value)) {
          continue;
        }

        var _dayData = List();
        _dayData.add([_utility.day, total]);

        _monthData.add([_utility.year + "-" + _utility.month, _dayData]);
      }
    }

    String _ym = "";
    int _listTotal = 0;
    var _samedayTotalList = List();

    for (int i = 0; i < _monthData.length; i++) {
      String _listDate = '';
      if (_ym != _monthData[i][0]) {
        _listDate = _monthData[i][0];
        _listTotal = 0;
      }

      for (int j = 0; j < _monthData[i][1][0].length; j++) {
        if (j == 0) {
          continue;
        }
        _listTotal += _monthData[i][1][0][j];
      } //for[j]

      if (_listDate == "") {
        _samedayTotalList.add([_ym, _listTotal.toString()]);
      }

      _ym = _monthData[i][0];
    } //for[i]

    //print(_samedayTotalList);

    _samedayData = List();

    for (int i = 0; i < _samedayTotalList.length; i++) {
      //先月末の日付
      _utility.makeYMDYData(_samedayTotalList[i][0] + '-01', 0);
      _utility.makeMonthEnd(
          int.parse(_utility.year), int.parse(_utility.month), 0);
      _utility.makeYMDYData(_utility.monthEndDateTime, 0);
      var prevMonthEnd =
          _utility.year + "-" + _utility.month + "-" + _utility.day;

      //前月末のデータを取得
      var _prevMonthEndData = await database.selectRecord(prevMonthEnd);

      var prevTotal = 0;
      if (_prevMonthEndData.length > 0) {
        _utility.makeTotal(_prevMonthEndData);
        prevTotal = _utility.total;
      }

      var diff = 0;
      diff = prevTotal - int.parse(_samedayTotalList[i][1]);
      _samedayData.add(
          [_samedayTotalList[i][0], _samedayTotalList[i][1], diff.toString()]);
    }

    print(_samedayData);

    setState(() {});
  }
}
