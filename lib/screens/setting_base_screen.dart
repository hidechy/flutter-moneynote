import 'package:flutter/material.dart';

import 'holiday_setting_screen.dart';
import '../utilities/utility.dart';

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
      appBar: AppBar(
        title: Text(
          'Settings',
          style: const TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Column(
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
        ],
      ),
    );
  }

  /**
   * 画面遷移（SettingBaseScreen）
   */
  _goHolidaySettingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolidaySettingScreen(),
      ),
    );
  }
}
