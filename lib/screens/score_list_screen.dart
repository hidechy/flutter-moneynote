import 'package:flutter/material.dart';

import '../main.dart';
import '../utilities/utility.dart';

import 'monthly_list_screen.dart';

class ScoreListScreen extends StatefulWidget {
  final String date;
  ScoreListScreen({@required this.date});

  @override
  _ScoreListScreenState createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _scoreData = List();

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
    ///////////////////////////////////benefit
    var val2 = await database.selectBenefitSortedAllRecord;
    var _beneInfo = Map();
    if (val2.length > 0) {
      String _strDate;
      int j = 0;
      for (int i = 0; i < val2.length; i++) {
        var _exDate = val2[i].strDate.split(('-'));
        if (_strDate != '${_exDate[0]}-${_exDate[1]}') {
          j = 0;
        }
        _beneInfo['${_exDate[0]}-${_exDate[1]}'] = Map();
        _beneInfo['${_exDate[0]}-${_exDate[1]}'][j] = val2[i].strPrice;
        j++;
        _strDate = '${_exDate[0]}-${_exDate[1]}';
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
              '${_utility.year}-${_utility.month}-${_utility.day}';

          //今月末の日付
          _utility.makeYMDYData(val[i].strDate, 0);
          _utility.makeMonthEnd(
              int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
          _utility.makeYMDYData(_utility.monthEndDateTime, 0);
          var thisMonthEnd =
              '${_utility.year}-${_utility.month}-${_utility.day}';

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
          dispMonth = "${_utility.year}-${_utility.month}";
          continue;
        }

        var monie = await database.selectRecord(_scoreDayInfo[i][j]);

        switch (j) {
          case 1: //先月末の日付
            prevTotal = 0;
            if (monie.length > 0) {
              _utility.makeTotal(monie[0]);
              prevTotal = _utility.total;
            }
            break;
          case 2: //今月末の日付
            thisTotal = 0;
            if (monie.length > 0) {
              _utility.makeTotal(monie[0]);
              thisTotal = _utility.total;
            }
            break;
        }
      } //for[j]

      int _benefit = (_beneSum[dispMonth] != null) ? _beneSum[dispMonth] : 0;
      int _score = ((prevTotal - thisTotal) * -1);
      int _minus = (_benefit > 0) ? (_benefit - _score) : (_score * -1);

      var _map = Map();
      _map['month'] = dispMonth;
      _map['prev_total'] = prevTotal.toString();
      _map['this_total'] = thisTotal.toString();
      _map['score'] = _score.toString();
      _map['benefit'] = _benefit.toString();
      _map['minus'] = _minus.toString();

      _scoreData.add(_map);
    } //for[i]

    _scoreData.removeLast();

    //////////////////////////////////////////////////
    var scoreCount = _scoreData.length;
    var gain = 0;
    for (var i = 0; i < scoreCount; i++) {
      var value = _scoreData[i];

      if (i == 0) {
        value['gain'] = '';
      } else if (i == (scoreCount - 1)) {
        value['gain'] = '';
      } else {
        gain += int.parse(value['score']);
        value['gain'] = gain;
      }
    }
    //////////////////////////////////////////////////

    setState(() {});
  }

  /**
  * 画面描画
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Score List'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),
          _scoreList(),
        ],
      ),
    );
  }

  /**
  * リスト表示
  */
  Widget _scoreList() {
    return ListView.builder(
      itemCount: _scoreData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
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
                _getDisplayContainer(
                    align: 'left',
                    text: '',
                    position: position,
                    column: 'month'),
                Container(),
                Container(),
                Container(),
                Container(),
              ]),
              TableRow(children: [
                _getDisplayContainer(
                    align: 'right',
                    text: 'start : ',
                    position: null,
                    column: null),
                _getDisplayContainer(
                    align: 'right',
                    text: '',
                    position: position,
                    column: 'prev_total'),
                _getDisplayContainer(
                    align: 'right',
                    text: 'end : ',
                    position: null,
                    column: null),
                _getDisplayContainer(
                    align: 'right',
                    text: '',
                    position: position,
                    column: 'this_total'),
                Container(),
              ]),
              TableRow(children: [
                _getDisplayContainer(
                    align: 'right',
                    text: 'spend : ',
                    position: null,
                    column: null),
                _getDisplayContainer(
                    align: 'right',
                    text: '',
                    position: position,
                    column: 'minus'),
                _getDisplayContainer(
                    align: 'right',
                    text: 'benefit : ',
                    position: null,
                    column: null),
                _getDisplayContainer(
                    align: 'right',
                    text: '',
                    position: position,
                    column: 'benefit'),
                Container(),
              ]),
              TableRow(children: [
                _getDisplayContainer(
                    align: 'right',
                    text: 'score : ',
                    position: null,
                    column: null),
                _getDisplayContainer(
                    align: 'right',
                    text: '',
                    position: position,
                    column: 'score'),
                _getDisplayContainer(
                    align: 'right',
                    text: 'gain : ',
                    position: null,
                    column: null),
                _getDisplayContainer(
                    align: 'right',
                    text: '',
                    position: position,
                    column: 'gain'),
                Container(),
              ]),
            ],
          ),
        ),
        onLongPress: () => _goMonthlyListScreen(
            context: context, date: '${_scoreData[position]['month']}-01'),
      ),
    );
  }

  /**
  * データコンテナ表示
  */
  Widget _getDisplayContainer(
      {String align, String text, int position, String column}) {
    return Container(
      alignment: (align == 'left') ? Alignment.topLeft : Alignment.topRight,
      child: _getDisplayText(text: text, position: position, column: column),
    );
  }

  /**
   * 表示するテキストを取得
   */
  Widget _getDisplayText({String text, int position, String column}) {
    if (text != '') {
      switch (text) {
        case 'score : ':
          return Text('${text}', style: TextStyle(color: Colors.yellowAccent));
          break;
        case 'gain : ':
          return Text('${text}', style: TextStyle(color: Colors.greenAccent));
          break;
        default:
          return Text('${text}');
          break;
      }
    }

    switch (column) {
      case 'score':
        return Text(
          '${_scoreData[position][column]}',
          style: TextStyle(color: Colors.yellowAccent),
        );
        break;
      case 'gain':
        return Text(
          '${_scoreData[position][column]}',
          style: TextStyle(color: Colors.greenAccent),
        );
        break;
      default:
        return Text('${_scoreData[position][column]}');
        break;
    }
  }

  /**
   * 画面遷移（MonthlyListScreen）
   */
  void _goMonthlyListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: date,
        ),
      ),
    );
  }
}
