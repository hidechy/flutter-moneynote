import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';

import 'dart:convert';

import '../utilities/utility.dart';

class YachinDataDisplayScreen extends StatefulWidget {
  @override
  _YachinDataDisplayScreenState createState() =>
      _YachinDataDisplayScreenState();
}

class _YachinDataDisplayScreenState extends State<YachinDataDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _yachinData = List();

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
    String url = "http://toyohide.work/BrainLog/api/yachinData";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      ///////////////////////////////////////////////
      Map allCredit = Map();
      String url2 = "http://toyohide.work/BrainLog/api/allcardspend";
      Map<String, String> headers2 = {'content-type': 'application/json'};
      String body2 = json.encode({});
      Response response2 = await post(url2, headers: headers2, body: body2);

      if (response2 != null) {
        allCredit = jsonDecode(response2.body);
      }
      ///////////////////////////////////////////////

      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        Map _map = Map();
        _map['date'] = data['data'][i]['date'];

        _map['yachin'] = data['data'][i]['yachin'];
        _map['yachin_date'] = data['data'][i]['yachin_date'];

        _map['electric'] = data['data'][i]['electric'];
        _map['electric_date'] = data['data'][i]['electric_date'];

        _map['gas'] = data['data'][i]['gas'];
        _map['gas_date'] = data['data'][i]['gas_date'];

        _map['water'] = data['data'][i]['water'];
        _map['water_date'] = data['data'][i]['water_date'];

        _map['broadband'] = 0;
        _map['broadband_date'] = '-';
        var _broadBandData = _getBroadBandData(
          date: data['data'][i]['date'],
          creditData: allCredit,
        );
        _map['broadband'] =
            (_broadBandData['price'] == null) ? 0 : _broadBandData['price'];
        _map['broadband_date'] =
            (_broadBandData['date'] == null) ? '-' : _broadBandData['date'];

        _map['mobile'] = 0;
        _map['mobile_date'] = '-';
        var _mobileData = _getMobileData(
          date: data['data'][i]['date'],
          creditData: allCredit,
        );
        _map['mobile'] =
            (_mobileData['price'] == null) ? 0 : _mobileData['price'];
        _map['mobile_date'] =
            (_mobileData['date'] == null) ? '-' : _mobileData['date'];

        _yachinData.add(_map);
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
        backgroundColor: Colors.transparent,
        title: Text('家賃'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
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
                child: _yachinList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _yachinList() {
    return ListView.builder(
      itemCount: _yachinData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    child: Text('${_yachinData[position]['date']}'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(FontAwesomeIcons.home, size: 12),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                            '${_utility.makeCurrencyDisplay(_yachinData[position]['yachin'])}'),
                        Text(
                          '${_yachinData[position]['yachin_date']}',
                          style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 50),
                child: Table(
                  children: [
                    TableRow(children: [
                      (_yachinData[position]['electric'] == 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.yellowAccent.withOpacity(0.2)),
                              padding:
                                  EdgeInsets.only(top: 2, bottom: 2, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child:
                                        Icon(FontAwesomeIcons.bolt, size: 12),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                            '${_utility.makeCurrencyDisplay(_yachinData[position]['electric'])}'),
                                        Text(
                                            '${_yachinData[position]['electric_date']}',
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      (_yachinData[position]['gas'] == 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.2)),
                              padding:
                                  EdgeInsets.only(top: 2, bottom: 2, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child:
                                        Icon(FontAwesomeIcons.burn, size: 12),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                            '${_utility.makeCurrencyDisplay(_yachinData[position]['gas'])}'),
                                        Text(
                                            '${_yachinData[position]['gas_date']}',
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      (_yachinData[position]['water'] == 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.2)),
                              padding:
                                  EdgeInsets.only(top: 2, bottom: 2, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child:
                                        Icon(FontAwesomeIcons.tint, size: 12),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                            '${_utility.makeCurrencyDisplay(_yachinData[position]['water'])}'),
                                        Text(
                                            '${_yachinData[position]['water_date']}',
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ]),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50),
                child: Table(
                  children: [
                    TableRow(children: [
                      (_yachinData[position]['mobile'] == 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.2)),
                              padding:
                                  EdgeInsets.only(top: 2, bottom: 2, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(FontAwesomeIcons.mobileAlt,
                                        size: 12),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                            '${_yachinData[position]['mobile']}'),
                                        Text(
                                            '${_yachinData[position]['mobile_date']}',
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      (_yachinData[position]['broadband'] == 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.purpleAccent.withOpacity(0.2)),
                              padding:
                                  EdgeInsets.only(top: 2, bottom: 2, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child:
                                        Icon(FontAwesomeIcons.wifi, size: 12),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                            '${_yachinData[position]['broadband']}'),
                                        Text(
                                            '${_yachinData[position]['broadband_date']}',
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Container()
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  Map _getBroadBandData({date, creditData}) {
    Map _map = Map();
    for (var i = 0; i < creditData['data'].length; i++) {
      var ex_creditDate = (creditData['data'][i]['date']).split('-');
      if ('${ex_creditDate[0]}-${ex_creditDate[1]}' == date) {
        if (creditData['data'][i]['item'] == "楽天ブロードバンド") {
          _map['date'] = ex_creditDate[2];
          _map['price'] = creditData['data'][i]['price'];
        }
      }
    }
    return _map;
  }

  /**
   *
   */
  Map _getMobileData({date, Map creditData}) {
    Map _map = Map();
    for (var i = 0; i < creditData['data'].length; i++) {
      var ex_creditDate = (creditData['data'][i]['date']).split('-');
      if ('${ex_creditDate[0]}-${ex_creditDate[1]}' == date) {
        var _price = 0;
        var _date = '-';
        if (creditData['data'][i]['item'] == "楽天モバイル") {
          _price += int.parse(creditData['data'][i]['price']);
          _date = ex_creditDate[2];
        }

        if (_price > 0) {
          _map['date'] = _date;
          _map['price'] = _price;
        }
      }
    }
    return _map;
  }
}
