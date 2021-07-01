import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';

class FundDataDisplayScreen extends StatefulWidget {
  @override
  _FundDataDisplayScreenState createState() => _FundDataDisplayScreenState();
}

class _FundDataDisplayScreenState extends State<FundDataDisplayScreen> {
  Utility _utility = Utility();

  Map funddata = Map();

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
    String url = "http://toyohide.work/BrainLog/api/getFundRecord";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ""});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      funddata = jsonDecode(response.body);
    }
    //----------------------------//

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
        title: Text('Fund Data'),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: _dispFund(),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _dispFund() {
    var __key = Container();
    var __val = Container();

    if (funddata['data'] != null) {
      funddata['data'].forEach((key, value) {
        __key = _dispKey(key: key);
        __val = _dispVal(value: value, count: funddata['data'].length);
      });
    }

    return Column(
      children: <Widget>[
        __key,
        __val,
      ],
    );
  }

  /**
   *
   */
  Widget _dispKey({key}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.topLeft,
      child: Text(
        '${key}',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  /**
   *
   */
  Widget _dispVal({value, count}) {
    Size size = MediaQuery.of(context).size;
    var _oneListHeight = (size.height - (count * 120)).floor();

    List<Widget> _list = List();

    for (var i = 0; i < value.length; i++) {
      var _basePrice = (value[i] != null) ? value[i]['base_price'] : '0';

      _list.add(DefaultTextStyle(
        style: TextStyle(fontSize: 12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80,
                child: Text(
                    '${value[i]['year']}-${value[i]['month']}-${value[i]['day']}'),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            '${_utility.makeCurrencyDisplay(_basePrice.toString())}'),
                        Text('${value[i]['yearly_return']}')
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text('${value[i]['compare_front']}'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return Container(
      width: double.infinity,
      height: double.parse(_oneListHeight.toString()),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _list,
        ),
      ),
    );
  }
}
