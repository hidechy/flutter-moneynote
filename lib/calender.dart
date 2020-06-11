import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'screens/detail_display_screen.dart';

class Calender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalenderState();
  }
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("money note"),
        centerTitle: true,
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
}
