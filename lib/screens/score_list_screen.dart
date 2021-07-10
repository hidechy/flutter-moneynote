import 'package:flutter/material.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';

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

  int StartMoney = 1333926;

  int _allGain = 0;

  /**
  * 初期動作
  */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

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
            prevTotal = StartMoney;
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

    //////////////////////////////////////////////////
    var scoreCount = _scoreData.length;
    var gain = 0;
    for (var i = 0; i < scoreCount; i++) {
      var value = _scoreData[i];

      if (i == 0) {
        value['gain'] = value['score'];
        _allGain = int.parse(value['score']);
      } else if (i == (scoreCount - 1)) {
        value['gain'] = '';
      } else {
        _allGain += int.parse(value['score']);
        value['gain'] = _allGain;
      }
    }
    //////////////////////////////////////////////////

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: EdgeInsets.only(top: 5, left: 6),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          _scoreList(),
        ],
      ),
    );
  }

  Widget _scoreList() {
    return ListView.builder(
      itemCount: _scoreData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  Widget _listItem({int position}) {
    if (position == _scoreData.length - 1) {
      return Container();
    }

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
          title: DefaultTextStyle(
        style: TextStyle(fontSize: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${_scoreData[position]['month']}'),
            Table(
              children: [
                TableRow(children: [
                  Container(
                      alignment: Alignment.topRight, child: Text('start')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['prev_total']}')),
                  Container(alignment: Alignment.topRight, child: Text('end')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['this_total']}')),
                  Container(),
                  Container(),
                ]),
                TableRow(children: [
                  Container(
                      alignment: Alignment.topRight, child: Text('benefit')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['benefit']}')),
                  Container(
                      alignment: Alignment.topRight, child: Text('minus')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['minus']}')),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      'score',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${_scoreData[position]['score']}',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      'gain',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${_scoreData[position]['gain']}',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
