import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
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
  _goldList() {
    return ListView.builder(
      itemCount: _goldData.length,
      itemBuilder: (context, int position) {
        return _listItem(position: position);
      },
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var date =
        '${_goldData[position]['year']}-${_goldData[position]['month']}-${_goldData[position]['day']}';
    _utility.makeYMDYData(date, 0);

    return Container(
      decoration: BoxDecoration(
        color: _utility.getBgColor(date, _holidayList),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${date}（${_utility.youbiStr}）'),
                      (_goldData[position]['gold_value'] == "-")
                          ? Text('')
                          : Text(
                              '${_utility.makeCurrencyDisplay(_goldData[position]['gold_value'].toString())}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          (_goldData[position]['total_gram'] == "-")
                              ? Text('')
                              : Text(
                                  '(total gram)　${_goldData[position]['total_gram']}　g'),
                          (_goldData[position]['gram_num'] == "-")
                              ? Text('')
                              : Text(
                                  '(today add)　${_goldData[position]['gram_num']}　g'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          (_goldData[position]['gold_tanka'] == "-")
                              ? Text('')
                              : Text(
                                  '1g　${_utility.makeCurrencyDisplay(_goldData[position]['gold_tanka'])}'),
                          (_goldData[position]['diff'] == "-")
                              ? Text('')
                              : Text('${_goldData[position]['diff']}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: _getUpDownMark(updown: _goldData[position]['up_down']),
              //child: Text('${_goldData[position]['up_down']}'),
              // child: (_goldData[position]['up_down'] == "-")
              //     ? Text('')
              //     : (_goldData[position]['up_down'] == 9)
              //         ? Icon(Icons.crop_square, color: Colors.black)
              //         : (_goldData[position]['up_down'] == 1)
              //             ? Icon(Icons.arrow_upward, color: Colors.greenAccent)
              //             : Icon(
              //                 Icons.arrow_downward,
              //                 color: Colors.redAccent,
              //               ),
            ),
          ],
        ),
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
}
