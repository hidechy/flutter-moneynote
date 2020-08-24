import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

import '../main.dart';

class Utility {
  /**
   * 背景取得
   */
  getBackGround() {
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

  makeYMDYData(String date, int noneDay) {
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
  makeMonthEnd(int year, int month, int day) {
    monthEndDateTime = new DateTime(year, month, day).toString();
  }

  /**
   * 合計金額取得
   */
  int total = 0;
  int temochi = 0;
  int undercoin = 0;
  makeTotal(_monieData) {
    List<List<String>> _totalValue = List();

    _totalValue.add(['10000', _monieData[0].strYen10000]);
    _totalValue.add(['5000', _monieData[0].strYen5000]);
    _totalValue.add(['2000', _monieData[0].strYen2000]);
    _totalValue.add(['1000', _monieData[0].strYen1000]);
    _totalValue.add(['500', _monieData[0].strYen500]);
    _totalValue.add(['100', _monieData[0].strYen100]);
    _totalValue.add(['50', _monieData[0].strYen50]);
    _totalValue.add(['10', _monieData[0].strYen10]);
    _totalValue.add(['5', _monieData[0].strYen5]);
    _totalValue.add(['1', _monieData[0].strYen1]);

    temochi = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      temochi += (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
    }

    _totalValue.add(['1', _monieData[0].strBankA]);
    _totalValue.add(['1', _monieData[0].strBankB]);
    _totalValue.add(['1', _monieData[0].strBankC]);
    _totalValue.add(['1', _monieData[0].strBankD]);
    _totalValue.add(['1', _monieData[0].strBankE]);
    _totalValue.add(['1', _monieData[0].strBankF]);
    _totalValue.add(['1', _monieData[0].strBankG]);
    _totalValue.add(['1', _monieData[0].strBankH]);

    _totalValue.add(['1', _monieData[0].strPayA]);
    _totalValue.add(['1', _monieData[0].strPayB]);
    _totalValue.add(['1', _monieData[0].strPayC]);
    _totalValue.add(['1', _monieData[0].strPayD]);
    _totalValue.add(['1', _monieData[0].strPayE]);
    _totalValue.add(['1', _monieData[0].strPayF]);
    _totalValue.add(['1', _monieData[0].strPayG]);
    _totalValue.add(['1', _monieData[0].strPayH]);

    total = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      total += (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
    }

    undercoin = 0;
    List<List<String>> _uc = List();
    _uc.add(['10', _monieData[0].strYen10]);
    _uc.add(['5', _monieData[0].strYen5]);
    _uc.add(['1', _monieData[0].strYen1]);
    for (int i = 0; i < _uc.length; i++) {
      undercoin += (int.parse(_uc[i][0]) * int.parse(_uc[i][1]));
    }
  }

  /**
   * 金額を3桁区切りで表示する
   */
  final formatter = NumberFormat("#,###");
  makeCurrencyDisplay(String text) {
    return formatter.format(int.parse(text));
  }

  /**
   * 休業日情報を取得する
   */
  Map<String, dynamic> _holidayList = Map();
  getHolidayList() async {
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }
  }

  /**
   * リストの背景色を取得する
   */
  getListBgColor(String date) {
    makeYMDYData(date, 0);

    Color _color = null;

    switch (youbiNo) {
      case 0:
        _color = Colors.redAccent[700].withOpacity(0.3);
        break;

      case 6:
        _color = Colors.blueAccent[700].withOpacity(0.3);
        break;

      default:
        _color = Colors.black.withOpacity(0.3);
        break;
    }

    getHolidayList();
    if (_holidayList[date] != null) {
      _color = Colors.greenAccent[700].withOpacity(0.3);
    }

    return _color;
  }

  /**
   * 詳細画面表示情報を取得する
   */
  getMoneyArgs(String date) async {
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
