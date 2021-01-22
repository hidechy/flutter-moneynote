import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../utilities/utility.dart';

class GraphDisplayScreen extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String date;
  final List graphData;
  final Map holidayList;
  GraphDisplayScreen(
      {this.seriesList,
      this.animate,
      this.date,
      this.graphData,
      this.holidayList});

  Utility _utility = Utility();

  /**
   *
   */
  factory GraphDisplayScreen.withSampleData(
      {String date, List graphdata, Map holidayList}) {
    return new GraphDisplayScreen(
        seriesList: _createSampleData(graphdata: graphdata),
        animate: false,
        date: date,
        graphData: graphdata,
        holidayList: holidayList);
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(date, 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${_utility.year}-${_utility.month}'),
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
              Container(
                height: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white.withOpacity(0.8),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: new charts.TimeSeriesChart(
                      seriesList,
                      animate: animate,
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _graphList(),
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
  Widget _graphList() {
    return ListView.builder(
      itemCount: graphData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    _utility.makeYMDYData(graphData[position]['date'], 0);

    return Card(
      color: _utility.getBgColor(graphData[position]['date'], holidayList),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    '${graphData[position]['date']}（${_utility.youbiStr}）'),
              ),
              Container(
                child: Text(
                    '${_utility.makeCurrencyDisplay(graphData[position]['total'].toString())}'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  static List<charts.Series<MoneyData, DateTime>> _createSampleData(
      {List graphdata}) {
    final data = List<MoneyData>();
    for (int i = 0; i < graphdata.length; i++) {
      var ex_date = graphdata[i]['date'].split('-');
      var _datetime = new DateTime(
        int.parse(ex_date[0]),
        int.parse(ex_date[1]),
        int.parse(ex_date[2]),
      );
      var _value = int.parse(graphdata[i]['total']);
      data.add(
        new MoneyData(_datetime, _value),
      );
    }

    return [
      new charts.Series<MoneyData, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MoneyData sales, _) => sales.time,
        measureFn: (MoneyData sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class MoneyData {
  final DateTime time;
  final int sales;

  MoneyData(this.time, this.sales);
}
