import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';

import '../utilities/utility.dart';

import 'dart:convert';

class MonthlyTrendDisplayScreen extends StatefulWidget {
  @override
  _MonthlyTrendDisplayScreenState createState() =>
      _MonthlyTrendDisplayScreenState();
}

class _MonthlyTrendDisplayScreenState extends State<MonthlyTrendDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _trendData = List();

  final _controllerX = ScrollController();
  final _controllerY = ScrollController();

  List<Map<dynamic, dynamic>> _yearStartMoney = List();

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
    //-----------------------//
    Map salary = Map();

    String url2 = "http://toyohide.work/BrainLog/api/getsalary";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    String body2 = json.encode({"x": ''});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      salary = jsonDecode(response2.body);
    }
    //-----------------------//

    ///////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getmonthstartmoney";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"x": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _makeYearStartMoney(data: data['data'][i]);

        Map _map = Map();
        _map['year'] = data['data'][i]['year'];
        _map['price'] = data['data'][i]['price'];
        _map['manen'] = data['data'][i]['manen'];
        _map['updown'] = data['data'][i]['updown'];
        _map['sagaku'] = data['data'][i]['sagaku'];

        _map['salary'] = _getSalary(
          year: data['data'][i]['year'],
          salary: salary['data'],
        );

        _trendData.add(_map);
      }
    }
    ///////////////////////////////////////////

    print(_yearStartMoney);

    setState(() {});
  }

  /**
   *
   */
  _makeYearStartMoney({data}) {
    var ex_price = (data['price']).split('|');
    if (data['year'] > 2014) {
      Map _map = Map();
      _map['year'] = data['year'];
      _map['price'] = ex_price[0];
      _yearStartMoney.add(_map);
    }
  }

  /**
   *
   */
  String _getSalary({year, salary}) {
    var answer;
    for (var i = 0; i < salary.length; i++) {
      if (salary[i]["year"] == year) {
        answer = salary[i]["salary"];
        break;
      }
    }
    return answer;
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('History'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
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
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              controller: _controllerY,
              child: SingleChildScrollView(
                controller: _controllerX,
                scrollDirection: Axis.horizontal,
                child: buildPlaid(),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
            onPanUpdate: (DragUpdateDetails data) {
              _controllerX.jumpTo(
                _controllerX.offset + (data.delta.dx * -1),
              );
              _controllerY.jumpTo(
                _controllerY.offset + (data.delta.dy * -1),
              );
            },
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget buildPlaid() {
    var _decoration = BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      border: Border.all(
        color: Colors.blueAccent.withOpacity(0.3),
      ),
    );

    var _decoration2 = BoxDecoration(
      color: Colors.blueAccent.withOpacity(0.3),
      border: Border.all(
        color: Colors.blueAccent.withOpacity(0.3),
      ),
    );

    var _cellHeight = 160.0;

    List<Widget> _listColumn = [];
    for (var j = 0; j < _trendData.length; j++) {
      var ex_manen = (_trendData[j]['manen']).split('|');
      var ex_updown = (_trendData[j]['updown']).split('|');
      var ex_sagaku = (_trendData[j]['sagaku']).split('|');
      var ex_salary = (_trendData[j]['salary']).split('|');

      List<Widget> _listRow = [];
      var ex_price = (_trendData[j]['price']).split('|');
      ex_price.insert(0, _trendData[j]['year'].toString());
      for (var i = 0; i < ex_price.length; i++) {
        ////////////////////////////////////
        _listRow.add(
          (i == 0)
              ? Container(
                  decoration: (i != 0) ? _decoration : _decoration2,
                  margin: EdgeInsets.all(2),
                  width: 80,
                  height: _cellHeight,
                  child: Text('${ex_price[i]}'),
                )
              : Container(
                  decoration: (i != 0) ? _decoration : _decoration2,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  width: 80,
                  height: _cellHeight,
                  alignment: Alignment.topCenter,
                  child: (ex_price[i] == '-')
                      ? Text(
                          '',
                          style: TextStyle(fontSize: 12),
                        )
                      : _getOneBlockItem(
                          year: _trendData[j]['year'],
                          month: i,
                          cellNo: i,
                          price: ex_price,
                          manen: ex_manen,
                          updown: ex_updown,
                          sagaku: ex_sagaku,
                          salary: ex_salary,
                        ),
                ),
        );
        ////////////////////////////////////

      }

      _listColumn.add(
        Row(
          children: _listRow,
        ),
      );
    }

    List<Widget> _listRow = [];

    //---------------------------------------//line1 month
    for (var i = 0; i <= 12; i++) {
      _listRow.add(
        Container(
          decoration: (i != 0) ? _decoration2 : null,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.topCenter,
          width: 80,
          child: (i == 0) ? Text('') : Text('${i}'),
        ),
      );
    }

    _listColumn.insert(
      0,
      Row(
        children: _listRow,
      ),
    );
    //---------------------------------------//line1 month

    return Container(
      child: Column(
        children: _listColumn,
      ),
    );
  }

  /**
   *
   */
  Widget _getOneBlockItem({
    year,
    month,
    cellNo,
    price,
    manen,
    updown,
    sagaku,
    salary,
  }) {
    var ym = '${year}-${month.toString().padLeft(2, "0")}';

    return Column(
      children: <Widget>[
        //-----------------------------------//
        //
        Container(
          padding: EdgeInsets.only(bottom: 3),
          alignment: Alignment.topRight,
          child: Text(
            '${ym}',
            style: TextStyle(fontSize: 10),
          ),
        ),
        //
        Text(
          '${_utility.makeCurrencyDisplay(price[cellNo])}',
          style: TextStyle(fontSize: 12),
          strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
        ),
        //
        Text(
          '${manen[cellNo - 1]}',
          style: TextStyle(fontSize: 12),
          strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
        ),
        //
        (updown[cellNo - 1] == '1')
            ? Icon(Icons.add, size: 20, color: Colors.greenAccent)
            : Icon(Icons.remove, size: 20, color: Colors.redAccent),
        //
        Text(
          '${sagaku[cellNo - 1]}',
          style: TextStyle(fontSize: 12),
          strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
        ),
        //
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 5),
          color: Colors.yellowAccent.withOpacity(0.3),
          width: double.infinity,
          child: Text(
            '${salary[cellNo - 1]}',
            style: TextStyle(fontSize: 12),
            strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
          ),
        ),
        //
        _getMonthSpend(
            cellNo: cellNo,
            updown: updown,
            salary: salary,
            sagaku: sagaku,
            ym: ym,
            price: price),
        //
        //-----------------------------------//
      ],
    );
  }

  /**
   *
   */
  Widget _getMonthSpend({cellNo, updown, salary, sagaku, ym, price}) {
    var answer = 0;

    if (cellNo > updown.length) {
      return Container();
    } else if (cellNo == updown.length) {
      var _nextYearStart = _getNextYearStart(ym: ym, data: _yearStartMoney);
      var diff = (int.parse(_nextYearStart) - int.parse(price[cellNo]));
      var _sagaku = (diff / 10000).round();

      var _salary = (salary[cellNo - 1]).replaceAll('万円', '');
      if (_salary == '-') {
        _salary = '0';
      }

      if (_sagaku < 0) {
        answer = (int.parse(_salary) + (_sagaku * -1));
      } else {
        answer = (int.parse(_salary) - _sagaku);
      }
    } else {
      var _salary = (salary[cellNo - 1]).replaceAll('万円', '');
      if (_salary == '-') {
        _salary = '0';
      }

      var _sagaku = (sagaku[cellNo]).replaceAll('万円', '');

      switch (updown[cellNo]) {
        case '0':
          answer = (int.parse(_salary) + int.parse(_sagaku));
          break;
        case '1':
          answer = (int.parse(_salary) - int.parse(_sagaku));
          break;
      }
    }

    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 5),
      color: Colors.redAccent.withOpacity(0.3),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            '${answer}万円',
            style: TextStyle(fontSize: 12),
            strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  String _getNextYearStart({ym, List<Map> data}) {
    var price;
    var ex_ym = (ym).split('-');
    for (var i = 0; i < data.length; i++) {
      if ((int.parse(ex_ym[0]) + 1) == data[i]['year']) {
        price = data[i]['price'];
        break;
      }
    }
    return price;
  }
}
