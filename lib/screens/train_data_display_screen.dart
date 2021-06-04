import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/custom_shape_clipper.dart';
import '../utilities/utility.dart';

import '../main.dart';

class TrainDataDisplayScreen extends StatefulWidget {
  @override
  _TrainDataDisplayScreenState createState() => _TrainDataDisplayScreenState();
}

class _TrainDataDisplayScreenState extends State<TrainDataDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _trainData = List();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int maxNo = 0;

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
    Map train = Map();

    String url = "http://toyohide.work/BrainLog/api/gettraindata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ""});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      train = jsonDecode(response.body);

//      print(traindata);

      train['data'].forEach((key, value) {
        Map _map = Map();
        _map['date'] = key;
        _map['value'] = value[0];
        _trainData.add(_map);
      });
    }
    //----------------------------//

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    maxNo = _trainData.length;

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
        title: Text('Train List'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_downward),
          color: Colors.greenAccent,
          onPressed: () => _scroll(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goTrainDataDisplayScreen(),
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
                child: _trainList(),
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
   * リスト表示
   */
  Widget _trainList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
      },
      itemCount: _trainData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    _utility.makeYMDYData(_trainData[position]['date'], 0);

    return Card(
      color: _utility.getBgColor(_trainData[position]['date'], _holidayList),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
          title: DefaultTextStyle(
        style: TextStyle(fontSize: 12),
        child: Table(
          children: [
            TableRow(children: [
              Text(
                  '${_utility.year}-${_utility.month}-${_utility.day}（${_utility.youbiStr}）'),
              Text('${_trainData[position]['value']}'),
            ]),
          ],
        ),
      )),
    );
  }

  /**
   *
   */
  void _goTrainDataDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TrainDataDisplayScreen(),
      ),
    );
  }
}
