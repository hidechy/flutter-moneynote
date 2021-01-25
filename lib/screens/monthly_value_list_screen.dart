import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../main.dart';

class MonthlyValueListScreen extends StatefulWidget {
  final String date;
  MonthlyValueListScreen({@required this.date});

  @override
  _MonthlyValueListScreenState createState() => _MonthlyValueListScreenState();
}

class _MonthlyValueListScreenState extends State<MonthlyValueListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _monthlyValueData = List();

  String _year = '';
  String _month = '';

  String _yearmonth = '';

  Map<String, dynamic> _holidayList = Map();

  DateTime _prevMonth = DateTime.now();
  DateTime _nextMonth = DateTime.now();

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

    //全データ取得
    var _monieData = await database.selectSortedAllRecord;

    if (_monieData.length > 0) {
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

          _monthlyValueData.add(_map);
        }
      }
    }

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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('${_yearmonth}'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    tooltip: '前日',
                    onPressed: () => _goMonthlyValueListScreen(
                        context: context, date: _prevMonth.toString()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    tooltip: '翌日',
                    onPressed: () => _goMonthlyValueListScreen(
                        context: context, date: _nextMonth.toString()),
                  ),
                ],
                backgroundColor: Colors.black.withOpacity(0.1),
                pinned: true,
                expandedHeight: 50.0,
                floating: false,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, position) => _listItem(position: position),
                  childCount: _monthlyValueData.length,
                ),
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
  Widget _monthlyValueList() {
    return ListView.builder(
      itemCount: _monthlyValueData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: _utility.getBgColor(
          '${_yearmonth}-${_monthlyValueData[position]['date']}', _holidayList),
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
              Text('${_monthlyValueData[position]['date']}'),
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
                child: Text(
                  '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['total'].toString())}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Table(
                children: [
                  TableRow(children: [
                    Text(
                      '${_monthlyValueData[position]['strYen10000']}',
                      style:
                          TextStyle(color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                    Text(
                      '${_monthlyValueData[position]['strYen5000']}',
                      style:
                          TextStyle(color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                    Text(
                      '${_monthlyValueData[position]['strYen2000']}',
                      style:
                          TextStyle(color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                    Text(
                      '${_monthlyValueData[position]['strYen1000']}',
                      style:
                          TextStyle(color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                    Text('${_monthlyValueData[position]['strYen500']}'),
                    Text('${_monthlyValueData[position]['strYen100']}'),
                    Text('${_monthlyValueData[position]['strYen50']}'),
                    Text(
                      '${_monthlyValueData[position]['strYen10']}',
                      style: TextStyle(
                          color: Colors.orangeAccent.withOpacity(0.6)),
                    ),
                    Text(
                      '${_monthlyValueData[position]['strYen5']}',
                      style: TextStyle(
                          color: Colors.orangeAccent.withOpacity(0.6)),
                    ),
                    Text(
                      '${_monthlyValueData[position]['strYen1']}',
                      style: TextStyle(
                          color: Colors.orangeAccent.withOpacity(0.6)),
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
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankA'])}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankB'])}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankC'])}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankD'])}'),
                    ),
                  ]),
                ],
              ),
              (_monthlyValueData[position]['strBankE'] == '0')
                  ? Container()
                  : Table(
                      children: [
                        TableRow(children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankE'])}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankF'])}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankG'])}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strBankH'])}'),
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
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayA'])}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayB'])}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayC'])}'),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayD'])}'),
                    ),
                  ]),
                ],
              ),
              (_monthlyValueData[position]['strBankE'] == '0')
                  ? Container()
                  : Table(
                      children: [
                        TableRow(children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayE'])}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayF'])}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayG'])}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthlyValueData[position]['strPayH'])}'),
                          ),
                        ]),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（MonthlyValueListScreen）
   */
  void _goMonthlyValueListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyValueListScreen(date: date),
      ),
    );
  }
}
