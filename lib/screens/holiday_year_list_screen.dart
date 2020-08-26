import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import 'holiday_setting_screen.dart';

class HolidayYearListScreen extends StatefulWidget {
  @override
  _HolidayYearListScreenState createState() => _HolidayYearListScreenState();
}

class _HolidayYearListScreenState extends State<HolidayYearListScreen> {
  Utility _utility = Utility();

  List<String> _yearData = List();

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
    _utility.makeYMDYData(DateTime.now().toString(), 0);

    for (int i = 2019; i < int.parse(_utility.year) + 5; i++) {
      _yearData.add(i.toString());
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holiday Setting Year List'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          _alldayList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  _alldayList() {
    return ListView.builder(
      itemCount: _yearData.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  /**
   * リストアイテム表示
   */
  _listItem(int position) {
    return InkWell(
      child: Card(
        color: getBgColor(position),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          child: ListTile(
            title: DefaultTextStyle(
              style: TextStyle(fontSize: 10.0),
              child: Text('${_yearData[position]}'),
            ),
            onTap: () => _goHolidaySettingScreen(context, position),
          ),
        ),
      ),
      //actions: <Widget>[],
    );
  }

  /**
   * 背景色取得
   */
  getBgColor(int position) {
    Color _color = null;
    _color = Colors.black.withOpacity(0.3);
    return _color;
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（_goHolidaySettingScreen）
   */
  _goHolidaySettingScreen(BuildContext context, int position) {
    var date = '${_yearData[position]}-01-01';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolidaySettingScreen(
          date: date,
          point: 0,
        ),
      ),
    );
  }
}
