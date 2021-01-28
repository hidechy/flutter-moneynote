import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'main.dart';

import 'screens/monthly_list_screen.dart';
import 'screens/oneday_input_screen.dart';
import 'screens/score_list_screen.dart';
import 'screens/detail_display_screen.dart';

import 'utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'package:toast/toast.dart';

class Calender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalenderState();
  }
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  Utility _utility = Utility();
  String year;
  String month;
  String day;
  String youbiStr;

  EventList<Event> _markedDateMap = new EventList<Event>();

  Widget _summaryDataWidget;

  int _total = 0;

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
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _utility.makeYMDYData(holidays[i].strDate, 0);

        _markedDateMap.add(
          new DateTime(int.parse(_utility.year), int.parse(_utility.month),
              int.parse(_utility.day)),
          new Event(
            date: new DateTime(
              int.parse(_utility.year),
              int.parse(_utility.month),
              int.parse(_utility.day),
            ),
            icon: Icon(Icons.flag),
          ),
        );
      }
    }

    //
    _utility.makeYMDYData(_currentMonth.toString(), 0);
    _summaryDataWidget = await _makeSpendSummaryData(
        date: '${_utility.year}-${_utility.month}-01');

    Toast.show('呼び出し完了', context, duration: Toast.LENGTH_LONG);

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          CalendarCarousel<Event>(
            markedDatesMap: _markedDateMap,

            locale: 'JA',

            todayBorderColor: Colors.amber[600],
            todayButtonColor: Colors.amber[900],

            selectedDayBorderColor: Colors.blue[600],
            selectedDayButtonColor: Colors.blue[900],

            thisMonthDayBorderColor: Colors.grey,

            weekendTextStyle: TextStyle(fontSize: 16.0, color: Colors.red),
            weekdayTextStyle: TextStyle(color: Colors.grey),
            dayButtonColor: Colors.black.withOpacity(0.3),

            onDayPressed: onDayPressed,

            onCalendarChanged: onCalendarChanged,

            weekFormat: false,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: false,
            customGridViewPhysics: NeverScrollableScrollPhysics(),
            daysTextStyle: TextStyle(fontSize: 16.0, color: Colors.white),
            todayTextStyle: TextStyle(fontSize: 16.0, color: Colors.white),

            headerTextStyle: TextStyle(fontSize: 18.0),

//            selectedDayTextStyle: TextStyle(fontFamily: 'Yomogi'),
//            prevDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
//            nextDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),

//markedDateCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),
//markedDateMoreCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),

//inactiveDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
//inactiveWeekendTextStyle: TextStyle(fontFamily: 'Yomogi'),
          ),
          //////////////////////////////////
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                          '${_utility.makeCurrencyDisplay(_total.toString())}'),
                    ),
                    IconButton(
                      color: Colors.greenAccent,
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _reloadSummaryData(),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 210,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: _summaryDataWidget,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.black.withOpacity(0.5),
                          onPressed: () => _goOnedayInputScreen(
                              context: context, date: _currentDate.toString()),
                          child: Icon(
                            Icons.input,
                            color: Colors.greenAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.black.withOpacity(0.5),
                          onPressed: () => _goScoreDisplayScreen(
                              context: context, date: _currentDate.toString()),
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.blueAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.black.withOpacity(0.5),
                          onPressed: () => _goMonthlyScreen(
                              context: context, date: _currentDate.toString()),
                          child: Icon(
                            Icons.list,
                            color: Colors.blueAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * カレンダー日付クリック
   */
  void onDayPressed(DateTime date, List<Event> events) async {
    this.setState(() => _currentDate = date);

    //画面遷移
    _goDetailDisplayScreen(context: context, date: _currentDate.toString());
  }

  void onCalendarChanged(DateTime date) async {
    this.setState(() => _currentMonth = date);

    _total = 0;
    _summaryDataWidget = null;

    _utility.makeYMDYData(date.toString(), 0);
    _summaryDataWidget = await _makeSpendSummaryData(
        date: '${_utility.year}-${_utility.month}-01');

    Toast.show('呼び出し完了', context, duration: Toast.LENGTH_LONG);

    setState(() {});
  }

  /**
   *
   */
  Future<Widget> _makeSpendSummaryData({String date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthsummary";
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = json.encode({"date": date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      var data = Map();
      data = jsonDecode(response.body);

      return ListView(
        children: _makeSpendSummaryDataRow(data: data['data']),
      );
    } else {
      return Container();
    }
  }

  /**
   *
   */
  List _makeSpendSummaryDataRow({List data}) {
    List<Widget> _dataList = List();

    _total = 0;
    for (var i = 0; i < data.length; i++) {
      _total += data[i]['sum'];
    }

    var _loopNum = (data.length / 2).ceil();
    for (var i = 0; i < _loopNum; i++) {
      var _number = (i * 2);
      _dataList.add(
        Row(
          children: <Widget>[
            (data[_number] == null)
                ? _getExpandedContainer()
                : _getTextDisplayContainer(
                    text: data[_number]['item'], currency: false),
            (data[_number] == null)
                ? _getExpandedContainer()
                : _getTextDisplayContainer(
                    text: data[_number]['sum'].toString(), currency: true),
            (_number + 1 >= data.length)
                ? _getExpandedContainer()
                : _getTextDisplayContainer(
                    text: data[_number + 1]['item'], currency: false),
            (_number + 1 >= data.length)
                ? _getExpandedContainer()
                : _getTextDisplayContainer(
                    text: data[_number + 1]['sum'].toString(), currency: true),
          ],
        ),
      );
    }

    return _dataList;
  }

  /**
   *
   */
  Widget _getExpandedContainer() {
    return Expanded(
      child: Container(),
    );
  }

  /**
   *
   */
  Widget _getTextDisplayContainer({String text, bool currency}) {
    if (currency) {
      return Expanded(
        child: Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(top: 3, right: 5, left: 5),
          child: DefaultTextStyle(
            style:
                TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8)),
            child: Text('${_utility.makeCurrencyDisplay(text)}'),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(right: 5, left: 5),
          child: DefaultTextStyle(
            style:
                TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8)),
            child: Text('${text}'),
          ),
        ),
      );
    }
  }

  /**
   *
   */
  void _reloadSummaryData() async {
    _total = 0;
    _summaryDataWidget = null;

    _utility.makeYMDYData(_currentMonth.toString(), 0);
    _summaryDataWidget = await _makeSpendSummaryData(
        date: '${_utility.year}-${_utility.month}-01');

    Toast.show('呼び出し完了', context, duration: Toast.LENGTH_LONG);

    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen({BuildContext context, String date}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);
    _utility.makeYMDYData(date, 0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: int.parse(_utility.day),
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }

  /**
   * 画面遷移（ScoreListScreen）
   */
  _goScoreDisplayScreen({BuildContext context, String date}) {
    _utility.makeYMDYData(date, 0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreListScreen(
          date: _utility.year + "-" + _utility.month + "-" + _utility.day,
        ),
      ),
    );
  }

  /**
   * 画面遷移（MonthlyListScreen）
   */
  _goMonthlyScreen({BuildContext context, String date}) {
    _utility.makeYMDYData(date, 0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: _utility.year + "-" + _utility.month + "-" + _utility.day,
        ),
      ),
    );
  }

  /**
   * 画面遷移（OnedayInputScreen）
   */
  _goOnedayInputScreen({BuildContext context, String date}) {
    _utility.makeYMDYData(date, 0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: _utility.year + "-" + _utility.month + "-" + _utility.day,
        ),
      ),
    );
  }
}
