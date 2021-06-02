import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';

import 'credit_spend_display_screen.dart';
import 'food_expenses_display_screen.dart';

class SpendSummaryDisplayScreen extends StatefulWidget {
  final String date;
  SpendSummaryDisplayScreen({@required this.date});

  @override
  _SpendSummaryDisplayScreenState createState() =>
      _SpendSummaryDisplayScreenState();
}

//graph
class SpendSummary {
  final String item;
  final int sales;

  SpendSummary(this.item, this.sales);
}

class _SpendSummaryDisplayScreenState extends State<SpendSummaryDisplayScreen> {
  Utility _utility = Utility();

  List<DropdownMenuItem<String>> _dropdownYears = List();

  String _selectedYear = '';
  String _selectedMonth = '';

  List<Widget> _monthButton = List();

  int _total = 0;
  List<Map<dynamic, dynamic>> _summaryData = List();

  //graph
  bool _graphDisplay = false;
  List<charts.Series<SpendSummary, String>> seriesList = List();

  List<Map<dynamic, dynamic>> _timeplace1000over = List();
  int _totalTm1000over = 0;

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
    List explodedDate = DateTime.now().toString().split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');

    for (int i = int.parse(explodedSelectedDate[0]); i >= 2020; i--) {
      _dropdownYears.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Container(
            child: Text('${i.toString()}'),
          ),
        ),
      );
    }

    _utility.makeYMDYData(widget.date, 0);
    _selectedYear = _utility.year;

    _makeMonthButton();

    ///////////////////////
    String url = "http://toyohide.work/BrainLog/api/yearsummary";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      //graph
      final _graphdata = List<SpendSummary>();
      seriesList = List();

      Map data = jsonDecode(response.body);

      _total = 0;
      int _piechartOther = 0;
      for (var i = 0; i < data['data'].length; i++) {
        _total += data['data'][i]['sum'];

        Map _map = Map();
        _map['item'] = data['data'][i]['item'];
        _map['sum'] = data['data'][i]['sum'];
        _map['percent'] = data['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData.add(_map);

        //graph
        _graphDisplay = true;

        if (data['data'][i]['percent'] > 5) {
          _graphdata.add(
            new SpendSummary(
              data['data'][i]['item'],
              data['data'][i]['sum'],
            ),
          );
        } else {
          _piechartOther += data['data'][i]['sum'];
        }
      }

      //graph
      if (_graphdata.length > 0) {
        _graphdata.add(
          new SpendSummary(
            'その他',
            _piechartOther,
          ),
        );
      } else {
        _graphDisplay = false;
      }

      //graph
      seriesList.add(
        new charts.Series<SpendSummary, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (SpendSummary sales, _) => sales.item,
          measureFn: (SpendSummary sales, _) => sales.sales,
          data: _graphdata,
        ),
      );
    }
    ///////////////////////

    setState(() {});
  }

  /**
   *
   */
  void _makeMonthButton() {
    _monthButton = List();

    for (int i = 1; i <= 12; i++) {
      _monthButton.add(
        GestureDetector(
          onTap: () =>
              _monthSummaryDisplay(month: i.toString().padLeft(2, '0')),
          child: Container(
            width: 40,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: (i.toString().padLeft(2, '0') == _selectedMonth)
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Center(child: Text('${i.toString().padLeft(2, '0')}')),
          ),
        ),
      );
    }
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    var _dispDate = _selectedYear;
    if (_selectedMonth != '') {
      _dispDate += '-' + _selectedMonth;
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${_dispDate}'),
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
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white.withOpacity(0.8),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: (_graphDisplay == false)
                      ? Container(
                          width: double.infinity,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          height: 200,
                          child: new charts.PieChart(
                            seriesList,
                            animate: false,
                            behaviors: [
                              new charts.DatumLegend(
                                position: charts.BehaviorPosition.end,
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                  color: charts
                                      .MaterialPalette.purple.shadeDefault,
                                  fontSize: 11,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              (_graphDisplay == false)
                  ? Container(height: 230)
                  : Container(height: 200),
              Container(
                child: Row(
                  children: <Widget>[
                    (_graphDisplay == false)
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(left: 20, bottom: 10),
                            child: Text(
                              '${_utility.makeCurrencyDisplay(_total.toString())}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              (_selectedMonth != "")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _showBankRecord(),
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.green[900].withOpacity(0.5)),
                            child: Icon(Icons.keyboard_arrow_up),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: DropdownButton(
                        dropdownColor: Colors.black.withOpacity(0.1),
                        items: _dropdownYears,
                        value: _selectedYear,
                        onChanged: (value) =>
                            _goSpendSummaryDisplayScreen(value: value),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _monthButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: (_graphDisplay == false)
                      ? Container(
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'no data',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        )
                      : _summaryList(),
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
  Widget _summaryList() {
    return ListView.builder(
      itemCount: _summaryData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
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
                Text('${_summaryData[position]['item']}'),
                Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          '${_utility.makeCurrencyDisplay(_summaryData[position]['sum'].toString())}'),
                      Text(
                        '${_summaryData[position]['total']}',
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text('${_summaryData[position]['percent']}'),
                ),
              ]),
            ],
          ),
        ),
        trailing: _makeTrailing(position: position),
      ),
    );
  }

  /**
   *
   */
  Widget _makeTrailing({position}) {
    if (_selectedMonth == '') {
      return Icon(Icons.check_box_outline_blank, color: Color(0xFF2e2e2e));
    } else {
      switch (_summaryData[position]['item']) {
        case "credit":
          return GestureDetector(
            onTap: () => _goUcCardSpendDisplayScreen(),
            child: Icon(
              Icons.credit_card,
              color: Colors.greenAccent,
            ),
          );
          break;
        case "食費":
          return GestureDetector(
            onTap: () => _goFoodExpensesDisplayScreen(),
            child: Icon(
              Icons.fastfood,
              color: Colors.greenAccent,
            ),
          );
          break;
        default:
          return Icon(Icons.check_box_outline_blank, color: Color(0xFF2e2e2e));
          break;
      }
    }
  }

  /**
   *
   */
  Future<void> _monthSummaryDisplay({String month}) async {
    _selectedMonth = month;
    _makeMonthButton();

    List<Map<dynamic, dynamic>> _summaryData2 = List();

    String url = "http://toyohide.work/BrainLog/api/monthsummary";
    Map<String, String> headers = {'content-type': 'application/json'};
    String date = "${_selectedYear}-${month}-01";

    String body = json.encode({"date": date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      //graph
      final _graphdata = List<SpendSummary>();
      seriesList = List();

      Map data = jsonDecode(response.body);

      _total = 0;

      int _piechartOther = 0;
      for (var i = 0; i < data['data'].length; i++) {
        _total += data['data'][i]['sum'];

        Map _map = Map();
        _map['item'] = data['data'][i]['item'];
        _map['sum'] = data['data'][i]['sum'];
        _map['percent'] = data['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData2.add(_map);

        //graph
        _graphDisplay = true;

        if (data['data'][i]['percent'] > 5) {
          _graphdata.add(
            new SpendSummary(
              data['data'][i]['item'],
              data['data'][i]['sum'],
            ),
          );
        } else {
          _piechartOther += data['data'][i]['sum'];
        }
      }

      //graph
      if (_graphdata.length > 0) {
        _graphdata.add(
          new SpendSummary(
            'その他',
            _piechartOther,
          ),
        );
      } else {
        _graphDisplay = false;
      }

      //graph
      seriesList.add(
        new charts.Series<SpendSummary, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (SpendSummary sales, _) => sales.item,
          measureFn: (SpendSummary sales, _) => sales.sales,
          data: _graphdata,
        ),
      );
    }

    _summaryData = _summaryData2;

    setState(() {});
  }

  /**
   *
   */
  void _showBankRecord() async {
    var bankTotal = 0;

    //----------------------------//
    Map bankRecord = Map();

    String url = "http://toyohide.work/BrainLog/api/getMonthlyBankRecord";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body =
        json.encode({"date": '${_selectedYear}-${_selectedMonth}-01'});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      bankRecord = jsonDecode(response.body);

      for (var i = 0; i < bankRecord['data'].length; i++) {
        bankTotal += int.parse(bankRecord['data'][i]['price']);
      }
    }
    //----------------------------//

    /////////////////////////////
    Map _tm = Map();

    String url2 = "http://toyohide.work/BrainLog/api/monthlytimeplace";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    String body2 =
        json.encode({"date": '${_selectedYear}-${_selectedMonth}-01'});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      _timeplace1000over = List();
      _totalTm1000over = 0;
      _tm = jsonDecode(response2.body);
      _tm['data'].forEach((key, value) {
        for (var i = 0; i < value.length; i++) {
          if (value[i]['price'] >= 1000) {
            Map _map = Map();
            _map['date'] = '${key}　${value[i]['time']}';
            _map['place'] = value[i]['place'];
            _map['price'] = value[i]['price'];
            _timeplace1000over.add(_map);

            _totalTm1000over += value[i]['price'];
          }
        }
      });
    }
    /////////////////////////////

    return showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  width: 10,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(color: Colors.indigo),
                Container(
                  height: 300,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _showBankRecordRow(value: bankRecord['data']),
                ),
                const Divider(color: Colors.indigo),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          '${_utility.makeCurrencyDisplay(_total.toString())}'),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('-'),
                      ),
                      Text(
                          '${_utility.makeCurrencyDisplay(bankTotal.toString())}'),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('<Hand>'),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('='),
                      ),
                      Text(
                          '${_utility.makeCurrencyDisplay((_total - bankTotal).toString())}'),
                    ],
                  ),
                ),
                const Divider(color: Colors.indigo),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _showTm1000OverRow(value: _timeplace1000over),
                ),
                const Divider(color: Colors.indigo),
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      '${_utility.makeCurrencyDisplay(_totalTm1000over.toString())}'),
                ),
                Container(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /**
   *
   */
  Widget _showBankRecordRow({value}) {
    List _list = List<Widget>();
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          )),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
            ),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Text('${value[i]['bank']} / ${value[i]['day']}'),
                    Text('${value[i]['item']}'),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          '${_utility.makeCurrencyDisplay(value[i]['price'].toString())}'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: _list,
      ),
    );
  }

  /**
   *
   */
  _showTm1000OverRow({List<Map> value}) {
    List _list = List<Widget>();
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Container(
          child: Table(
            children: [
              TableRow(
                children: [
                  Text(
                    '${value[i]['date']}',
                    strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '${value[i]['place']}',
                      strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${_utility.makeCurrencyDisplay(value[i]['price'].toString())}',
                      strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  /**
   *
   */
  void _goSpendSummaryDisplayScreen({value}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpendSummaryDisplayScreen(date: '${value}-01-01'),
      ),
    );
  }

  /**
   *
   */
  void _goUcCardSpendDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditSpendDisplayScreen(
            date: '${_selectedYear}-${_selectedMonth}-01'),
      ),
    );
  }

  /**
   *
   */
  void _goFoodExpensesDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FoodExpensesDisplayScreen(
                year: _selectedYear,
                month: _selectedMonth,
              )),
    );
  }
}
