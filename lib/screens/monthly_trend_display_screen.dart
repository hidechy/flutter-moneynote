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

    print(_trendData);

    setState(() {});
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
        _listRow.add(
          (i == 0)
              ? Container(
                  decoration: (i != 0) ? _decoration : _decoration2,
                  margin: EdgeInsets.all(2),
                  width: 80,
                  height: 120,
                  child: Text('${ex_price[i]}'),
                )
              : Container(
                  decoration: (i != 0) ? _decoration : _decoration2,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  width: 80,
                  height: 120,
                  alignment: Alignment.topCenter,
                  child: (ex_price[i] == '-')
                      ? Text(
                          '',
                          style: TextStyle(fontSize: 12),
                        )
                      : Column(
                          children: <Widget>[
                            //-----------------------------------//
                            Text(
                              '${_utility.makeCurrencyDisplay(ex_price[i])}',
                              style: TextStyle(fontSize: 12),
                              strutStyle:
                                  StrutStyle(fontSize: 12.0, height: 1.3),
                            ),
                            //
                            Text(
                              '${ex_manen[i - 1]}',
                              style: TextStyle(fontSize: 12),
                              strutStyle:
                                  StrutStyle(fontSize: 12.0, height: 1.3),
                            ),
                            //
                            (ex_updown[i - 1] == '1')
                                ? Icon(Icons.add,
                                    size: 20, color: Colors.greenAccent)
                                : Icon(Icons.remove,
                                    size: 20, color: Colors.redAccent),
                            //
                            Text(
                              '${ex_sagaku[i - 1]}',
                              style: TextStyle(fontSize: 12),
                              strutStyle:
                                  StrutStyle(fontSize: 12.0, height: 1.3),
                            ),
                            //
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 5),
                              color: Colors.yellowAccent.withOpacity(0.3),
                              width: double.infinity,
                              child: Text(
                                '${ex_salary[i - 1]}',
                                style: TextStyle(fontSize: 12),
                                strutStyle:
                                    StrutStyle(fontSize: 12.0, height: 1.3),
                              ),
                            ),
                            //-----------------------------------//
                          ],
                        ),
                ),
        );
      }

      _listColumn.add(
        Row(
          children: _listRow,
        ),
      );
    }

    List<Widget> _listRow = [];

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

    return Container(
      child: Column(
        children: _listColumn,
      ),
    );
  }
}
