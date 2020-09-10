import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database.dart';
import '../main.dart';

class Utility {
  /**
   * 背景取得
   */
  Widget getBackGround() {
    return Image.asset(
      'assets/image/bg.png',
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  /**
   * 日付データ作成
   */
  String year;
  String month;
  String day;
  String youbi;
  String youbiStr;
  int youbiNo;

  void makeYMDYData(String date, int noneDay) {
    List explodedDate = date.split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');
    year = explodedSelectedDate[0];
    month = explodedSelectedDate[1];

    if (noneDay == 1) {
      var f = new NumberFormat("00");
      day = f.format(1);
    } else {
      day = explodedSelectedDate[2];
    }

    DateTime youbiDate =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    youbi = DateFormat('EEEE').format(youbiDate);
    switch (youbi) {
      case "Sunday":
        youbiStr = "日";
        youbiNo = 0;
        break;
      case "Monday":
        youbiStr = "月";
        youbiNo = 1;
        break;
      case "Tuesday":
        youbiStr = "火";
        youbiNo = 2;
        break;
      case "Wednesday":
        youbiStr = "水";
        youbiNo = 3;
        break;
      case "Thursday":
        youbiStr = "木";
        youbiNo = 4;
        break;
      case "Friday":
        youbiStr = "金";
        youbiNo = 5;
        break;
      case "Saturday":
        youbiStr = "土";
        youbiNo = 6;
        break;
    }
  }

  /**
   * 月末日取得
   */
  String monthEndDateTime;
  void makeMonthEnd(int year, int month, int day) {
    monthEndDateTime = new DateTime(year, month, day).toString();
  }

  /**
   * 合計金額取得
   */
  int total = 0;
  int temochi = 0;
  int undercoin = 0;
  void makeTotal(Monie money) {
    List<List<int>> _totalValue = List();
    _totalValue.add([10000, int.parse(money.strYen10000)]);
    _totalValue.add([5000, int.parse(money.strYen5000)]);
    _totalValue.add([2000, int.parse(money.strYen2000)]);
    _totalValue.add([1000, int.parse(money.strYen1000)]);
    _totalValue.add([500, int.parse(money.strYen500)]);
    _totalValue.add([100, int.parse(money.strYen100)]);
    _totalValue.add([50, int.parse(money.strYen50)]);
    _totalValue.add([10, int.parse(money.strYen10)]);
    _totalValue.add([5, int.parse(money.strYen5)]);
    _totalValue.add([1, int.parse(money.strYen1)]);
    temochi = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      temochi += (_totalValue[i][0] * _totalValue[i][1]);
    }
    _totalValue.add([1, int.parse(money.strBankA)]);
    _totalValue.add([1, int.parse(money.strBankB)]);
    _totalValue.add([1, int.parse(money.strBankC)]);
    _totalValue.add([1, int.parse(money.strBankD)]);
    _totalValue.add([1, int.parse(money.strBankE)]);
    _totalValue.add([1, int.parse(money.strBankF)]);
    _totalValue.add([1, int.parse(money.strBankG)]);
    _totalValue.add([1, int.parse(money.strBankH)]);

    _totalValue.add([1, int.parse(money.strPayA)]);
    _totalValue.add([1, int.parse(money.strPayB)]);
    _totalValue.add([1, int.parse(money.strPayC)]);
    _totalValue.add([1, int.parse(money.strPayD)]);
    _totalValue.add([1, int.parse(money.strPayE)]);
    _totalValue.add([1, int.parse(money.strPayF)]);
    _totalValue.add([1, int.parse(money.strPayG)]);
    _totalValue.add([1, int.parse(money.strPayH)]);
    total = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      total += (_totalValue[i][0] * _totalValue[i][1]);
    }
    undercoin = 0;
    List<List<int>> _uc = List();
    _uc.add([10, int.parse(money.strYen10)]);
    _uc.add([5, int.parse(money.strYen5)]);
    _uc.add([1, int.parse(money.strYen1)]);
    for (int i = 0; i < _uc.length; i++) {
      undercoin += (_uc[i][0] * _uc[i][1]);
    }
  }

  /**
   * 金額を3桁区切りで表示する
   */
  final formatter = NumberFormat("#,###");
  String makeCurrencyDisplay(String text) {
    return formatter.format(int.parse(text));
  }

  /**
   * 詳細画面表示情報を取得する
   */
  Future<Map> getDetailDisplayArgs(String date) async {
    Map _monieArgs = Map();

    makeYMDYData(date, 0);
    var yesterday =
        new DateTime(int.parse(year), int.parse(month), int.parse(day) - 1);
    var lastMonthEnd = new DateTime(int.parse(year), int.parse(month), 0);

    //①　当日データ
    var todayData = await database.selectRecord('${year}-${month}-${day}');
    _monieArgs['today'] = (todayData.length > 0) ? todayData : null;

    //②　前日データ
    makeYMDYData(yesterday.toString(), 0);
    var yesterdayData = await database.selectRecord('${year}-${month}-${day}');
    _monieArgs['yesterday'] = (yesterdayData.length > 0) ? yesterdayData : null;

    //③　先月末データ
    makeYMDYData(lastMonthEnd.toString(), 0);
    var lastMonthEndData =
        await database.selectRecord('${year}-${month}-${day}');
    _monieArgs['lastMonthEnd'] =
        (lastMonthEndData.length > 0) ? lastMonthEndData : null;

    return _monieArgs;
  }
}
