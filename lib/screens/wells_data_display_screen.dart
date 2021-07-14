import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';

class WellsDataDisplayScreen extends StatefulWidget {
  @override
  _WellsDataDisplayScreenState createState() => _WellsDataDisplayScreenState();
}

class _WellsDataDisplayScreenState extends State<WellsDataDisplayScreen> {
  Utility _utility = Utility();

  var _wellsDataList = new List<Wells>();

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
    String url = "http://toyohide.work/BrainLog/api/getWellsRecord";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data["data"].length; i++) {
        var ex_data = (data["data"][i]).split(':');
        List _list = List();
        var ex_datedata = (ex_data[1]).split('/');
        for (var j = 0; j < ex_datedata.length; j++) {
          var ex_dd = (ex_datedata[j]).split('|');
          Map _map = Map();
          _map['num'] = ex_dd[0];
          _map['monthday'] = ex_dd[1];
          _map['price'] = ex_dd[2];
          _map['total'] = ex_dd[3];
          _list.add(_map);
        }
        _wellsDataList
            .add(Wells(isExpanded: false, year: ex_data[0], data: _list));
      }
    }

    print(_wellsDataList);

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

//    var oneHeight = ((size.height) / 2) - 100;
    var oneHeight = (size.height - 100);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Wells Data'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goWellsDataDisplayScreen(),
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
          Container(
            height: oneHeight,
            child: ListView(
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: Colors.black.withOpacity(0.1),
                  ),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      _wellsDataList[index].isExpanded =
                          !_wellsDataList[index].isExpanded;
                      setState(() {});
                    },
                    children: _wellsDataList.map(_createPanel).toList(),
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
   *
   */
  ExpansionPanel _createPanel(Wells __WELLS) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          padding: EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 12),
            child: Text(
              '${__WELLS.year}',
              style: TextStyle(fontSize: 12),
            ),
          ),
        );
      },
      //
      body: Container(
        width: double.infinity,
        color: Colors.white.withOpacity(0.1),
        padding: EdgeInsets.all(10),
        child: _getWellsDataColumn(data: __WELLS.data),
      ),
      //
      isExpanded: __WELLS.isExpanded,
    );
  }

  /**
   *
   */
  Widget _getWellsDataColumn({data}) {
    List _list = List<Widget>();

    var _loopNum = (data.length / 2).ceil();
    for (var i = 0; i < _loopNum; i++) {
      var _number = (i * 2);
      _list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          '${data[_number]['num']}',
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('${data[_number]['monthday']}'),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: (data[_number]['price'] == "")
                            ? Text('')
                            : Text(
                                '${_utility.makeCurrencyDisplay(data[_number]['price'])}'),
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.topRight,
                        child: (data[_number]['total'] == "")
                            ? Text('')
                            : Text(
                                '${_utility.makeCurrencyDisplay(data[_number]['total'])}'),
                      ),
                    ],
                  ),
                ),
              ),
              (_number + 1 >= data.length)
                  ? Expanded(child: Container())
                  : Expanded(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                '${data[_number + 1]['num']}',
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text('${data[_number + 1]['monthday']}'),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: (data[_number + 1]['price'] == "")
                                  ? Text('')
                                  : Text(
                                      '${_utility.makeCurrencyDisplay(data[_number + 1]['price'])}'),
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.topRight,
                              child: (data[_number + 1]['total'] == "")
                                  ? Text('')
                                  : Text(
                                      '${_utility.makeCurrencyDisplay(data[_number + 1]['total'])}'),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    }

    return DefaultTextStyle(
      style: TextStyle(fontSize: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }

  /**
   *
   */
  _goWellsDataDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WellsDataDisplayScreen(),
      ),
    );
  }
}

class Wells {
  bool isExpanded;
  String year;
  List data;

  Wells({this.isExpanded, this.year, this.data});
}
