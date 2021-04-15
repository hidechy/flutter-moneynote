import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';

import 'dart:convert';

import '../utilities/utility.dart';

import 'credit_spend_display_screen.dart';

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
    if (_summaryData[position]['item'] == "credit") {
      if (_selectedMonth == '') {
        return Icon(Icons.check_box_outline_blank, color: Color(0xFF2e2e2e));
      } else {
        return GestureDetector(
          onTap: () => _goUcCardSpendDisplayScreen(),
          child: Icon(
            Icons.credit_card,
            color: Colors.greenAccent,
          ),
        );
      }
    } else {
      return Icon(Icons.check_box_outline_blank, color: Color(0xFF2e2e2e));
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
}
