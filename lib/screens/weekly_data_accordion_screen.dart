import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../main.dart';

class WeeklyDataAccordionScreen extends StatefulWidget {
  final String date;
  WeeklyDataAccordionScreen({@required this.date});

  @override
  _WeeklyDataAccordionScreenState createState() =>
      _WeeklyDataAccordionScreenState();
}

class _WeeklyDataAccordionScreenState extends State<WeeklyDataAccordionScreen> {
  Utility _utility = Utility();

  String _year = '';
  String _month = '';

  int _weeknum;

  List<String> _weekday = List();

  var _weekDayList = new List<WeekDay>();

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
    _utility.makeYMDYData(widget.date, 0);
    _year = _utility.year;
    _month = _utility.month;

    ///////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/monthlyweeknum";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json
        .encode({"date": '${_utility.year}-${_utility.month}-${_utility.day}'});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);
      _weeknum = data['data'][0];
    }
    ///////////////////////////////////////////

    //---------------------------------
    Map spenditemweekly = Map();

    String url2 = "http://toyohide.work/BrainLog/api/spenditemweekly";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    String body2 = json
        .encode({"date": '${_utility.year}-${_utility.month}-${_utility.day}'});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      spenditemweekly = jsonDecode(response2.body);

      print(spenditemweekly);

      for (var i = 0; i < spenditemweekly['data'].length; i++) {
        _weekday.add(spenditemweekly['data'][i]['date'].toString());
      }

      _weekday = _weekday.toSet().toList();
    }
    //---------------------------------

    //---------------------------------
    Map timeplaceweekly = Map();

    String url3 = "http://toyohide.work/BrainLog/api/timeplaceweekly";
    Map<String, String> headers3 = {'content-type': 'application/json'};
    String body3 = json
        .encode({"date": '${_utility.year}-${_utility.month}-${_utility.day}'});
    Response response3 = await post(url3, headers: headers3, body: body3);

    if (response3 != null) {
      timeplaceweekly = jsonDecode(response3.body);
    }
    //---------------------------------

    int j = 0;
    var _yesterdayTotal = 0;

    //-----------------//
    int _prevWeekEndTotal = 0;
    var ex_weekday0 = _weekday[0].split('-');

    var _prevWeekEndDateTime = new DateTime(int.parse(ex_weekday0[0]),
        int.parse(ex_weekday0[1]), int.parse(ex_weekday0[2]) - 1);

    _utility.makeYMDYData(_prevWeekEndDateTime.toString(), 0);

    var val = await database
        .selectRecord('${_utility.year}-${_utility.month}-${_utility.day}');
    if (val.length > 0) {
      _utility.makeTotal(val[0]);
      _prevWeekEndTotal = _utility.total;
    }
    //-----------------//

    //<<<<<<<<<<<<<<<<<<<<<<<<<//
    for (var i = 0; i < _weekday.length; i++) {
      Map _map = Map();
      _map['date'] = _weekday[i];

      _map["strYen10000"] = 0;
      _map["strYen5000"] = 0;
      _map["strYen2000"] = 0;
      _map["strYen1000"] = 0;
      _map["strYen500"] = 0;
      _map["strYen100"] = 0;
      _map["strYen50"] = 0;
      _map["strYen10"] = 0;
      _map["strYen5"] = 0;
      _map["strYen1"] = 0;

      _map["strBankA"] = 0;
      _map["strBankB"] = 0;
      _map["strBankC"] = 0;
      _map["strBankD"] = 0;
      _map["strBankE"] = 0;
      _map["strBankF"] = 0;
      _map["strBankG"] = 0;
      _map["strBankH"] = 0;

      _map["strPayA"] = 0;
      _map["strPayB"] = 0;
      _map["strPayC"] = 0;
      _map["strPayD"] = 0;
      _map["strPayE"] = 0;
      _map["strPayF"] = 0;
      _map["strPayG"] = 0;
      _map["strPayH"] = 0;

      _map['total'] = 0;

      var dbData = await database.selectRecord(_weekday[i]);
      if (dbData.length > 0) {
        _map["strYen10000"] = dbData[0].strYen10000;
        _map["strYen5000"] = dbData[0].strYen5000;
        _map["strYen2000"] = dbData[0].strYen2000;
        _map["strYen1000"] = dbData[0].strYen1000;
        _map["strYen500"] = dbData[0].strYen500;
        _map["strYen100"] = dbData[0].strYen100;
        _map["strYen50"] = dbData[0].strYen50;
        _map["strYen10"] = dbData[0].strYen10;
        _map["strYen5"] = dbData[0].strYen5;
        _map["strYen1"] = dbData[0].strYen1;

        _map["strBankA"] = dbData[0].strBankA;
        _map["strBankB"] = dbData[0].strBankB;
        _map["strBankC"] = dbData[0].strBankC;
        _map["strBankD"] = dbData[0].strBankD;
        _map["strBankE"] = dbData[0].strBankE;
        _map["strBankF"] = dbData[0].strBankF;
        _map["strBankG"] = dbData[0].strBankG;
        _map["strBankH"] = dbData[0].strBankH;

        _map["strPayA"] = dbData[0].strPayA;
        _map["strPayB"] = dbData[0].strPayB;
        _map["strPayC"] = dbData[0].strPayC;
        _map["strPayD"] = dbData[0].strPayD;
        _map["strPayE"] = dbData[0].strPayE;
        _map["strPayF"] = dbData[0].strPayF;
        _map["strPayG"] = dbData[0].strPayG;
        _map["strPayH"] = dbData[0].strPayH;

        _utility.makeTotal(dbData[0]);
        _map['total'] = _utility.total;
      }

      if (j == 0) {
        _map['diff'] = (_prevWeekEndTotal - _utility.total);
      } else {
        _map['diff'] = (_yesterdayTotal - _utility.total);
      }

      _map['spend'] = _getSpendData(
        date: _weekday[i],
        spenditem: spenditemweekly['data'],
      );

      _map['timeplace'] = _getTimeplaceData(
        date: _weekday[i],
        timeplace: timeplaceweekly['data'],
      );

      _utility.makeYMDYData(_weekday[i], 0);

      _weekDayList.add(
        WeekDay(
          isExpanded: false,
          date: _weekday[i],
          youbi: _utility.youbiStr,
          data: _map,
        ),
      );

      _yesterdayTotal = _utility.total;

      j++;
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<//

    setState(() {});
  }

  /**
   *
   */
  List _getSpendData({String date, List spenditem}) {
    List _list = List();
    for (var i = 0; i < spenditem.length; i++) {
      if (spenditem[i]['date'] == date) {
        _list.add(spenditem[i]);
      }
    }
    return _list;
  }

  /**
   *
   */
  List _getTimeplaceData({String date, List timeplace}) {
    List _list = List();
    for (var i = 0; i < timeplace.length; i++) {
      if (timeplace[i]['date'] == date) {
        _list.add(timeplace[i]);
      }
    }
    return _list;
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${_year}-${_month} [${_weeknum}wks]'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          ListView(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.black.withOpacity(0.1),
                ),
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    _weekDayList[index].isExpanded =
                        !_weekDayList[index].isExpanded;
                    setState(() {});
                  },
                  children: _weekDayList.map(_createPanel).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  ExpansionPanel _createPanel(WeekDay wday) {
    var ex_date = (wday.date).split('-');

    return ExpansionPanel(
      canTapOnHeader: true,
      //
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          color: Colors.black.withOpacity(0.1),
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(
                '${ex_date[0]}\n${ex_date[1]}-${ex_date[2]}（${wday.youbi}）',
                style: TextStyle(fontSize: 12),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                      '${_utility.makeCurrencyDisplay(wday.data['total'].toString())}'),
                ),
              ),
              Container(
                width: 80,
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(wday.data['diff'].toString())}'),
              ),
            ],
          ),
        );
      },
      //
      body: Container(
        width: double.infinity,
        color: Colors.white.withOpacity(0.1),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(
                  children: [
                    _getDisplayContainer(
                        name: '10000',
                        value: wday.data['strYen10000'].toString()),
                    _getDisplayContainer(
                        name: '5000',
                        value: wday.data['strYen5000'].toString()),
                    _getDisplayContainer(
                        name: '2000',
                        value: wday.data['strYen2000'].toString()),
                    _getDisplayContainer(
                        name: '1000',
                        value: wday.data['strYen1000'].toString()),
                    _getDisplayContainer(
                        name: '500', value: wday.data['strYen500'].toString()),
                    _getDisplayContainer(
                        name: '100', value: wday.data['strYen100'].toString()),
                    _getDisplayContainer(
                        name: '50', value: wday.data['strYen50'].toString()),
                    _getDisplayContainer(
                        name: '10', value: wday.data['strYen10'].toString()),
                    _getDisplayContainer(
                        name: '5', value: wday.data['strYen5'].toString()),
                    _getDisplayContainer(
                        name: '1', value: wday.data['strYen1'].toString())
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            (wday.data['strBankA'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'BankA',
                              value: wday.data['strBankA'].toString()),
                          _getDisplayContainer(
                              name: 'BankB',
                              value: wday.data['strBankB'].toString()),
                          _getDisplayContainer(
                              name: 'BankC',
                              value: wday.data['strBankC'].toString()),
                          _getDisplayContainer(
                              name: 'BankD',
                              value: wday.data['strBankD'].toString()),
                        ],
                      ),
                    ],
                  ),
            (wday.data['strBankE'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'BankE',
                              value: wday.data['strBankE'].toString()),
                          _getDisplayContainer(
                              name: 'BankF',
                              value: wday.data['strBankF'].toString()),
                          _getDisplayContainer(
                              name: 'BankG',
                              value: wday.data['strBankG'].toString()),
                          _getDisplayContainer(
                              name: 'BankH',
                              value: wday.data['strBankH'].toString()),
                        ],
                      ),
                    ],
                  ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            (wday.data['strPayA'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'PayA',
                              value: wday.data['strPayA'].toString()),
                          _getDisplayContainer(
                              name: 'PayB',
                              value: wday.data['strPayB'].toString()),
                          _getDisplayContainer(
                              name: 'PayC',
                              value: wday.data['strPayC'].toString()),
                          _getDisplayContainer(
                              name: 'PayD',
                              value: wday.data['strPayD'].toString()),
                        ],
                      ),
                    ],
                  ),
            (wday.data['strPayE'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'PayE',
                              value: wday.data['strPayE'].toString()),
                          _getDisplayContainer(
                              name: 'PayF',
                              value: wday.data['strPayF'].toString()),
                          _getDisplayContainer(
                              name: 'PayG',
                              value: wday.data['strPayG'].toString()),
                          _getDisplayContainer(
                              name: 'PayH',
                              value: wday.data['strPayH'].toString()),
                        ],
                      ),
                    ],
                  ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
          ],
        ),
      ),
      //
      isExpanded: wday.isExpanded,
    );
  }

  /**
   *
   */
  Widget _getDisplayContainer({name, value}) {
    return Container(
      alignment: Alignment.topRight,
      child: Text(
        '${_utility.makeCurrencyDisplay(value)}',
        style: TextStyle(color: _getTextColor(name: name), fontSize: 12),
      ),
    );
  }

  /**
   *
   */
  Color _getTextColor({name}) {
    switch (name) {
      case '10000':
      case '5000':
      case '2000':
      case '1000':
        return Colors.greenAccent;
        break;
      case '10':
      case '5':
      case '1':
        return Colors.yellowAccent;
        break;
      default:
        return Colors.white;
        break;
    }
  }
}

class WeekDay {
  bool isExpanded;
  String date;
  String youbi;
  Map data;

  WeekDay({this.isExpanded, this.date, this.youbi, this.data});
}
