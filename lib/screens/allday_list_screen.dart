import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import '../main.dart';

class AlldayListScreen extends StatefulWidget {
  final String date;
  AlldayListScreen({@required this.date});

  @override
  _AlldayListScreenState createState() => _AlldayListScreenState();
}

class _AlldayListScreenState extends State<AlldayListScreen> {
  List<List<String>> _alldayData = List();

  Utility _utility = Utility();
  String youbiStr;

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
    //全データ取得
    var _monieData = await database.selectSortedAllRecord;
    if (_monieData.length > 0) {
      int _keepTotal = 0;
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

        _alldayData.add([
          _monieData[i].strDate,
          total.toString(),
          ((_keepTotal - total) * -1).toString()
        ]);

        _keepTotal = total;
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
          'All Day List',
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
          _alldayList()
        ],
      ),
    );
  }

  /**
  * リスト表示
  */
  _alldayList() {
    return ListView.builder(
      itemCount: _alldayData.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  /**
  * リストアイテム表示
  */
  _listItem(int position) {
    return InkWell(
      child: Card(
        color: getBgColor(position),
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
                  _getDisplayContainer(position, 1),
                  _getDisplayContainer(position, 2),
                ]),
              ],
            ),
          ),
        ),
      ),
      //actions: <Widget>[],
    );
  }

  /**
  * 背景色取得
  */
  getBgColor(int position) {
    _utility.makeYMDYData(_alldayData[position][0], 0);
    switch (_utility.youbiNo) {
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
  * データコンテナ表示
  */
  Widget _getDisplayContainer(int position, int column) {
    return Container(
      alignment: (column == 1) ? Alignment.topCenter : Alignment.topLeft,
      child: Text(getDisplayText(_alldayData[position][column], column)),
    );
  }

  /**
   * 表示テキスト取得
   */
  String getDisplayText(String text, int column) {
    switch (column) {
      case 0:
        _utility.makeYMDYData(text, 0);
        return text + '（' + _utility.youbiStr + '）';
        break;
      case 1:
        return _utility.makeCurrencyDisplay(text);
        break;
      case 2:
        return text;
        break;
    }
  }
}
