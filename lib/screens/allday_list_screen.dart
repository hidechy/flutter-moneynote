import 'package:flutter/material.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utilities/utility.dart';

import '../main.dart';

class AlldayListScreen extends StatefulWidget {
  final String date;
  AlldayListScreen({@required this.date});

  @override
  _AlldayListScreenState createState() => _AlldayListScreenState();
}

class _AlldayListScreenState extends State<AlldayListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _alldayData = List();

  Map<String, dynamic> _holidayList = Map();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int maxNo = 0;

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
    //全データ取得
    var _monieData = await database.selectSortedAllRecord;
    if (_monieData.length > 0) {
      int _keepTotal = 0;
      int total = 0;
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeTotal(_monieData[i]);
        total = _utility.total;

        var _map = Map();
        _map['date'] = _monieData[i].strDate;
        _map['total'] = total.toString();
        _map['diff'] = ((_keepTotal - total) * -1).toString();

        _alldayData.add(_map);

        _keepTotal = total;
      }
    }

    maxNo = _alldayData.length;

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Allday List'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_downward),
            color: Colors.greenAccent,
            onPressed: () => _scroll(),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.greenAccent,
            onPressed: () => _goAlldayListScreen(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          ScrollablePositionedList.builder(
            itemBuilder: (context, index) {
              return ListTile(title: _listItem(position: index));
            },
            itemCount: _alldayData.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
          ),
        ],
      ),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: _utility.getBgColor(_alldayData[position]['date'], _holidayList),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Table(
            children: [
              TableRow(children: [
                Text('${_alldayData[position]['date']}'),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                      '${_utility.makeCurrencyDisplay(_alldayData[position]['total'])}'),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                      '${_utility.makeCurrencyDisplay(_alldayData[position]['diff'])}'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /**
      *
      */
  void _scroll() {
    _itemScrollController.scrollTo(
      index: maxNo,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  /**
   *
   */
  void _goAlldayListScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AlldayListScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
