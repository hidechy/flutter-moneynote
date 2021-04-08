import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

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
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _yachinData.add(data['data'][i]);
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
          _utility.getBackGround(),
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
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.yellowAccent.withOpacity(0.2)),
                        padding: EdgeInsets.only(top: 2, bottom: 2, right: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(FontAwesomeIcons.bolt, size: 12),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      '${_utility.makeCurrencyDisplay(_yachinData[position]['electric'])}'),
                                  Text(
                                      '${_yachinData[position]['electric_date']}',
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.8))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.2)),
                        padding: EdgeInsets.only(top: 2, bottom: 2, right: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(FontAwesomeIcons.burn, size: 12),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      '${_utility.makeCurrencyDisplay(_yachinData[position]['gas'])}'),
                                  Text('${_yachinData[position]['gas_date']}',
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.8))),
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
            ],
          ),
        ),
      ),
    );
  }
}
