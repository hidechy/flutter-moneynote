import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'screens/monthly_list_screen.dart';
import 'screens/score_list_screen.dart';
import 'utilities/utility.dart';
import 'screens/detail_display_screen.dart';

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
          Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
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
              dayButtonColor: Colors.grey[900],

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
        ],
      ),
    );
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() => _currentDate = date);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: _currentDate.toString(),
        ),
      ),
    );
  }

  /**
   * 画面遷移（ScoreListScreen）
   */
  _goScoreDisplayScreen() {
    _utility.makeYMDYData(_currentDate.toString(), 0);
    year = _utility.year;
    month = _utility.month;
    day = _utility.day;
    _date = year + "-" + month + "-" + day;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreListScreen(
          date: _date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（MonthlyListScreen）
   */
  _goMonthlyScreen() {
    _utility.makeYMDYData(_currentDate.toString(), 0);
    year = _utility.year;
    month = _utility.month;
    day = _utility.day;
    _date = year + "-" + month + "-" + day;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: _date,
        ),
      ),
    );
  }
}
