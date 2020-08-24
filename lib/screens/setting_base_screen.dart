import 'package:flutter/material.dart';

import 'holiday_year_list_screen.dart';

class SettingBaseScreen extends StatefulWidget {
  @override
  _SettingBaseScreenState createState() => _SettingBaseScreenState();
}

class _SettingBaseScreenState extends State<SettingBaseScreen> {
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
          Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
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

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（SettingBaseScreen）
   */
  _goHolidaySettingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolidayYearListScreen(),
      ),
    );
  }
}
