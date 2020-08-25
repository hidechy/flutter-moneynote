import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';

import 'screens/monthly_list_screen.dart';
import 'screens/oneday_input_screen.dart';
import 'screens/score_list_screen.dart';
import 'screens/detail_display_screen.dart';

import 'utilities/utility.dart';

class Calender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalenderState();
  }
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();

  Utility _utility = Utility();
  String year;
  String month;
  String day;
  String youbiStr;

  String _date;

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text("money note"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: 'score',
            onPressed: () => _goScoreDisplayScreen(),
            color: Colors.blueAccent,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'list',
            onPressed: () => _goMonthlyScreen(),
            color: Colors.blueAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Container(
            child: CalendarCarousel<Event>(
              locale: 'JA',

              todayBorderColor: Colors.amber[600],
              todayButtonColor: Colors.amber[900],

              selectedDayBorderColor: Colors.blue[600],
              selectedDayButtonColor: Colors.blue[900],

              thisMonthDayBorderColor: Colors.grey,

              weekendTextStyle: TextStyle(
                  fontSize: 16.0, color: Colors.red, fontFamily: 'Yomogi'),
              weekdayTextStyle: TextStyle(color: Colors.grey),
              dayButtonColor: Colors.black.withOpacity(0.3),

              onDayPressed: onDayPressed,
              weekFormat: false,
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: false,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              daysTextStyle: TextStyle(
                  fontSize: 16.0, color: Colors.white, fontFamily: 'Yomogi'),
              todayTextStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: 'Yomogi',
              ),

              headerTextStyle: TextStyle(fontSize: 18.0, fontFamily: 'Yomogi'),
              selectedDayTextStyle: TextStyle(fontFamily: 'Yomogi'),
              prevDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
              nextDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),

//markedDateCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),
//markedDateMoreCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),

//inactiveDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
//inactiveWeekendTextStyle: TextStyle(fontFamily: 'Yomogi'),
            ),
          ),
          //////////////////////////////////
          Column(
            children: <Widget>[
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.black.withOpacity(0.1),
                  onPressed: () => _goOnedayInputScreen(),
                  child: Icon(
                    Icons.input,
                    color: Colors.greenAccent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
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
    _goDetailDisplayScreen(
      context,
      _currentDate.toString(),
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen(BuildContext context, String date) async {
    var moneyArgs = await _utility.getDetailDisplayArgs(date);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          moneyArgs: moneyArgs,
        ),
      ),
    );
  }

  /**
   * 画面遷移（ScoreListScreen）
   */
  _goScoreDisplayScreen() {
    _utility.makeYMDYData(_currentDate.toString(), 0);

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
  _goMonthlyScreen() {
    _utility.makeYMDYData(_currentDate.toString(), 0);

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
  _goOnedayInputScreen() {
    _utility.makeYMDYData(_currentDate.toString(), 0);

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
