import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';

class BalancesheetDataDisplayScreen extends StatefulWidget {
  @override
  _BalancesheetDataDisplayScreenState createState() =>
      _BalancesheetDataDisplayScreenState();
}

class _BalancesheetDataDisplayScreenState
    extends State<BalancesheetDataDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _BalanceSheetData = List();

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
    String url = "http://toyohide.work/BrainLog/api/getBalanceSheetRecord";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _BalanceSheetData.add(_makeListData(data: data['data'][i]));
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Balance Sheet'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.skip_previous),
          //   tooltip: '前日',
          //   onPressed: () => _goMonthlyListScreen(
          //       context: context, date: _prevMonth.toString()),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.skip_next),
          //   tooltip: '翌日',
          //   onPressed: () => _goMonthlyListScreen(
          //       context: context, date: _nextMonth.toString()),
          // ),
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
              Expanded(
                child: _BalanceSheetList(),
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
  Widget _BalanceSheetList() {
    return ListView.builder(
      itemCount: _BalanceSheetData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 2,
      child: Card(
        color: Colors.black.withOpacity(0.3),
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text('${_BalanceSheetData[position]['ym']}'),
                ),
                _getAssetsWidget(data: _BalanceSheetData[position]),
                Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 10),
                    child:
                        Text('${_BalanceSheetData[position]['assets_total']}')),
                _getCapitalWidget(data: _BalanceSheetData[position]),
                Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                        '${_BalanceSheetData[position]['capital_total']}')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  Map _makeListData({data}) {
    Map _map = Map();

    var ex_data = data.split('|');
    for (var i = 0; i < ex_data.length; i++) {
      var ex_ex_data = (ex_data[i]).split(':');
      _map[ex_ex_data[0]] = ex_ex_data[1];
    }

    return _map;
  }

  /**
   *
   */
  Widget _getAssetsWidget({Map data}) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.3),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('【現金及び預金合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_deposit_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_deposit_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_deposit_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_deposit_end']}')),
              ]),
            ],
          ),
          Text('【売掛債権合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_receivable_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_receivable_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_receivable_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_receivable_end']}')),
              ]),
            ],
          ),
          Text('【有形固定資産合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_fixed_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_fixed_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_fixed_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_fixed_end']}')),
              ]),
            ],
          ),
          Text('【事業主貸合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_lending_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_lending_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_lending_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_lending_end']}')),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _getCapitalWidget({Map data}) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.3),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('【流動負債合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_liabilities_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child:
                        Text('- ${data['capital_total_liabilities_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child:
                        Text('+ ${data['capital_total_liabilities_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_liabilities_end']}')),
              ]),
            ],
          ),
          Text('【事業主借合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_borrow_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_borrow_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['capital_total_borrow_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_borrow_end']}')),
              ]),
            ],
          ),
          Text('【元入金】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_principal_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_principal_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['capital_total_principal_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_principal_end']}')),
              ]),
            ],
          ),
          Text('【控除前所得合計】'),
          Table(
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_income_start']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_income_debit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['capital_total_income_credit']}')),
                Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_income_end']}')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
