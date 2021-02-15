import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import 'package:http/http.dart';
import 'dart:convert';

class DutyDataDisplayScreen extends StatefulWidget {
  @override
  _DutyDataDisplayScreenState createState() => _DutyDataDisplayScreenState();
}

class _DutyDataDisplayScreenState extends State<DutyDataDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _zeikinData = List();
  List<Map<dynamic, dynamic>> _nenkinData = List();
  List<Map<dynamic, dynamic>> _nenkinkikinData = List();
  List<Map<dynamic, dynamic>> _kenkouhokenData = List();

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
    String url = "http://toyohide.work/BrainLog/api/dutyData";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data']['税金'].length; i++) {
        var ex_data = data['data']['税金'][i].split('|');
        Map _map = Map();
        _map['date'] = ex_data[0];
        _map['price'] = ex_data[1];
        _zeikinData.add(_map);
      }

      for (var i = 0; i < data['data']['年金'].length; i++) {
        var ex_data = data['data']['年金'][i].split('|');
        Map _map = Map();
        _map['date'] = ex_data[0];
        _map['price'] = ex_data[1];
        _nenkinData.add(_map);
      }

      for (var i = 0; i < data['data']['国民年金基金'].length; i++) {
        var ex_data = data['data']['国民年金基金'][i].split('|');
        Map _map = Map();
        _map['date'] = ex_data[0];
        _map['price'] = ex_data[1];
        _nenkinkikinData.add(_map);
      }

      for (var i = 0; i < data['data']['国民健康保険'].length; i++) {
        var ex_data = data['data']['国民健康保険'][i].split('|');
        Map _map = Map();
        _map['date'] = ex_data[0];
        _map['price'] = ex_data[1];
        _kenkouhokenData.add(_map);
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
    var _oneListHeight = ((size.height - 150) / 4).floor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Duty Data'),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('税金'),
                Container(
                  height: double.parse(_oneListHeight.toString()),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: ListView(
                    children: _makeZeikinList(),
                  ),
                ),
                Text('年金'),
                Container(
                  height: double.parse(_oneListHeight.toString()),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: ListView(
                    children: _makeNenkinList(),
                  ),
                ),
                Text('国民年金基金'),
                Container(
                  height: double.parse(_oneListHeight.toString()),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: ListView(
                    children: _makeNenkinkikinList(),
                  ),
                ),
                Text('国民健康保険'),
                Container(
                  height: double.parse(_oneListHeight.toString()),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: ListView(
                    children: _makeKenkouhokenList(),
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
  List _makeZeikinList() {
    List<Widget> _dataList = List();
    for (var i = 0; i < _zeikinData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  '${_zeikinData[i]['date']}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  '${_utility.makeCurrencyDisplay(_zeikinData[i]['price'])}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }

  /**
   *
   */
  List _makeNenkinList() {
    List<Widget> _dataList = List();
    for (var i = 0; i < _nenkinData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  '${_nenkinData[i]['date']}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  '${_utility.makeCurrencyDisplay(_nenkinData[i]['price'])}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }

  /**
   *
   */
  List _makeNenkinkikinList() {
    List<Widget> _dataList = List();
    for (var i = 0; i < _nenkinkikinData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  '${_nenkinkikinData[i]['date']}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  '${_utility.makeCurrencyDisplay(_nenkinkikinData[i]['price'])}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }

  /**
   *
   */
  List _makeKenkouhokenList() {
    List<Widget> _dataList = List();
    for (var i = 0; i < _kenkouhokenData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  '${_kenkouhokenData[i]['date']}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  '${_utility.makeCurrencyDisplay(_kenkouhokenData[i]['price'])}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }
}
