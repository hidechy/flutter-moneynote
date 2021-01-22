import 'dart:math';

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../utilities/utility.dart';

class SummaryChartDisplayScreen extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String year;
  final String month;
  final List piechartData;
  SummaryChartDisplayScreen(
      {this.seriesList,
      this.animate,
      this.year,
      this.month,
      this.piechartData});

  Utility _utility = Utility();

  /**
   *
   */
  factory SummaryChartDisplayScreen.withSampleData(
      {List piechartData, String year, String month}) {
    return new SummaryChartDisplayScreen(
      seriesList: _createSampleData(piechartData: piechartData),
      animate: false,
      year: year,
      month: month,
      piechartData: piechartData,
    );
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    var dispYM = "${year}";
    if (month != "") {
      dispYM += "-${month}";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${dispYM}'),
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
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.white.withOpacity(0.8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: new charts.PieChart(
                        seriesList,
                        animate: animate,
                        defaultRenderer: new charts.ArcRendererConfig(
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _piechartList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _piechartList() {
    return ListView.builder(
      itemCount: piechartData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
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
          child: Row(
            children: <Widget>[
              Expanded(child: Text('${piechartData[position]['item']}')),
              Container(
                child: Text(
                    '${_utility.makeCurrencyDisplay(piechartData[position]['sum'].toString())}'),
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
  static List<charts.Series<SpendSummary, String>> _createSampleData(
      {List piechartData}) {
    final data = List<SpendSummary>();
    for (var i = 0; i < piechartData.length; i++) {
      data.add(SpendSummary(piechartData[i]['item'], piechartData[i]['sum']));
    }

    return [
      new charts.Series<SpendSummary, String>(
        id: 'Sales',
        domainFn: (SpendSummary sales, _) => sales.item,
        measureFn: (SpendSummary sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (SpendSummary row, _) => '${row.item}: ${row.sales}',
      )
    ];
  }
}

//
//

class SpendSummary {
  final String item;
  final int sales;

  SpendSummary(this.item, this.sales);
}
