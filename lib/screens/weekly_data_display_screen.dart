import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import '../db/database.dart';
import '../main.dart';

import 'package:http/http.dart';
import 'dart:convert';

class WeeklyDataDisplayScreen extends StatefulWidget {
  final String date;
  WeeklyDataDisplayScreen({@required this.date});

  @override
  _WeeklyDataDisplayScreenState createState() =>
      _WeeklyDataDisplayScreenState();
}

class _WeeklyDataDisplayScreenState extends State<WeeklyDataDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _weeklyData = List();

  Map<String, dynamic> _holidayList = Map();

  int _weeklySpend = 0;

  DateTime _prevSunday = DateTime.now();
  DateTime _nextSunday = DateTime.now();

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
    _utility.makeYMDYData(DateTime.now().toString(), 0);
    var _today = '${_utility.year}-${_utility.month}-${_utility.day}';

    //----------------------------------------
    _utility.makeYMDYData(widget.date, 0);

    var sunday = new DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) - _utility.youbiNo);

    _utility.makeYMDYData(sunday.toString(), 0);
    var _baseYear = _utility.year;
    var _baseMonth = _utility.month;
    var _baseDay = _utility.day;

    _prevSunday = new DateTime(
        int.parse(_baseYear), int.parse(_baseMonth), int.parse(_baseDay) - 7);
    _nextSunday = new DateTime(
        int.parse(_baseYear), int.parse(_baseMonth), int.parse(_baseDay) + 7);

    for (var i = 0; i < 7; i++) {
      //////////////////////////////////////
      var _thisDayTotal = 0;

      var _date = new DateTime(
          int.parse(_baseYear), int.parse(_baseMonth), int.parse(_baseDay) + i);

      _utility.makeYMDYData(_date.toString(), 0);
      var _thisDay = '${_utility.year}-${_utility.month}-${_utility.day}';

      var val = await database.selectRecord(_thisDay);
      if (val.length > 0) {
        _utility.makeTotal(val[0]);
        _thisDayTotal = _utility.total;
      }
      //////////////////////////////////////

      ///////////////
      var _bene = 0;
      var _benefit = await database.selectBenefitRecord(_thisDay);
      if (_benefit.length > 0) {
        _bene = int.parse(_benefit[0].strPrice);
      }
      ///////////////

      /////-------------------------------------------------
      List _spendItem = List();

      Response response = await get(
          'http://toyohide.work/BrainLog/money/${_thisDay}/spenditemapi');

      if (response != null) {
        Map data = jsonDecode(response.body);
        if (data['data'] != "nodata") {
          if (data['data']['date'] == _thisDay) {
            var ex_data = (data['data']['item']).split(";");
            for (var i = 0; i < ex_data.length; i++) {
              String _linedata = ex_data[i];
              _spendItem.add(_linedata.split("|"));
            }
          }
        }
      }

      if (_bene > 0) {
        _spendItem.add(['収入', _bene * -1]);
      }
      /////-------------------------------------------------

      /////-------------------------------------------------
      List _timePlace = List();

      String url = "http://toyohide.work/BrainLog/api/timeplace";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"date": _thisDay});
      Response response3 = await post(url, headers: headers, body: body);

      if (response3 != null) {
        Map data3 = jsonDecode(response3.body);

        for (var i = 0; i < data3['data'].length; i++) {
          var _map = Map();
          _map['time'] = data3['data'][i]['time'];
          _map['place'] = data3['data'][i]['place'];
          _map['price'] = data3['data'][i]['price'];
          _timePlace.add(_map);
        }
      }
      /////-------------------------------------------------

      //////////////////////////////////////
      var _zenjitsuTotal = 0;

      var _zenjitsuDate = new DateTime(int.parse(_baseYear),
          int.parse(_baseMonth), int.parse(_baseDay) + (i - 1));

      _utility.makeYMDYData(_zenjitsuDate.toString(), 0);
      var _zenjitsu = '${_utility.year}-${_utility.month}-${_utility.day}';

      var val2 = await database.selectRecord(_zenjitsu);
      if (val2.length > 0) {
        _utility.makeTotal(val2[0]);
        _zenjitsuTotal = _utility.total;
      }
      //////////////////////////////////////

      Map _map = Map();
      _map['date'] = _thisDay;
      _map['total'] = _thisDayTotal;
      _map['diff'] = (_zenjitsuTotal - _thisDayTotal);
      _map['spendItem'] = _spendItem;
      _map['timePlace'] = _timePlace;
      _weeklyData.add(_map);

      if (_thisDayTotal > 0) {
        _weeklySpend += (_zenjitsuTotal - _thisDayTotal);
      }
    }

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Weekly Data'),
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
          _utility.getBackGround(),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () =>
                              _goWeeklyDataDisplayScreen(datetime: _prevSunday),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () =>
                              _goWeeklyDataDisplayScreen(datetime: _nextSunday),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_weeklySpend.toString())}'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _weeklyList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _weeklyList() {
    return ListView.builder(
      itemCount: _weeklyData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    _utility.makeYMDYData(_weeklyData[position]['date'], 0);

    return Card(
      color: _utility.getBgColor(_weeklyData[position]['date'], _holidayList),
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
              Table(
                children: [
                  TableRow(children: [
                    Text(
                        '${_weeklyData[position]['date']}（${_utility.youbiStr}）'),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_weeklyData[position]['total'].toString())}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_weeklyData[position]['diff'].toString())}'),
                    ),
                  ]),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 100,
                  ),
                  Expanded(
                    child: _makeSpendItemData(
                        spendItem: _weeklyData[position]['spendItem']),
                  ),
                ],
              ),

              /////////////
              Row(
                children: <Widget>[
                  Container(
                    width: 100,
                  ),
                  Expanded(
                    child: _makeTimePlaceData(
                        timePlace: _weeklyData[position]['timePlace']),
                  ),
                ],
              ),
              /////////////
            ],
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  Widget _makeSpendItemData({spendItem}) {
    if (spendItem.length == 0) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
      child: Wrap(
        children: _makeSpendItemDataRows(spendItem: spendItem),
      ),
    );
  }

  /**
   *
   */
  List _makeSpendItemDataRows({spendItem}) {
    List<Widget> _dataList = List();
    for (var i = 0; i < spendItem.length; i++) {
      _dataList.add(
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text('${spendItem[i][0]}'),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.topRight,
                child: Text('${_utility.makeCurrencyDisplay(spendItem[i][1])}'),
              ),
            ],
          ),
        ),
      );
    }
    return _dataList;
  }

  /**
   *
   */
  _makeTimePlaceData({timePlace}) {
    if (timePlace.length == 0) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
      child: Wrap(
        children: _makeTimePlaceDataRows(timePlace: timePlace),
      ),
    );
  }

  /**
   *
   */
  _makeTimePlaceDataRows({timePlace}) {
    List<Widget> _dataList = List();
    for (var i = 0; i < timePlace.length; i++) {
      _dataList.add(
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                child: Text('${timePlace[i]['time']}'),
              ),
              Expanded(
                child: Container(
                  child: Text('${timePlace[i]['place']}'),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(timePlace[i]['price'].toString())}'),
              ),
            ],
          ),
        ),
      );
    }
    return _dataList;
  }

  /**
   *
   */
  void _goWeeklyDataDisplayScreen({DateTime datetime}) {
    _utility.makeYMDYData(datetime.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyDataDisplayScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }
}
