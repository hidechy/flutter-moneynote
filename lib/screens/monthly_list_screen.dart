import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utilities/utility.dart';
import '../main.dart';

import 'detail_display_screen.dart';
import 'oneday_input_screen.dart';

class MonthlyListScreen extends StatefulWidget {
  final String date;
  MonthlyListScreen({@required this.date});

  @override
  _MonthlyListScreenState createState() => _MonthlyListScreenState();
}

//graph
class MoneyData {
  final DateTime time;
  final int sales;

  MoneyData(this.time, this.sales);
}

class _MonthlyListScreenState extends State<MonthlyListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _monthlyData = List();

  String _year = '';
  String _month = '';

  String _yearmonth = '';

  Map<String, dynamic> _holidayList = Map();

  DateTime _prevMonth = DateTime.now();
  DateTime _nextMonth = DateTime.now();

  String _prevMonthEndDateTime = '';
  String _prevMonthEndDate = '';

  int _monthTotal = 0;

  //graph
  bool _graphDisplay = false;
  List<charts.Series<MoneyData, DateTime>> seriesList = List();

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

    _yearmonth = '${_year}-${_month}';

    ///////////////////////////
    _utility.makeMonthEnd(int.parse(_year), int.parse(_month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    int _prevMonthEndTotal = 0;

    var val = await database.selectRecord(_prevMonthEndDate);
    if (val.length > 0) {
      _utility.makeTotal(val[0]);
      _prevMonthEndTotal = _utility.total;
    }
    ///////////////////////////

    //graph
    final _graphdata = List<MoneyData>();

    //全データ取得
    var _monieData = await database.selectSortedAllRecord;

    if (_monieData.length > 0) {
      int j = 0;
      var _yesterdayTotal = 0;
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeYMDYData(_monieData[i].strDate, 0);

        if ('${_year}-${_month}' == '${_utility.year}-${_utility.month}') {
          var _map = Map();
          _map["date"] = _utility.day;

          _map["strYen10000"] = _monieData[i].strYen10000;
          _map["strYen5000"] = _monieData[i].strYen5000;
          _map["strYen2000"] = _monieData[i].strYen2000;
          _map["strYen1000"] = _monieData[i].strYen1000;
          _map["strYen500"] = _monieData[i].strYen500;
          _map["strYen100"] = _monieData[i].strYen100;
          _map["strYen50"] = _monieData[i].strYen50;
          _map["strYen10"] = _monieData[i].strYen10;
          _map["strYen5"] = _monieData[i].strYen5;
          _map["strYen1"] = _monieData[i].strYen1;

          _map["strBankA"] = _monieData[i].strBankA;
          _map["strBankB"] = _monieData[i].strBankB;
          _map["strBankC"] = _monieData[i].strBankC;
          _map["strBankD"] = _monieData[i].strBankD;
          _map["strBankE"] = _monieData[i].strBankE;
          _map["strBankF"] = _monieData[i].strBankF;
          _map["strBankG"] = _monieData[i].strBankG;
          _map["strBankH"] = _monieData[i].strBankH;

          _map["strPayA"] = _monieData[i].strPayA;
          _map["strPayB"] = _monieData[i].strPayB;
          _map["strPayC"] = _monieData[i].strPayC;
          _map["strPayD"] = _monieData[i].strPayD;
          _map["strPayE"] = _monieData[i].strPayE;
          _map["strPayF"] = _monieData[i].strPayF;
          _map["strPayG"] = _monieData[i].strPayG;
          _map["strPayH"] = _monieData[i].strPayH;

          //-------------------------------------//
          _utility.makeTotal(_monieData[i]);
          _map['total'] = _utility.total;
          //-------------------------------------//

          if (j == 0) {
            _map['diff'] = (_prevMonthEndTotal - _utility.total);
            _monthTotal += (_prevMonthEndTotal - _utility.total);
          } else {
            _map['diff'] = (_yesterdayTotal - _utility.total);
            _monthTotal += (_yesterdayTotal - _utility.total);
          }

          _monthlyData.add(_map);

          _yesterdayTotal = _utility.total;
          //graph
          _graphDisplay = true;
          _graphdata.add(
            new MoneyData(
                new DateTime(
                  int.parse(_utility.year),
                  int.parse(_utility.month),
                  int.parse(_utility.day),
                ),
                _utility.total),
          );

          j++;
        }
      }
    }

    //graph
    seriesList.add(
      new charts.Series<MoneyData, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MoneyData sales, _) => sales.time,
        measureFn: (MoneyData sales, _) => sales.sales,
        data: _graphdata,
      ),
    );

    print(seriesList);

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    _prevMonth = new DateTime(int.parse(_year), int.parse(_month) - 1, 1);
    _nextMonth = new DateTime(int.parse(_year), int.parse(_month) + 1, 1);

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('${_yearmonth}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goMonthlyListScreen(
                context: context, date: _prevMonth.toString()),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goMonthlyListScreen(
                context: context, date: _nextMonth.toString()),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),

          //----------------------//graph
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.white.withOpacity(0.8),
            child: (_graphDisplay == false)
                ? Container()
                : Container(
                    height: size.height - 40,
                    padding: EdgeInsets.all(10),
                    child: new charts.TimeSeriesChart(
                      seriesList,
                      animate: false,
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                      defaultRenderer: new charts.LineRendererConfig(
                        includePoints: true,
                      ),
                    ),
                  ),
          ),
          //----------------------//graph

          Column(
            children: <Widget>[
              Container(
                height: 250,
              ),
              Expanded(
                child: _utility.getBackGround(),
              ),
            ],
          ),

          Column(
            children: <Widget>[
              Container(
                height: 250,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                alignment: Alignment.topRight,
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Text(
                    '${_utility.makeCurrencyDisplay(_monthTotal.toString())}'),
              ),
              Expanded(
                child: _monthlyList(),
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
  Widget _monthlyList() {
    return ListView.builder(
      itemCount: _monthlyData.length,
      itemBuilder: (context, int position) {
        return _listItem(position: position);
      },
    );

    /*
            body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index >= list.length) {
              list.addAll(["メッセージ","メッセージ","メッセージ","メッセージ",]);
            }
            return _messageItem(list[index]);
          },
        )
    */
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    _utility.makeYMDYData('${_yearmonth}-${_monthlyData[position]['date']}', 0);

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: Card(
        color: _utility.getBgColor(
            '${_yearmonth}-${_monthlyData[position]['date']}', _holidayList),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${_monthlyData[position]['date']}'),
                Text(
                  '${_utility.youbiStr}',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          title: DefaultTextStyle(
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white.withOpacity(0.6),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['total'].toString())}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['diff'].toString())}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Table(
                  children: [
                    TableRow(children: [
                      Text(
                        '${_monthlyData[position]['strYen10000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen5000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen2000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen1000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text('${_monthlyData[position]['strYen500']}'),
                      Text('${_monthlyData[position]['strYen100']}'),
                      Text('${_monthlyData[position]['strYen50']}'),
                      Text(
                        '${_monthlyData[position]['strYen10']}',
                        style: TextStyle(
                            color: Colors.yellowAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen5']}',
                        style: TextStyle(
                            color: Colors.yellowAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen1']}',
                        style: TextStyle(
                            color: Colors.yellowAccent.withOpacity(0.6)),
                      ),
                    ]),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      Table(
                        children: [
                          TableRow(children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankA'])}'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankB'])}'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankC'])}'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankD'])}'),
                            ),
                          ]),
                        ],
                      ),
                      (_monthlyData[position]['strBankE'] == '0')
                          ? Container()
                          : Table(
                              children: [
                                TableRow(children: [
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankE'])}'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankF'])}'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankG'])}'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strBankH'])}'),
                                  ),
                                ]),
                              ],
                            ),
                      Table(
                        children: [
                          TableRow(children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayA'])}'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayB'])}'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayC'])}'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayD'])}'),
                            ),
                          ]),
                        ],
                      ),
                      (_monthlyData[position]['strBankE'] == '0')
                          ? Container()
                          : Table(
                              children: [
                                TableRow(children: [
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayE'])}'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayF'])}'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayG'])}'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_monthlyData[position]['strPayH'])}'),
                                  ),
                                ]),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      //actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: _utility.getBgColor(
              _yearmonth + '-' + _monthlyData[position]['date'], _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.details,
          onTap: () => _goDetailDisplayScreen(
            context: context,
            date: _yearmonth + '-' + _monthlyData[position]['date'],
          ),
        ),
        IconSlideAction(
          color: _utility.getBgColor(
              _yearmonth + '-' + _monthlyData[position]['date'], _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.input,
          onTap: () => _goOnedayInputScreen(
              context: context,
              date: _yearmonth + '-' + _monthlyData[position]['date']),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（MonthlyListScreen）
   */
  void _goMonthlyListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(date: date),
      ),
    );
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  void _goDetailDisplayScreen({BuildContext context, String date}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);
    _utility.makeYMDYData(date, 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: int.parse(_utility.day),
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }

  /**
   * 画面遷移（OnedayInputScreen）
   */
  void _goOnedayInputScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: date,
        ),
      ),
    );
  }
}
