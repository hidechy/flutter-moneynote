import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:moneynote/utilities/custom_shape_clipper.dart';
import 'package:bubble/bubble.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../main.dart';

import 'spend_detail_paging_screen.dart';
import 'oneday_input_screen.dart';
import 'monthly_list_screen.dart';
import 'bank_input_screen.dart';
import 'benefit_input_screen.dart';
import 'score_list_screen.dart';
import 'sameday_list_screen.dart';
import 'allday_list_screen.dart';
import 'setting_base_screen.dart';

class DetailDisplayScreen extends StatefulWidget {
  final String date;
  final int index;
  final Map detailDisplayArgs;
  DetailDisplayScreen(
      {@required this.date, this.index, this.detailDisplayArgs});

  @override
  _DetailDisplayScreenState createState() => _DetailDisplayScreenState();
}

class _DetailDisplayScreenState extends State<DetailDisplayScreen> {
  Utility _utility = Utility();

  String _displayYear = '';
  String _displayMonth = '';

  String _youbiStr = '';

  String _displayDate = '';

  DateTime _prevDate = DateTime.now();
  DateTime _nextDate = DateTime.now();

  List<List<dynamic>> _monthDays = List();

  AutoScrollController _controller = AutoScrollController();

  String _yen10000 = '0';
  String _yen5000 = '0';
  String _yen2000 = '0';
  String _yen1000 = '0';
  String _yen500 = '0';
  String _yen100 = '0';
  String _yen50 = '0';
  String _yen10 = '0';
  String _yen5 = '0';
  String _yen1 = '0';

  String _bankA = '0';
  String _bankB = '0';
  String _bankC = '0';
  String _bankD = '0';
  String _bankE = '0';
  String _bankF = '0';
  String _bankG = '0';
  String _bankH = '0';

  String _payA = '0';
  String _payB = '0';
  String _payC = '0';
  String _payD = '0';
  String _payE = '0';
  String _payF = '0';
  String _payG = '0';
  String _payH = '0';

  int _total = 0;
  int _temochi = 0;
  int _undercoin = 0;

  int _spend = 0;
  var _lastMonthTotal = 0;
  int _monthSpend = 0;
  int _lastSpend = 0;

  Map<String, String> _bankNames = Map();

  Map<String, dynamic> _holidayList = Map();

  Map golddata = Map();
  Map _lastGold = Map();
  int _goldValue = 0;

  int _depositTotal = 0;
  int _eMoneyTotal = 0;

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
    _utility.makeYMDYData(widget.date, 0);

    _displayYear = _utility.year;
    _displayMonth = _utility.month;

    _youbiStr = _utility.youbiStr;

    _displayDate =
        '${_utility.year}-${_utility.month}-${_utility.day.padLeft(2, '0')}';

