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
    //-----------------------------------//
    List<List<String>> _scoreDayInfo = List();
    var val = await database.selectSortedAllRecord;
    if (val.length > 0) {
      for (int i = 0; i < val.length; i++) {
        _utility.makeYMDYData(val[i].strDate, 0);
        if (_utility.day == '01') {
          _utility.makeMonthEnd(
              int.parse(_utility.year), int.parse(_utility.month), 0);
          _utility.makeYMDYData(_utility.monthEndDateTime, 0);
          var prevMonthEnd =
              _utility.year + "-" + _utility.month + "-" + _utility.day;

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

//    print(_scoreDayInfo);
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
          case 1:
            prevTotal = 0;
            if (monie.length > 0) {
              _utility.makeTotal(monie);
              prevTotal = _utility.total;
            }
            break;
          case 2:
            thisTotal = 0;
            if (monie.length > 0) {
              _utility.makeTotal(monie);
              thisTotal = _utility.total;
            }
            break;
        }
      } //for[j]

      _scoreData.add([
        dispMonth,
        prevTotal.toString(),
        thisTotal.toString(),
        ((prevTotal - thisTotal) * -1).toString()
      ]);
    } //for[i]

//    print(_scoreData);

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
          'Score',
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
          _scoreList()
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
        title: Text(
          '${_scoreData[position][0]}　${_scoreData[position][1]}　${_scoreData[position][2]}　${_scoreData[position][3]}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Yomogi',
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
