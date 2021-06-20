import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneynote/screens/gold_display_screen.dart';
import 'package:moneynote/screens/train_data_display_screen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../main.dart';
import '../db/database.dart';
import '../utilities/custom_shape_clipper.dart';

import 'duty_data_display_screen.dart';
import 'mercari_data_display_screen.dart';
import 'yachin_data_display_screen.dart';
import 'spend_summary_display_screen.dart';
import 'weekly_data_display_screen.dart';
import 'weekly_data_accordion_screen.dart';
import 'monthly_trend_display_screen.dart';

class SpendDetailPagingScreen extends StatefulWidget {
  final String date;
  SpendDetailPagingScreen({@required this.date});

  @override
  _SpendDetailPagingScreenState createState() =>
      _SpendDetailPagingScreenState();
}

class _SpendDetailPagingScreenState extends State<SpendDetailPagingScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _monthlyData = List();

  String _year = '';
  String _month = '';

  String _yearmonth = '';

  int _monthTotal = 0;

  String _prevMonthEndDateTime = '';
  String _prevMonthEndDate = '';

  final PageController pageController = PageController();

  // ページインデックス
  int currentPage = 0;

  int _monthend = 0;

  bool _arrowDisp = false;

  String _benefitDate;
  String _benefit;

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
    //----------------------- holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }
    //----------------------- holiday

    _utility.makeYMDYData(widget.date, 0);
    _year = _utility.year;
    _month = _utility.month;

    _yearmonth = '${_year}-${_month}';

    //))))))))))))))))))))
    _utility.makeMonthEnd(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
    _utility.makeYMDYData(_utility.monthEndDateTime, 0);
    _monthend = int.parse(_utility.day);
    //))))))))))))))))))))

    ///////////////////////////
    _utility.makeMonthEnd(int.parse(_year), int.parse(_month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    int _prevMonthEndTotal = 0;

    var val = await database.selectRecord(_prevMonthEndDate);
    if (val.length > 0) {
      _utility.makeTotal(val[0]);
      _prevMonthEndTotal = _utility.total;
    }
    ///////////////////////////

    //----------------------------//
    Map monthlyspenditem = Map();

    String url = "http://toyohide.work/BrainLog/api/monthlyspenditem";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      monthlyspenditem = jsonDecode(response.body);
    }
    //----------------------------//

    //----------------------------//
    Map monthlytraindata = Map();

    String url2 = "http://toyohide.work/BrainLog/api/monthlytraindata";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    String body2 = json.encode({"date": widget.date});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      monthlytraindata = jsonDecode(response2.body);
    }
    //----------------------------//

    //----------------------------//
    Map monthlytimeplace = Map();

    String url3 = "http://toyohide.work/BrainLog/api/monthlytimeplace";
    Map<String, String> headers3 = {'content-type': 'application/json'};
    String body3 = json.encode({"date": widget.date});
    Response response3 = await post(url3, headers: headers3, body: body3);

    if (response3 != null) {
      monthlytimeplace = jsonDecode(response3.body);
    }
    //----------------------------//

    //全データ取得
    var _monieData = await database.selectSortedAllRecord;

    if (_monieData.length > 0) {
      int j = 0;
      var _yesterdayTotal = 0;
      for (int i = 0; i < _monieData.length; i++) {
        _utility.makeYMDYData(_monieData[i].strDate, 0);

        if ('${_year}-${_month}' == '${_utility.year}-${_utility.month}') {
          var _map = Map();
          _map["date"] = _utility.day;

          _map['youbiNo'] = _utility.youbiNo;

          var holiday_flag = 0;
          switch (_utility.youbiNo) {
            case 0:
            case 6:
              holiday_flag = 1;
              break;
          }
          if (holiday_flag == 0) {
            if (_holidayList['${_year}-${_month}-${_utility.day}'] != null) {
              holiday_flag = 1;
            }
          }
          _map['holiday_flag'] = holiday_flag;

          _map["strYen10000"] = _monieData[i].strYen10000;
          _map["strYen5000"] = _monieData[i].strYen5000;
          _map["strYen2000"] = _monieData[i].strYen2000;
          _map["strYen1000"] = _monieData[i].strYen1000;
          _map["strYen500"] = _monieData[i].strYen500;
          _map["strYen100"] = _monieData[i].strYen100;
          _map["strYen50"] = _monieData[i].strYen50;
          _map["strYen10"] = _monieData[i].strYen10;
          _map["strYen5"] = _monieData[i].strYen5;
          _map["strYen1"] = _monieData[i].strYen1;

          _map["strBankA"] = _monieData[i].strBankA;
          _map["strBankB"] = _monieData[i].strBankB;
          _map["strBankC"] = _monieData[i].strBankC;
          _map["strBankD"] = _monieData[i].strBankD;
          _map["strBankE"] = _monieData[i].strBankE;
          _map["strBankF"] = _monieData[i].strBankF;
          _map["strBankG"] = _monieData[i].strBankG;
          _map["strBankH"] = _monieData[i].strBankH;

          _map["strPayA"] = _monieData[i].strPayA;
          _map["strPayB"] = _monieData[i].strPayB;
          _map["strPayC"] = _monieData[i].strPayC;
          _map["strPayD"] = _monieData[i].strPayD;
          _map["strPayE"] = _monieData[i].strPayE;
          _map["strPayF"] = _monieData[i].strPayF;
          _map["strPayG"] = _monieData[i].strPayG;
          _map["strPayH"] = _monieData[i].strPayH;

          //-------------------------------------//
          _utility.makeTotal(_monieData[i]);
          _map['total'] = _utility.total;
          //-------------------------------------//

          if (j == 0) {
            _map['diff'] = (_prevMonthEndTotal - _utility.total);
            _monthTotal += (_prevMonthEndTotal - _utility.total);
          } else {
            _map['diff'] = (_yesterdayTotal - _utility.total);
            _monthTotal += (_yesterdayTotal - _utility.total);
          }

          /////////////////////////////////////////
          var _monthdate = '${_utility.year}-${_utility.month}-${_utility.day}';

          _map['spenditem'] = null;
          if (monthlyspenditem['data'].length > 0) {
            if (monthlyspenditem['data'][_monthdate] != null) {
              _map['spenditem'] = monthlyspenditem['data'][_monthdate];
            }
          }

          _map['traindata'] = null;
          if (monthlytraindata['data'].length > 0) {
            if (monthlytraindata['data'][_monthdate] != null) {
              _map['traindata'] = monthlytraindata['data'][_monthdate];
            }
          }

          _map['timeplace'] = null;
          if (monthlytimeplace['data'].length > 0) {
            if (monthlytimeplace['data'][_monthdate] != null) {
              _map['timeplace'] = monthlytimeplace['data'][_monthdate];
            }
          }
          /////////////////////////////////////////

          _monthlyData.add(_map);

          _yesterdayTotal = _utility.total;

          j++;
        }
      }
    }

    //初期ページ設定
    var ex_date = (widget.date).split('-');
    pageController.jumpToPage(int.parse(ex_date[2]) - 1);

    /////////////////////////////////
    // ページコントローラのページ遷移を監視しページ数を丸める
    pageController.addListener(() {
      int next = pageController.page.round();
      if (pageController != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    /////////////////////////////////

    var _allBenefit = await database.selectBenefitSortedAllRecord;
    _setBenefitData(yearmonth: '${_year}-${_month}', benefit: _allBenefit);

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
        title: Text('${_year}-${_month}'),
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
          PageView.builder(
            controller: pageController,
            itemCount: _monthlyData.length,
            itemBuilder: (context, index) {
              //--------------------------------------// リセット
              bool active = (index == currentPage);
              if (active == false) {
                //print(currentPage);
                _arrowDisp = true;
              }
              //--------------------------------------//

              return Card(
                color: Colors.black.withOpacity(0.3),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: _dispMonthlyDetail(index),
                ),
              );
            },
          ),
          _dispMonthMoveArrow(context),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _dispMonthMoveArrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            '■',
            style: TextStyle(color: Colors.white.withOpacity(0.1)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _dispPrevArrow(),
            _dispNextArrow(),
          ],
        ),
      ],
    );
  }

  /**
   *
   */
  Widget _dispPrevArrow() {
    if (_arrowDisp == false) {
      return Container();
    }

    return (currentPage == 0)
        ? Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 20,
            ),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.greenAccent,
              onPressed: () => _goPrevDate(context: context),
            ),
          )
        : Container();
  }

  /**
   *
   */
  Widget _dispNextArrow() {
    if (_arrowDisp == false) {
      return Container();
    }

    return (currentPage == (_monthend - 1))
        ? Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 20,
            ),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              color: Colors.greenAccent,
              onPressed: () => _goNextDate(context: context),
            ),
          )
        : Container();
  }

  /**
   *
   */
  Widget _dispMonthlyDetail(int index) {
    _utility.makeYMDYData(
        '${_year}-${_month}-${_monthlyData[index]['date']}', 0);

    return Column(
      children: <Widget>[
        _dateLineDisplay(index: index),
        Divider(color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
        _makeDisplayMoneyItem(index: index),
        Divider(color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
        _spendItemDisplay(index: index),
        Divider(color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
        _timePlaceDisplay(index: index),
        Divider(color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
        _trainDataDisplay(index: index),
      ],
    );
  }

  /**
   *
   */
  Widget _dateLineDisplay({int index}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text('${_utility.day}（${_utility.youbiStr}）'),
            color: (_monthlyData[index]['holiday_flag'] == 1)
                ? _getBGColor(youbiNo: _monthlyData[index]['youbiNo'])
                : null,
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => _goSpendSummaryDisplayScreen(index: index),
                  child: Icon(
                    Icons.comment,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => _goYachinDataDisplayScreen(),
                  child: Icon(
                    FontAwesomeIcons.home,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => _goDutyDataDisplayScreen(),
                  child: Icon(
                    FontAwesomeIcons.biohazard,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => _goWeeklyDataAccordionScreen(index: index),
                  child: Icon(
                    FontAwesomeIcons.calendarWeek,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Color _getBGColor({youbiNo}) {
    switch (youbiNo) {
      case 0:
        return Colors.redAccent[700].withOpacity(0.3);
        break;
      case 6:
        return Colors.blueAccent[700].withOpacity(0.3);
        break;
      default:
        return Colors.greenAccent[700].withOpacity(0.3);
        break;
    }
  }

  /**
   * アップロードデータ表示
   */
  Widget _makeDisplayMoneyItem({int index}) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.3),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 10.0),
              child: Column(
                children: <Widget>[
                  Table(
                    children: [
                      TableRow(children: [
                        _getDisplayContainer(
                            name: '10000',
                            value: _monthlyData[index]['strYen10000']),
                        _getDisplayContainer(
                            name: '5000',
                            value: _monthlyData[index]['strYen5000']),
                        _getDisplayContainer(
                            name: '2000',
                            value: _monthlyData[index]['strYen2000']),
                        _getDisplayContainer(
                            name: '1000',
                            value: _monthlyData[index]['strYen1000']),
                        _getDisplayContainer(
                            name: '500',
                            value: _monthlyData[index]['strYen500']),
                        _getDisplayContainer(
                            name: '100',
                            value: _monthlyData[index]['strYen100']),
                        _getDisplayContainer(
                            name: '50', value: _monthlyData[index]['strYen50']),
                        _getDisplayContainer(
                            name: '10', value: _monthlyData[index]['strYen10']),
                        _getDisplayContainer(
                            name: '5', value: _monthlyData[index]['strYen5']),
                        _getDisplayContainer(
                            name: '1', value: _monthlyData[index]['strYen1'])
                      ])
                    ],
                  ),
                  const Divider(
                    color: Colors.indigo,
                    height: 20.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  (int.parse(_monthlyData[index]['strBankA']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'bankA',
                                  value: _monthlyData[index]['strBankA']),
                              _getDisplayContainer(
                                  name: 'bankB',
                                  value: _monthlyData[index]['strBankB']),
                              _getDisplayContainer(
                                  name: 'bankC',
                                  value: _monthlyData[index]['strBankC']),
                              _getDisplayContainer(
                                  name: 'bankD',
                                  value: _monthlyData[index]['strBankD'])
                            ])
                          ],
                        ),
                  (int.parse(_monthlyData[index]['strBankE']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'bankE',
                                  value: _monthlyData[index]['strBankE']),
                              _getDisplayContainer(
                                  name: 'bankF',
                                  value: _monthlyData[index]['strBankF']),
                              _getDisplayContainer(
                                  name: 'bankG',
                                  value: _monthlyData[index]['strBankG']),
                              _getDisplayContainer(
                                  name: 'bankH',
                                  value: _monthlyData[index]['strBankH'])
                            ])
                          ],
                        ),
                  const Divider(
                    color: Colors.indigo,
                    height: 20.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  (int.parse(_monthlyData[index]['strPayA']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'payA',
                                  value: _monthlyData[index]['strPayA']),
                              _getDisplayContainer(
                                  name: 'payB',
                                  value: _monthlyData[index]['strPayB']),
                              _getDisplayContainer(
                                  name: 'payC',
                                  value: _monthlyData[index]['strPayC']),
                              _getDisplayContainer(
                                  name: 'payD',
                                  value: _monthlyData[index]['strPayD'])
                            ])
                          ],
                        ),
                  (int.parse(_monthlyData[index]['strPayE']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'payE',
                                  value: _monthlyData[index]['strPayE']),
                              _getDisplayContainer(
                                  name: 'payF',
                                  value: _monthlyData[index]['strPayF']),
                              _getDisplayContainer(
                                  name: 'payG',
                                  value: _monthlyData[index]['strPayG']),
                              _getDisplayContainer(
                                  name: 'payH',
                                  value: _monthlyData[index]['strPayH'])
                            ])
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () => _goMonthlyTrendDisplayScreen(),
                    child: Icon(
                      Icons.center_focus_strong,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () => _goGoldDisplayScreen(),
                    child: Icon(
                      Icons.label,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () => _goTrainDataDisplayScreen(),
                    child: Icon(
                      Icons.train,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () => _goMercariDataDisplayScreen(),
                    child: Icon(
                      FontAwesomeIcons.handshake,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                    '${_utility.makeCurrencyDisplay(_monthlyData[index]['total'].toString())}'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () => _uploadDailyData(index: index),
                    child: Icon(
                      Icons.cloud_upload,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /**
   *
   */
  Widget _getDisplayContainer({name, value}) {
    return Container(
      alignment: Alignment.topRight,
      child: Text(
        '${_utility.makeCurrencyDisplay(value)}',
        style: TextStyle(
          color: _getTextColor(name: name),
        ),
      ),
    );
  }

  /**
   *
   */
  Color _getTextColor({name}) {
    switch (name) {
      case '10000':
      case '5000':
      case '2000':
      case '1000':
        return Colors.greenAccent;
        break;
      case '10':
      case '5':
      case '1':
        return Colors.yellowAccent;
        break;
      default:
        return Colors.white;
        break;
    }
  }

  /**
   *
   */
  Widget _spendItemDisplay({int index}) {
    var value = _monthlyData[index]['spenditem'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Text(
              '${_utility.makeCurrencyDisplay(_monthlyData[index]['diff'].toString())}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.greenAccent,
              ),
            ),
          ),
          Container(
            height: 130,
            child: _getSpendItemList(
              value: value,
              index: index,
            ),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  bool benefitAdd = false;
  Widget _getSpendItemList({value, index}) {
    if (value == null) {
      return Container();
    }

    if (benefitAdd == false) {
      if ('${_year}-${_month}-${_monthlyData[index]['date']}' == _benefitDate) {
        Map _map = Map();
        _map['koumoku'] = '収入';
        _map['price'] = _benefit;
        value.add(_map);

        benefitAdd = true;
      }
    }

    List _list = List<Widget>();
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Table(
          children: [
            TableRow(
              children: [
                Text(''),
                Container(
                  child: Text(
                    '${value[i]['koumoku']}',
                    strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                    style: (value[i]['koumoku'] == '収入')
                        ? TextStyle(color: Colors.yellowAccent)
                        : null,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    '${_utility.makeCurrencyDisplay(value[i]['price'].toString())}',
                    strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                    style: (value[i]['koumoku'] == '収入')
                        ? TextStyle(color: Colors.yellowAccent)
                        : null,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  /**
   *
   */
  Widget _timePlaceDisplay({int index}) {
    var value = _monthlyData[index]['timeplace'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 130,
            child: _getTimePlaceList(value: value),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _getTimePlaceList({value}) {
    if (value == null) {
      return Container();
    }

    List _list = List<Widget>();
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Container(
          color: (value[i]['place'] == '移動中')
              ? Colors.green[900].withOpacity(0.5)
              : null,
          child: Table(
            children: [
              TableRow(
                children: [
                  Text(
                    '${value[i]['time']}',
                    strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                  Text(
                    '${value[i]['place']}',
                    strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${_utility.makeCurrencyDisplay(value[i]['price'].toString())}',
                      strutStyle: StrutStyle(fontSize: 12.0, height: 1.3),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  /**
   *
   */
  Widget _trainDataDisplay({int index}) {
    var value = _monthlyData[index]['traindata'];

    return (value == null)
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Container(
                  height: 120,
                  child: Text(
                    '${value[0]}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
  }

  /**
   * マネーデータアップロード
   */
  void _uploadDailyData({int index}) async {
    Map<String, dynamic> _uploadData = Map();

    _uploadData['date'] = '${_year}-${_month}-${_monthlyData[index]['date']}';

    _uploadData['yen_10000'] = _monthlyData[index]['strYen10000'];
    _uploadData['yen_5000'] = _monthlyData[index]['strYen5000'];
    _uploadData['yen_2000'] = _monthlyData[index]['strYen2000'];
    _uploadData['yen_1000'] = _monthlyData[index]['strYen1000'];
    _uploadData['yen_500'] = _monthlyData[index]['strYen500'];
    _uploadData['yen_100'] = _monthlyData[index]['strYen100'];
    _uploadData['yen_50'] = _monthlyData[index]['strYen50'];
    _uploadData['yen_10'] = _monthlyData[index]['strYen10'];
    _uploadData['yen_5'] = _monthlyData[index]['strYen5'];
    _uploadData['yen_1'] = _monthlyData[index]['strYen1'];

    _uploadData['bank_a'] = _monthlyData[index]['strBankA'];
    _uploadData['bank_b'] = _monthlyData[index]['strBankB'];
    _uploadData['bank_c'] = _monthlyData[index]['strBankC'];
    _uploadData['bank_d'] = _monthlyData[index]['strBankD'];
    _uploadData['bank_e'] = _monthlyData[index]['strBankE'];
    _uploadData['bank_f'] = _monthlyData[index]['strBankF'];
    _uploadData['bank_g'] = _monthlyData[index]['strBankG'];
    _uploadData['bank_h'] = _monthlyData[index]['strBankH'];

    _uploadData['pay_a'] = _monthlyData[index]['strPayA'];
    _uploadData['pay_b'] = _monthlyData[index]['strPayB'];
    _uploadData['pay_c'] = _monthlyData[index]['strPayC'];
    _uploadData['pay_d'] = _monthlyData[index]['strPayD'];
    _uploadData['pay_e'] = _monthlyData[index]['strPayE'];
    _uploadData['pay_f'] = _monthlyData[index]['strPayF'];
    _uploadData['pay_g'] = _monthlyData[index]['strPayG'];
    _uploadData['pay_h'] = _monthlyData[index]['strPayH'];

    String url = "http://toyohide.work/BrainLog/api/moneyinsert";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(_uploadData);
    await post(url, headers: headers, body: body);

    Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
  }

  /**
   *
   */
  void _setBenefitData({String yearmonth, List<Benefit> benefit}) {
    for (var i = 0; i < benefit.length; i++) {
      var ex_date = (benefit[i].strDate).split('-');
      if ('${ex_date[0]}-${ex_date[1]}' == yearmonth) {
        _benefitDate = benefit[i].strDate;
        _benefit = benefit[i].strPrice;
      }
    }
  }

  /**
   *
   */
  void _goSpendSummaryDisplayScreen({int index}) {
    var date = '${_year}-${_month}-${_monthlyData[index]['date']}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpendSummaryDisplayScreen(date: date),
      ),
    );
  }

  /**
   *
   */
  void _goWeeklyDataDisplayScreen({int index}) {
    var date = '${_year}-${_month}-${_monthlyData[index]['date']}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyDataDisplayScreen(date: date),
      ),
    );
  }

  /**
   *
   */
  void _goDutyDataDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DutyDataDisplayScreen(),
      ),
    );
  }

  /**
   *
   */
  void _goYachinDataDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YachinDataDisplayScreen(),
      ),
    );
  }

  /**
   * 画面遷移（前日）
   */
  void _goPrevDate({BuildContext context}) {
    _utility.makeYMDYData(widget.date, 0);
    var _prevDate =
        new DateTime(int.parse(_utility.year), int.parse(_utility.month), 0);
    _utility.makeYMDYData(_prevDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpendDetailPagingScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }

  /**
   * 画面遷移（翌日）
   */
  void _goNextDate({BuildContext context}) {
    _utility.makeYMDYData(widget.date, 0);
    var _nextDate = new DateTime(
        int.parse(_utility.year), int.parse(_utility.month), _monthend + 1);
    _utility.makeYMDYData(_nextDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpendDetailPagingScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }

  /**
   *
   */
  void _goWeeklyDataAccordionScreen({int index}) {
    var date = '${_year}-${_month}-${_monthlyData[index]['date']}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyDataAccordionScreen(date: date),
      ),
    );
  }

  /**
   *
   */
  void _goMonthlyTrendDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyTrendDisplayScreen(),
      ),
    );
  }

  /**
   *
   */
  void _goGoldDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoldDisplayScreen(),
      ),
    );
  }

  /**
   *
   */
  void _goTrainDataDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainDataDisplayScreen(),
      ),
    );
  }

  /**
   *
   */
  void _goMercariDataDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MercariDataDisplayScreen(),
      ),
    );
  }
}
