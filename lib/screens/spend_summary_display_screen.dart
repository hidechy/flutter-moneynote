import 'package:flutter/material.dart';
import 'package:moneynote/screens/summary_chart_display_screen.dart';
import 'package:moneynote/utilities/utility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'credit_spend_display_screen.dart';

class SpendSummaryDisplayScreen extends StatefulWidget {
  final String date;

  SpendSummaryDisplayScreen({@required this.date});

  @override
  _SpendSummaryDisplayScreenState createState() =>
      _SpendSummaryDisplayScreenState();
}

class _SpendSummaryDisplayScreenState extends State<SpendSummaryDisplayScreen> {
  Utility _utility = Utility();

  List<DropdownMenuItem<String>> _dropdownYears = List();

  String _selectedYear = '';
  String _selectedMonth = '';
  int _total = 0;

  List<dynamic> _yearMonth = List();

  List<Map<dynamic, dynamic>> _summaryData = List();

  List<Map<dynamic, dynamic>> _piechartData = List();

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

    for (int i = int.parse(explodedSelectedDate[0]); i >= 2019; i--) {
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

    ///////////////////////
    String url = "http://toyohide.work/BrainLog/api/yearsummary";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      _total = 0;
      for (var i = 0; i < data['data'].length; i++) {
        _total += data['data'][i]['sum'];

        Map _map = Map();
        _map['item'] = data['data'][i]['item'];
        _map['sum'] = data['data'][i]['sum'];
        _map['percent'] = data['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData.add(_map);

        Map _map2 = Map();
        _map2['item'] = data['data'][i]['item'];
        _map2['sum'] = data['data'][i]['sum'];
        _piechartData.add(_map2);
      }
    }
    ///////////////////////
    for (int i = 1; i <= 12; i++) {
      _yearMonth.add(i.toString().padLeft(2, '0'));
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
        title: Text('Spend Summary'),
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
          _summaryDisplayBox(context),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _summaryDisplayBox(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.only(top: 5),
              color: Colors.black.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  left: 20.0,
                ),
                child: DropdownButton(
                  dropdownColor: Colors.black.withOpacity(0.1),
                  items: _dropdownYears,
                  value: _selectedYear,
                  onChanged: (value) =>
                      _goSpendSummaryDisplayScreen(value: value),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                padding: EdgeInsets.all(8),
                alignment: Alignment.topRight,
                width: double.infinity,
                child:
                    Text('${_utility.makeCurrencyDisplay(_total.toString())}'),
              ),
            ),
            Container(
              width: 60,
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.chartPie),
                color: Colors.greenAccent,
                onPressed: () => _goSummaryChartDisplayScreen(),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                child: _monthList(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  child: _summaryList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Widget _monthList() {
    return ListView.builder(
      itemCount: _yearMonth.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    return Card(
      color: (_yearMonth[position] == _selectedMonth)
          ? Colors.orangeAccent.withOpacity(0.3)
          : Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Text('${_yearMonth[position]}'),
        ),
        onTap: () => _monthSummaryDisplay(month: _yearMonth[position]),
      ),
    );
  }

  /**
   *
   */
  Future<void> _monthSummaryDisplay({month}) async {
    _selectedMonth = month;

    List<Map<dynamic, dynamic>> _summaryData2 = List();

    List<Map<dynamic, dynamic>> _piechartData2 = List();

    String url = "http://toyohide.work/BrainLog/api/monthsummary";
    Map<String, String> headers = {'content-type': 'application/json'};
    String date = "${_selectedYear}-${month}-01";

    String body = json.encode({"date": date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      _total = 0;
      for (var i = 0; i < data['data'].length; i++) {
        _total += data['data'][i]['sum'];

        Map _map = Map();
        _map['item'] = data['data'][i]['item'];
        _map['sum'] = data['data'][i]['sum'];
        _map['percent'] = data['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData2.add(_map);

        Map _map2 = Map();
        _map2['item'] = data['data'][i]['item'];
        _map2['sum'] = data['data'][i]['sum'];
        _piechartData2.add(_map2);
      }
    }

    _summaryData = _summaryData2;

    _piechartData = _piechartData2;

    setState(() {});
  }

  /**
   *
   */
  Widget _summaryList() {
    return ListView.builder(
      itemCount: _summaryData.length,
      itemBuilder: (context, int position) => _listItem2(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem2({int position}) {
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
  void _goSummaryChartDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryChartDisplayScreen.withSampleData(
          piechartData: _piechartData,
          year: _selectedYear,
          month: _selectedMonth,
        ),
      ),
    );
  }
}
