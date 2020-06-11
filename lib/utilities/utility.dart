import 'package:intl/intl.dart';

class Utility {
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

    _totalValue.add(['1', _monieData[0].strBankA]);
    _totalValue.add(['1', _monieData[0].strBankB]);
    _totalValue.add(['1', _monieData[0].strBankC]);
    _totalValue.add(['1', _monieData[0].strBankD]);

    _totalValue.add(['1', _monieData[0].strPayA]);
    _totalValue.add(['1', _monieData[0].strPayB]);

    total = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      total += (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
    }
  }
}
