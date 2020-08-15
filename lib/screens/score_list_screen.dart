import 'package:flutter/material.dart';

import '../main.dart';

import '../utilities/utility.dart';

class ScoreListScreen extends StatefulWidget {
  final String date;
  ScoreListScreen({@required this.date});

  @override
  _ScoreListScreenState createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
  Utility _utility = Utility();

  List<List<String>> _scoreData = List();

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
    ///////////////////////////////////benefit
    var val2 = await database.selectBenefitSortedAllRecord;
    var _beneInfo = Map();
    if (val2.length > 0) {
      String _strDate;
      int j = 0;
      for (int i = 0; i < val2.length; i++) {
        var _exDate = val2[i].strDate.split(('-'));
        if (_strDate != _exDate[0] + '-' + _exDate[1]) {
          j = 0;
        }
        _beneInfo[_exDate[0] + '-' + _exDate[1]] = Map();
        _beneInfo[_exDate[0] + '-' + _exDate[1]][j] = val2[i].strPrice;
        j++;
        _strDate = _exDate[0] + '-' + _exDate[1];
      }
    }

    var _beneSum = Map();
    _beneInfo.forEach((var key, var value) {
      int sum = 0;
      value.forEach((var key2, var value2) {
        sum += int.parse(value2);
      });
      _beneSum[key] = sum;
    });
    ///////////////////////////////////benefit

    //-----------------------------------//
    List<List<String>> _scoreDayInfo = List();
    var val = await database.selectSortedAllRecord;
    if (val.length > 0) {
      for (int i = 0; i < val.length; i++) {
        _utility.makeYMDYData(val[i].strDate, 0);
        if (_utility.day == '01') {
          //先月末の日付
          _utility.makeMonthEnd(
              int.parse(_utility.year), int.parse(_utility.month), 0);
          _utility.makeYMDYData(_utility.monthEndDateTime, 0);
          var prevMonthEnd =
              _utility.year + "-" + _utility.month + "-" + _utility.day;

          //今月末の日付
          _utility.makeYMDYData(val[i].strDate, 0);
          _utility.makeMonthEnd(
              int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
          _utility.makeYMDYData(_utility.monthEndDateTime, 0);
          var thisMonthEnd =
              _utility.year + "-" + _utility.month + "-" + _utility.day;

          _scoreDayInfo.add([val[i].strDate, prevMonthEnd, thisMonthEnd]);
        }
      }
    }
    //-----------------------------------//

    _scoreData = List();
    for (int i = 0; i < _scoreDayInfo.length; i++) {
      var dispMonth = "";
      var prevTotal = 0;
      var thisTotal = 0;
      for (int j = 0; j < _scoreDayInfo[i].length; j++) {
        if (j == 0) {
          _utility.makeYMDYData(_scoreDayInfo[i][0], 0);
          dispMonth = _utility.year + "-" + _utility.month;
          continue;
        }

        var monie = await database.selectRecord(_scoreDayInfo[i][j]);

        switch (j) {
          case 1: //先月末の日付
            prevTotal = 0;
            if (monie.length > 0) {
              _utility.makeTotal(monie);
              prevTotal = _utility.total;
            }
            break;
          case 2: //今月末の日付
            thisTotal = 0;
            if (monie.length > 0) {
              _utility.makeTotal(monie);
              thisTotal = _utility.total;
            }
            break;
        }
      } //for[j]

      int _benefit = (_beneSum[dispMonth] != null) ? _beneSum[dispMonth] : 0;
      int _score = ((prevTotal - thisTotal) * -1);
      int _minus = (_benefit > 0) ? (_benefit - _score) : (_score * -1);

      _scoreData.add([
        dispMonth,
        prevTotal.toString(),
        thisTotal.toString(),
        _score.toString(),
        _benefit.toString(),
        _minus.toString()
      ]);
    } //for[i]

    setState(() {});
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Score List',
          style: TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          _scoreList(),
        ],
      ),
    );
  }

  /**
  * リスト表示
  */
  _scoreList() {
    return ListView.builder(
      itemCount: _scoreData.length,
      itemBuilder: (context, int position) => _listItem(position),
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
                _getDisplayContainer('left', '', position, 0),
                Container(),
                Container(),
                Container(),
                Container(),
              ]),
              TableRow(children: [
                _getDisplayContainer('right', 'start : ', null, null),
                _getDisplayContainer('right', '', position, 1),
                _getDisplayContainer('right', 'end : ', null, null),
                _getDisplayContainer('right', '', position, 2),
                Container(),
              ]),
              TableRow(children: [
                _getDisplayContainer('right', 'score : ', null, null),
                _getDisplayContainer('right', '', position, 3),
                _getDisplayContainer('right', 'spend : ', null, null),
                _getDisplayContainer('right', '', position, 5),
                Container(),
              ]),
              TableRow(children: [
                _getDisplayContainer('right', 'benefit : ', null, null),
                _getDisplayContainer('right', '', position, 4),
                Container(),
                Container(),
                Container(),
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
  Widget _getDisplayContainer(
      String align, String text, int position, int column) {
    return Container(
      alignment: (align == 'left') ? Alignment.topLeft : Alignment.topRight,
      child: (text != '') ? Text(text) : Text(_scoreData[position][column]),
    );
  }
}
