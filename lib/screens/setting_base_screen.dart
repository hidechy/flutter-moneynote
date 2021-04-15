import 'package:flutter/material.dart';
import 'package:moneynote/utilities/utility.dart';

import 'holiday_year_list_screen.dart';

class SettingBaseScreen extends StatefulWidget {
  @override
  _SettingBaseScreenState createState() => _SettingBaseScreenState();
}

class _SettingBaseScreenState extends State<SettingBaseScreen> {
  Utility _utility = Utility();

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.black.withOpacity(0.3),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text(
                      'Holiday Setting',
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () => _goHolidaySettingScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（HolidayYearListScreen）
   */
  void _goHolidaySettingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolidayYearListScreen(),
      ),
    );
  }
}
