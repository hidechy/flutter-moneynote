import 'package:flutter/material.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import '../db/database.dart';
import '../utilities/utility.dart';

class HolidaySettingScreen extends StatefulWidget {
  final String date;
  final int point;
  HolidaySettingScreen({@required this.date, this.point});

  @override
  _HolidaySettingScreenState createState() => _HolidaySettingScreenState();
}

class _HolidaySettingScreenState extends State<HolidaySettingScreen> {
  Utility _utility = Utility();

  String _year = '';

  List<Map<dynamic, dynamic>> _yearDateList = List();

  AutoScrollController _controller = AutoScrollController();

  Map<String, dynamic> _holidayList = Map();

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
    /////////////////////////////////////////////////////
    _utility.makeYMDYData(widget.date, 0);
    _year = _utility.year;

    var nextYearFirstDate = new DateTime(int.parse(_utility.year) + 1, 1, 1);

    int diffDays =
        nextYearFirstDate.difference(DateTime.parse(widget.date)).inDays;

    for (int i = 0; i < diffDays; i++) {
      var value = new DateTime(int.parse(_utility.year),
          int.parse(_utility.month), int.parse(_utility.day) + i);

      var ex_value = (value.toString()).split(' ');

      var _map = Map();
      _map['no'] = i;
      _map['date'] = ex_value[0];

      _yearDateList.add(_map);
    }

    /////////////////////////////////////////////////////
    _controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      axis: Axis.vertical,
    );

    await _controller.scrollToIndex(widget.point,
        preferPosition: AutoScrollPosition.begin);

    /////////////////////////////////////////////////////

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Holiday Setting [${_year}]'),
        centerTitle: true,
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
          _hidukeList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _hidukeList() {
    return ListView(
      scrollDirection: Axis.vertical,
      controller: _controller,
      children: _yearDateList.map<Widget>((data) {
        return Card(
          color: _utility.getBgColor(data['date'], _holidayList),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            onTap: () =>
                _holidaySetting(counter: data['no'], date: data['date']),
            title: AutoScrollTag(
              index: data['no'],
              child: Text('${data['date']}'),
              key: ValueKey(data['no']),
              controller: _controller,
            ),
          ),
        );
      }).toList(),
    );
  }

  /**
   * 休業日設定
   */
  void _holidaySetting({int counter, String date}) async {
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

    _goHolidaySettingScreen(counter: counter);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（_goHolidaySettingScreen）
   */
  void _goHolidaySettingScreen({int counter}) {
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
