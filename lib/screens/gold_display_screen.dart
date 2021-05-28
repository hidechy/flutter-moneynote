import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';
import '../main.dart';

class GoldDisplayScreen extends StatefulWidget {
  @override
  _GoldDisplayScreenState createState() => _GoldDisplayScreenState();
}

class _GoldDisplayScreenState extends State<GoldDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _goldData = List();

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
    //----------------------------//
    Map golddata = Map();

    String url = "http://toyohide.work/BrainLog/api/getgolddata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ""});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      golddata = jsonDecode(response.body);

      for (var i = 0; i < golddata['data'].length; i++) {
        _goldData.add(golddata['data'][i]);
      }
    }
    //----------------------------//

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    maxNo = _goldData.length;

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Gold List'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_downward),
          color: Colors.greenAccent,
          onPressed: () => _scroll(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goGoldDisplayScreen(),
            color: Colors.greenAccent,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
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
          Column(
            children: <Widget>[
              Expanded(
                child: _goldList(),
              ),
            ],
          ),
        ],
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
  Widget _goldList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
      },
      itemCount: _goldData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var date =
        '${_goldData[position]['year']}-${_goldData[position]['month']}-${_goldData[position]['day']}';
    _utility.makeYMDYData(date, 0);

    return Card(
      color: _utility.getBgColor(date, _holidayList),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
            style: TextStyle(fontSize: 12),
            child: Column(
              children: <Widget>[
                //----------------------------------
                Container(
                  padding: EdgeInsets.only(right: 80),
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          Text('${date}（${_utility.youbiStr}）'),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    (_goldData[position]['gold_tanka'] == "-")
                                        ? Text('')
                                        : Text(
                                            '1g　${_utility.makeCurrencyDisplay(_goldData[position]['gold_tanka'])}'),
                                    (_goldData[position]['diff'] == "-")
                                        ? Text('')
                                        : Text(
                                            '${_goldData[position]['diff']}'),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: _getUpDownMark(
                                    updown: _goldData[position]['up_down']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //----------------------------------

                Divider(color: Colors.indigo, indent: 10.0, endIndent: 10.0),
                //----------------------------------
                Table(
                  children: [
                    TableRow(
                      children: [
                        (_goldData[position]['gold_value'] == "-")
                            ? Text('')
                            : Text(
                                '${_utility.makeCurrencyDisplay(_goldData[position]['gold_value'].toString())}'),
                        (_goldData[position]['pay_price'] == "-")
                            ? Text('')
                            : Text(
                                '${_utility.makeCurrencyDisplay(_goldData[position]['pay_price'].toString())}'),
                        (_goldData[position]['gold_value'] == "-")
                            ? Text('')
                            : Text(
                                '${_utility.makeCurrencyDisplay((_goldData[position]['gold_value'] - _goldData[position]['pay_price']).toString())}',
                                style: (_goldData[position]['gold_value'] -
                                            _goldData[position]['pay_price'] >
                                        0)
                                    ? TextStyle(color: Colors.yellowAccent)
                                    : TextStyle(color: Colors.redAccent),
                              ),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ],
                ),
                //----------------------------------

                //----------------------------------
                Table(
                  children: [
                    TableRow(
                      children: [
                        Text(''),
                        Text(''),
                        (_goldData[position]['gold_price'] == "-")
                            ? Text('')
                            : Text(
                                '${_utility.makeCurrencyDisplay(_goldData[position]['gold_price'])}'),
                        (_goldData[position]['gram_num'] == "-")
                            ? Text('')
                            : Container(
                                alignment: Alignment.topRight,
                                child:
                                    Text('${_goldData[position]['gram_num']}g'),
                              ),
                        (_goldData[position]['total_gram'] == "-")
                            ? Text('')
                            : Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                    '${_goldData[position]['total_gram']}g'),
                              ),
                      ],
                    ),
                  ],
                ),
                //----------------------------------
              ],
            )),
      ),
    );
  }

  /**
   *
   */
  Widget _getUpDownMark({updown}) {
    switch (updown) {
      case 0:
        return Icon(Icons.arrow_downward, color: Colors.redAccent);
        break;
      case 1:
        return Icon(Icons.arrow_upward, color: Colors.greenAccent);
        break;
      case 9:
        return Icon(Icons.crop_square, color: Colors.black);
        break;
    }
  }

  /**
   *
   */
  void _goGoldDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GoldDisplayScreen(),
      ),
    );
  }
}