    _prevDate = new DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) - 1);
    _nextDate = new DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) + 1);

    ////////////////////////////////////////////////
    _utility.makeMonthEnd(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
    _utility.makeYMDYData(_utility.monthEndDateTime, 0);

    for (int i = 0; i <= int.parse(_utility.day); i++) {
      _monthDays.add([
        i,
        i.toString().padLeft(2, '0'),
      ]);
    }
    ////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    _controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      axis: Axis.vertical,
    );

    await _controller.scrollToIndex(widget.index,
        preferPosition: AutoScrollPosition.begin);
    /////////////////////////////////////////////////////
    if (widget.detailDisplayArgs['today'] != null) {
      _yen10000 = widget.detailDisplayArgs['today'][0].strYen10000;
      _yen5000 = widget.detailDisplayArgs['today'][0].strYen5000;
      _yen2000 = widget.detailDisplayArgs['today'][0].strYen2000;
      _yen1000 = widget.detailDisplayArgs['today'][0].strYen1000;
      _yen500 = widget.detailDisplayArgs['today'][0].strYen500;
      _yen100 = widget.detailDisplayArgs['today'][0].strYen100;
      _yen50 = widget.detailDisplayArgs['today'][0].strYen50;
      _yen10 = widget.detailDisplayArgs['today'][0].strYen10;
      _yen5 = widget.detailDisplayArgs['today'][0].strYen5;
      _yen1 = widget.detailDisplayArgs['today'][0].strYen1;

      _bankA = widget.detailDisplayArgs['today'][0].strBankA;
      _bankB = widget.detailDisplayArgs['today'][0].strBankB;
      _bankC = widget.detailDisplayArgs['today'][0].strBankC;
      _bankD = widget.detailDisplayArgs['today'][0].strBankD;
      _bankE = widget.detailDisplayArgs['today'][0].strBankE;
      _bankF = widget.detailDisplayArgs['today'][0].strBankF;
      _bankG = widget.detailDisplayArgs['today'][0].strBankG;
      _bankH = widget.detailDisplayArgs['today'][0].strBankH;

      _payA = widget.detailDisplayArgs['today'][0].strPayA;
      _payB = widget.detailDisplayArgs['today'][0].strPayB;
      _payC = widget.detailDisplayArgs['today'][0].strPayC;
      _payD = widget.detailDisplayArgs['today'][0].strPayD;
      _payE = widget.detailDisplayArgs['today'][0].strPayE;
      _payF = widget.detailDisplayArgs['today'][0].strPayF;
      _payG = widget.detailDisplayArgs['today'][0].strPayG;
      _payH = widget.detailDisplayArgs['today'][0].strPayH;

      _utility.makeTotal(widget.detailDisplayArgs['today'][0]);
      _total = _utility.total;
      _temochi = _utility.temochi;
      _undercoin = _utility.undercoin;
    }

    var _yesterdayTotal = 0;
    if (widget.detailDisplayArgs['yesterday'] != null) {
      _utility.makeTotal(widget.detailDisplayArgs['yesterday'][0]);
      _yesterdayTotal = _utility.total;
      _spend = (_yesterdayTotal - _total);
    }

    if (widget.detailDisplayArgs['lastMonthEnd'] != null) {
      _utility.makeTotal(widget.detailDisplayArgs['lastMonthEnd'][0]);
      _lastMonthTotal = _utility.total;
    }

    _monthSpend = (_lastMonthTotal - _total);
    _lastSpend = (_lastMonthTotal - _yesterdayTotal);

    _bankNames = _utility.getBankName();

    //holiday
    var holidays = await database.selectHolidaySortedAllRecord;
    if (holidays.length > 0) {
      for (int i = 0; i < holidays.length; i++) {
        _holidayList[holidays[i].strDate] = '';
      }
    }

    //----------------------------//

    String url = "http://toyohide.work/BrainLog/api/getgolddata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": ""});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      golddata = jsonDecode(response.body);

      for (var i = 0; i < golddata['data'].length; i++) {
        _lastGold = golddata['data'][i];
      }

      _goldValue = _lastGold['gold_value'];
    }
    //----------------------------//

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
//      extendBodyBehindAppBar: true,
      appBar: AppBar(
//        backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('所持金額'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goPrevDate(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goNextDate(context: context),
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
          _detailDisplayBox(context),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _detailDisplayBox(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 14),
                          child: Text('${_displayDate}（${_youbiStr}）'),
                        ),
                      ),
                      const Divider(color: Colors.indigo),
                      _dispTotal(),
                      const Divider(color: Colors.indigo),
                      _dispCurrency(),
                      _dispDeposit(),
                      _dispEMoney(),
                      const Divider(color: Colors.indigo),
                      _dispGold(),

                      //
                      // const Divider(color: Colors.indigo),
                      // _dispStock(),
                      //
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.black.withOpacity(0.3),
                    onPressed: () => _showUnderMenu(),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.greenAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              //------------------------------------------------------------------------//
            ],
          ),
        ),
        ///////////////////////////////
        Container(
          width: 60,
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5),
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _goDetailDisplayScreen(
                        context: context,
                        date: _displayDate,
                        index: widget.index,
                      ),
                      color: Colors.greenAccent,
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _showDatepicker(context: context),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5),
                color: Colors.black.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('${_displayYear}'),
                      Text('${_displayMonth}'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _monthDaysList(),
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
  Widget _dispTotal() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text('month start'),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_lastMonthTotal.toString())}'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text('month spend'),
                        ),
                        Container(
                          width: 60,
                          alignment: Alignment.topRight,
                          child: Icon(
                            FontAwesomeIcons.caretRight,
                            color: Colors.greenAccent.withOpacity(0.6),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.greenAccent.withOpacity(0.3),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                                '${_utility.makeCurrencyDisplay(_monthSpend.toString())}'),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: const Text(
                                'total',
                                style:
                                    const TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '${_utility.makeCurrencyDisplay(_total.toString())}',
                                style:
                                    const TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Bubble(
                      nip: BubbleNip.rightTop,
                      color: Colors.greenAccent.withOpacity(0.2),
                      nipWidth: 20,
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: 12),
                        child: Column(
                          children: <Widget>[
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text('today spend'),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_spend.toString())}'),
                                  ),
                                ]),
                              ],
                            ),
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text('last spend'),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        '${_utility.makeCurrencyDisplay(_lastSpend.toString())}'),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  color: Colors.greenAccent,
                  icon: const Icon(Icons.info),
                  onPressed: () => _goSpendDetailPagingScreen(
                      context: context, date: _displayDate),
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
  Widget _dispCurrency() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900].withOpacity(0.5),
                        child: const Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('currency'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(),
                    Container(),
                  ]),
                ],
              ),
              ___dispCurrencyData(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              _utility.makeCurrencyDisplay(_temochi.toString()),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Widget ___dispCurrencyData() {
    List<String> _list = List();
    _list.add('10000:${_yen10000}');
    _list.add('5000:${_yen5000}');
    _list.add('2000:${_yen2000}');
    _list.add('1000:${_yen1000}');
    _list.add('500:${_yen500}');
    _list.add('100:${_yen100}');
    _list.add('50:${_yen50}');
    _list.add('10:${_yen10}');
    _list.add('5:${_yen5}');
    _list.add('1:${_yen1}');

    return ____dispEachData('currency', _list);
  }

  /**
   *
   */
  Widget _dispDeposit() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900].withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('deposit'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(),
                    Container(),
                  ]),
                ],
              ),
              ___dispDepositData(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              _utility.makeCurrencyDisplay(_depositTotal.toString()),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Widget ___dispDepositData() {
    List<String> _list = List();
    _list.add('bank_a:${_bankA}');
    _list.add('bank_b:${_bankB}');
    _list.add('bank_c:${_bankC}');
    _list.add('bank_d:${_bankD}');
    _list.add('bank_e:${_bankE}');
    _list.add('bank_f:${_bankF}');
    _list.add('bank_g:${_bankG}');
    _list.add('bank_h:${_bankH}');

    return ____dispEachData('deposit', _list);
  }

  /**
   *
   */
  Widget _dispEMoney() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900].withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('e-money'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(),
                    Container(),
                  ]),
                ],
              ),
              ___dispEMoneyData(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              _utility.makeCurrencyDisplay(_eMoneyTotal.toString()),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Widget ___dispEMoneyData() {
    List<String> _list = List();
    _list.add('pay_a:${_payA}');
    _list.add('pay_b:${_payB}');
    _list.add('pay_c:${_payC}');
    _list.add('pay_d:${_payD}');
    _list.add('pay_e:${_payE}');
    _list.add('pay_f:${_payF}');
    _list.add('pay_g:${_payG}');
    _list.add('pay_h:${_payH}');

    return ____dispEachData('e-money', _list);
  }

  /**
   *
   */
  Widget ____dispEachData(String type, List<String> list) {
    List<Widget> _list = List();

    var _roopNum = ((list.length) / 2).round();

    _depositTotal = 0;
    _eMoneyTotal = 0;

    for (var i = 0; i < _roopNum; i++) {
      var ex_data = (list[i]).split(':');
      var ex_data2 = (list[i + _roopNum]).split(':');

      var name1 = null;
      var money1 = null;
      var name2 = null;
      var money2 = null;

      switch (type) {
        case "currency":
          name1 = Text('${ex_data[0]}');
          money1 = Text('${ex_data[1]}');
          name2 = Text('${ex_data2[0]}');
          money2 = Text('${ex_data2[1]}');
          break;
        case "deposit":
          _depositTotal += int.parse(ex_data[1]);
          _depositTotal += int.parse(ex_data2[1]);

          if (int.parse(ex_data[1]) > 0) {
            name1 = Text('${_bankNames[ex_data[0]]}');
            money1 = Text('${_utility.makeCurrencyDisplay(ex_data[1])}');
          } else {
            name1 = Text('${ex_data[0]}', style: TextStyle(color: Colors.grey));
            money1 = Text('${_utility.makeCurrencyDisplay(ex_data[1])}',
                style: TextStyle(color: Colors.grey));
          }
          if (int.parse(ex_data2[1]) > 0) {
            name2 = Text('${_bankNames[ex_data2[0]]}');
            money2 = Text('${_utility.makeCurrencyDisplay(ex_data2[1])}');
          } else {
            name2 =
                Text('${ex_data2[0]}', style: TextStyle(color: Colors.grey));
            money2 = Text('${_utility.makeCurrencyDisplay(ex_data2[1])}',
                style: TextStyle(color: Colors.grey));
          }
          break;
        case "e-money":
          _eMoneyTotal += int.parse(ex_data[1]);
          _eMoneyTotal += int.parse(ex_data2[1]);

          if (int.parse(ex_data[1]) > 0) {
            name1 = Text('${_bankNames[ex_data[0]]}');
            money1 = Text('${_utility.makeCurrencyDisplay(ex_data[1])}');
          } else {
            name1 = Text('${ex_data[0]}', style: TextStyle(color: Colors.grey));
            money1 = Text('${_utility.makeCurrencyDisplay(ex_data[1])}',
                style: TextStyle(color: Colors.grey));
          }
          if (int.parse(ex_data2[1]) > 0) {
            name2 = Text('${_bankNames[ex_data2[0]]}');
            money2 = Text('${_utility.makeCurrencyDisplay(ex_data2[1])}');
          } else {
            name2 =
                Text('${ex_data2[0]}', style: TextStyle(color: Colors.grey));
            money2 = Text('${_utility.makeCurrencyDisplay(ex_data2[1])}',
                style: TextStyle(color: Colors.grey));
          }
          break;
      }

      _list.add(Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name1,
                  Container(
                    alignment: Alignment.topRight,
                    child: money1,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name2,
                  Container(
                    alignment: Alignment.topRight,
                    child: money2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    }

    return DefaultTextStyle(
      style: TextStyle(fontSize: 12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  /**
   *
   */
  Widget _dispGold() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900].withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('gold'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        '${_utility.makeCurrencyDisplay(_goldValue.toString())}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.yellowAccent),
                      ),
                    ),
                  ]),
                ],
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
  Widget _dispStock() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900].withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('stock'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(),
                    Container(),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /**
   * 下部メニュー表示
   */
  Future<Widget> _showUnderMenu() {
    return showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  width: 10,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.input),
                  title: const Text(
                    'Oneday Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goOnedayInputScreen(
                      context: context, date: _displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Monthly List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goMonthlyListScreen(
                      context: context, date: _displayDate),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text(
                    'Bank Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () =>
                      _goBankInputScreen(context: context, date: _displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.beenhere),
                  title: const Text(
                    'Benefit Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goBenefitInputScreen(
                      context: context, date: _displayDate),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text(
                    'Score List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () =>
                      _goScoreListScreen(context: context, date: _displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.all_inclusive),
                  title: const Text(
                    'SameDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goSamedayListScreen(
                      context: context, date: _displayDate),
                ),
                ListTile(
                  leading: const Icon(Icons.all_out),
                  title: const Text(
                    'AllDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () =>
                      _goAlldayListScreen(context: context, date: _displayDate),
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () => _goSettingBaseScreen(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /**
   * デートピッカー表示
   */
  void _showDatepicker({BuildContext context}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            backgroundColor: Colors.black.withOpacity(0.1),
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            cursorColor: Colors.white,
            buttonColor: Colors.black.withOpacity(0.1),
            bottomAppBarColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            accentColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            textSelectionColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            selectedRowColor: Colors.black.withOpacity(0.1),
          ),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      _goDetailDisplayScreen(
          context: context, date: selectedDate.toString(), index: 1);
    }
  }

  /**
   * リスト表示
   */
  Widget _monthDaysList() {
    return ListView(
      scrollDirection: Axis.vertical,
      controller: _controller,
      children: _monthDays.map<Widget>((data) {
        var _bgColor = _utility.getBgColor(
            '${_displayYear}-${_displayMonth}-${data[1]}', _holidayList);

        var ex_displayDate = (_displayDate).split('-');
        if (data[1] == ex_displayDate[2]) {
          _bgColor = Colors.yellowAccent.withOpacity(0.3);
        }

        return (data[0] == 0)
            ? Container()
            : Card(
                color: _bgColor,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  onTap: () => _goMonthDay(context: context, position: data[0]),
                  title: AutoScrollTag(
                    index: data[0],
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${data[1]}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    key: ValueKey(data[0]),
                    controller: _controller,
                  ),
                ),
              );
      }).toList(),
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移
  /**
   * 画面遷移（前日）
   */
  void _goPrevDate({BuildContext context}) {
    _utility.makeYMDYData(_prevDate.toString(), 0);

    _goDetailDisplayScreen(
      context: context,
      date: _prevDate.toString(),
      index: int.parse(_utility.day),
    );
  }

  /**
   * 画面遷移（翌日）
   */
  void _goNextDate({BuildContext context}) {
    _utility.makeYMDYData(_nextDate.toString(), 0);

    _goDetailDisplayScreen(
      context: context,
      date: _nextDate.toString(),
      index: int.parse(_utility.day),
    );
  }

  /**
   * 画面遷移（月内指定日）
   */
  void _goMonthDay({BuildContext context, int position}) {
    _goDetailDisplayScreen(
        context: context,
        date:
            '${_displayYear}-${_displayMonth}-${_monthDays[position][0].toString().padLeft(2, '0')}',
        index: position);
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  void _goDetailDisplayScreen(
      {BuildContext context, String date, int index}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: index,
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }

  /**
   *
   */
  _goSpendDetailPagingScreen({BuildContext context, String date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpendDetailPagingScreen(date: date),
      ),
    );
  }

  /**
   * 画面遷移（OnedayInputScreen）
   */
  void _goOnedayInputScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（MonthlyListScreen）
   */
  void _goMonthlyListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（BankInputScreen）
   */
  void _goBankInputScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BankInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（BenefitInputScreen）
   */
  void _goBenefitInputScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BenefitInputScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（ScoreListScreen）
   */
  void _goScoreListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（SamedayDisplayScreen）
   */
  void _goSamedayListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SamedayListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（AlldayListScreen）
   */
  void _goAlldayListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AlldayListScreen(
          date: date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（SettingBaseScreen）
   */
  void _goSettingBaseScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SettingBaseScreen(),
      ),
    );
  }
}
