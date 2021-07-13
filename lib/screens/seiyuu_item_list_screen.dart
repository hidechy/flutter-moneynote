import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/custom_shape_clipper.dart';

class SeiyuuItemListScreen extends StatefulWidget {
  final String date;
  SeiyuuItemListScreen({@required this.date});

  @override
  _SeiyuuItemListScreenState createState() => _SeiyuuItemListScreenState();
}

class _SeiyuuItemListScreenState extends State<SeiyuuItemListScreen> {
  Utility _utility = Utility();

  var _seiyuuCurrentItemList = new List<Seiyuu>();
  var _seiyuuNotBuyItemList = new List<Seiyuu>();

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
    String url = "http://toyohide.work/BrainLog/api/seiyuuPurchaseItemList";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
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
          _map['date'] = ex_dd[0];
          _map['tanka'] = ex_dd[1];
          _map['kosuu'] = ex_dd[2];
          _map['price'] = ex_dd[3];
          _list.add(_map);
        }
        _seiyuuCurrentItemList
            .add(Seiyuu(isExpanded: false, item: ex_data[0], data: _list));
      }

      for (var i = 0; i < data["data2"].length; i++) {
        var ex_data = (data["data2"][i]).split(':');
        List _list = List();
        var ex_datedata = (ex_data[1]).split('/');
        for (var j = 0; j < ex_datedata.length; j++) {
          var ex_dd = (ex_datedata[j]).split('|');
          Map _map = Map();
          _map['date'] = ex_dd[0];
          _map['tanka'] = ex_dd[1];
          _map['kosuu'] = ex_dd[2];
          _map['price'] = ex_dd[3];
          _list.add(_map);
        }
        _seiyuuNotBuyItemList
            .add(Seiyuu(isExpanded: false, item: ex_data[0], data: _list));
      }
    }

//    print(_seiyuuCurrentItemList[0].item);
//    print(_seiyuuNotBuyItemList[0].item);

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var oneHeight = ((size.height) / 2) - 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Seiyuu Items'),
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
            onPressed: () => _goSeiyuuItemListScreen(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('最近購入したもの'),
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
                          _seiyuuCurrentItemList[index].isExpanded =
                              !_seiyuuCurrentItemList[index].isExpanded;
                          setState(() {});
                        },
                        children:
                            _seiyuuCurrentItemList.map(_createPanel).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('最近購入しないもの'),
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
                          _seiyuuNotBuyItemList[index].isExpanded =
                              !_seiyuuNotBuyItemList[index].isExpanded;
                          setState(() {});
                        },
                        children:
                            _seiyuuNotBuyItemList.map(_createPanel2).toList(),
                      ),
                    ),
                  ],
                ),
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
  ExpansionPanel _createPanel(Seiyuu __SEIYUU) {
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
              '${__SEIYUU.item}',
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
        child: _getSeiyuuDataColumn(data: __SEIYUU.data),
      ),
      //
      isExpanded: __SEIYUU.isExpanded,
    );
  }

  /**
   *
   */
  ExpansionPanel _createPanel2(Seiyuu __SEIYUU) {
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
              '${__SEIYUU.item}',
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
        child: _getSeiyuuDataColumn(data: __SEIYUU.data),
      ),
      //
      isExpanded: __SEIYUU.isExpanded,
    );
  }

  /**
   *
   */
  Widget _getSeiyuuDataColumn({data}) {
    List _list = List<Widget>();

    for (var i = 0; i < data.length; i++) {
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
              Container(width: 60, child: Text('${data[i]['date']}')),
              Container(
                  alignment: Alignment.topRight,
                  width: 50,
                  child: Text(
                      '${_utility.makeCurrencyDisplay(data[i]['tanka'])}')),
              Container(
                  alignment: Alignment.topRight,
                  width: 30,
                  child: Text('${data[i]['kosuu']}')),
              Container(
                  alignment: Alignment.topRight,
                  width: 60,
                  child: Text(
                      '${_utility.makeCurrencyDisplay(data[i]['price'])}')),
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
  _goSeiyuuItemListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SeiyuuItemListScreen(
          date: widget.date,
        ),
      ),
    );
  }
}

class Seiyuu {
  bool isExpanded;
  String item;
  List data;

  Seiyuu({this.isExpanded, this.item, this.data});
}
