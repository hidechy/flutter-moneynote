import 'package:flutter/material.dart';
import 'package:moneynote/utilities/utility.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

import 'package:toast/toast.dart';

class HolidaySettingScreen extends StatefulWidget {
  @override
  _HolidaySettingScreenState createState() => _HolidaySettingScreenState();
}

class _HolidaySettingScreenState extends State<HolidaySettingScreen> {
  Utility _utility = Utility();

  final TextEditingController _textController = TextEditingController();

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
//    _utility.load('HolidaySetting.txt').then((String value) {
//      _textController.text = value;
//      setState(() {});
//    });
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Holiday Setting',
          style: const TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveHoliday(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.black.withOpacity(0.3),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: Colors.black.withOpacity(0.3),
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              maxLines: 20,
                              autofocus: true,
                              controller: _textController,
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 休日の保存
   */
  _saveHoliday() async {
    if (_textController.text == '') {
      Toast.show('値が入力されていません', context, duration: Toast.LENGTH_LONG);
      return;
    }

//    _utility.getFilePath('HolidaySetting.txt').then((File file) {
//      file.writeAsString(_textController.text);
//      Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
//    });
  }
}
