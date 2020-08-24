import 'package:flutter/material.dart';
import 'package:moneynote/db/database.dart';
import 'package:moneynote/utilities/utility.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class HolidaySettingScreen extends StatefulWidget {
  final String date;
  final int point;
  HolidaySettingScreen({@required this.date, this.point});

  @override
  _HolidaySettingScreenState createState() => _HolidaySettingScreenState();
}

class _HolidaySettingScreenState extends State<HolidaySettingScreen> {
  Utility _utility = Utility();
  String year;

  List<List<dynamic>> _yearDateList = List();

  AutoScrollController controller;

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
  _makeDefaultDisplayData() async {
    /////////////////////////////////////////////////////
    _utility.makeYMDYData(widget.date, 0);
    year = _utility.year;

    var nextYearFirstDate = new DateTime(int.parse(_utility.year) + 1, 1, 1);

    int diffDays =
        nextYearFirstDate.difference(DateTime.parse(widget.date)).inDays;

    for (int i = 0; i < diffDays; i++) {
      var value = new DateTime(int.parse(_utility.year),
          int.parse(_utility.month), int.parse(_utility.day) + i);

      var ex_value = (value.toString()).split(' ');

      _yearDateList.add([
        i,
        ex_value[0],
      ]);
    }

    /////////////////////////////////////////////////////
    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      axis: Axis.vertical,
    );

    await controller.scrollToIndex(widget.point,
        preferPosition: AutoScrollPosition.begin);

    /////////////////////////////////////////////////////

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holiday Setting [${year}]'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          _hidukeList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  _hidukeList() {
    return ListView(
      scrollDirection: Axis.vertical,
      controller: controller,
      children: _yearDateList.map<Widget>((data) {
        return Card(
          color: _utility.getListBgColor(data[1]),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            onTap: () => _holidaySetting(data[0], data[1]),
            title: AutoScrollTag(
              index: data[0],
              child: Text('${data[1]}'),
              key: ValueKey(data[0]),
              controller: controller,
            ),
          ),
        );
      }).toList(),
    );
  }

  /**
   * 休業日設定
   */
  _holidaySetting(int counter, String date) async {

    var holiday = await database.selectHolidayRecord(date);

    var value = Holiday(strDate: date);

    if (holiday.length > 0) {
      //データがある場合は削除する
      await database.deleteHolidayRecord(value);
      Toast.show('削除が完了しました', context, duration: Toast.LENGTH_LONG);
    } else {
      //データがない場合は登録する
      await database.insertHolidayRecord(value);
      Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    }

    _goHolidaySettingScreen(counter);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（_goHolidaySettingScreen）
   */
  _goHolidaySettingScreen(int counter) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HolidaySettingScreen(
          date: widget.date,
          point: counter,
        ),
      ),
    );
  }
}
