import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../utilities/utility.dart';

//
//
//

class GraphDisplayScreen extends StatelessWidget {
  final String date;
  final List graphdata;
  GraphDisplayScreen({@required this.date, @required this.graphdata});

  Utility _utility = Utility();

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
      body: SimpleTimeSeriesChart.withSampleData(
        date: date,
        graphdata: graphdata,
      ),
    );
  }
}

//
//
//

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String date;
  SimpleTimeSeriesChart({this.seriesList, this.animate, this.date});

  Utility _utility = Utility();

  /**
   *
   */
  factory SimpleTimeSeriesChart.withSampleData({String date, List graphdata}) {
    return new SimpleTimeSeriesChart(
      seriesList: _createSampleData(graphdata: graphdata),
      animate: false,
      date: date,
    );
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _utility.getBackGround(),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          child: new charts.TimeSeriesChart(
            seriesList,
            animate: animate,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
          ),
        ),
      ],
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
      data.add(new MoneyData(_datetime, _value));
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

//
//
//

class MoneyData {
  final DateTime time;
  final int sales;

  MoneyData(this.time, this.sales);
}
