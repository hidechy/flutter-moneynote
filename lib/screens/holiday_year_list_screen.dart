import 'package:flutter/material.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';

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
  void _makeDefaultDisplayData() async {
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Holiday Setting Year List'),
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
          _alldayList(),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _alldayList() {
    return ListView.builder(
      itemCount: _yearData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: _getBgColor(position: position),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Text('${_yearData[position]}'),
        ),
        onTap: () =>
            _goHolidaySettingScreen(context: context, position: position),
      ),
    );
  }

  /**
   * 背景色取得
   */
  Color _getBgColor({int position}) {
    Color _color = null;
    _color = Colors.black.withOpacity(0.3);
    return _color;
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /**
   * 画面遷移（_goHolidaySettingScreen）
   */
  void _goHolidaySettingScreen({BuildContext context, int position}) {
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
