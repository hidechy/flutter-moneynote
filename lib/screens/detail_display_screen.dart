import 'package:flutter/material.dart';
import 'package:moneynote/screens/spend_detail_display_screen.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bubble/bubble.dart';

import '../main.dart';
import '../utilities/utility.dart';

import 'bank_input_screen.dart';
import 'monthly_list_screen.dart';
import 'oneday_input_screen.dart';
import 'score_list_screen.dart';
import 'benefit_input_screen.dart';
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

  String _displayDate = '';

  DateTime _prevDate = DateTime.now();
  DateTime _nextDate = DateTime.now();

  List<List<dynamic>> _monthDays = List();

  AutoScrollController _controller = AutoScrollController();

  String _youbiStr = '';

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
  int _monthSpend = 0;
  int _lastSpend = 0;

  Map<String, String> _bankNames = Map();

  Map<String, dynamic> _holidayList = Map();

  var _lastMonthTotal = 0;

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

//    ///////////////////////////////////////////////////////////////////

    _bankNames = _utility.getBankName();

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
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          _utility.getBackGround(),
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
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: <Widget>[
                      //------------------------------------------------------------------------//

                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Yomogi",
                          ),
                          child: Text('${_displayDate}（${_youbiStr}）'),
                        ),
                      ),

                      const Divider(color: Colors.indigo),

                      _dispTotal(),

                      const Divider(color: Colors.indigo),

                      _dispCurrency(),
                      _dispDeposit(),

                      const Divider(color: Colors.indigo),

                      _dispEMoney(),

                      //------------------------------------------------------------------------//
                    ],
                  ),
                ),
              ),
              //------------------------------------------------------------------------//
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
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Yomogi",
          ),
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
                    const Divider(color: Colors.indigo),
                    Table(
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
                    const Divider(color: Colors.indigo),
                    Bubble(
                      nip: BubbleNip.rightTop,
                      color: Colors.greenAccent.withOpacity(0.2),
                      nipWidth: 20,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Yomogi",
                        ),
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
                  onPressed: () => _goSpendDetailDisplayScreen(
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
          style: const TextStyle(
            fontSize: 12,
            fontFamily: "Yomogi",
          ),
          child: Table(
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
              TableRow(children: [
                _getTextDispWidget(
                    text: '10000',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen10000,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: '100',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen100,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: '5000',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen5000,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: '50',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen50,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: '2000',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen2000,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: '10',
                    greyDisp: false,
                    value: '',
                    undercoin: true,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen10,
                    greyDisp: false,
                    value: '',
                    undercoin: true,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: '1000',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen1000,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: '5',
                    greyDisp: false,
                    value: '',
                    undercoin: true,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen5,
                    greyDisp: false,
                    value: '',
                    undercoin: true,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: '500',
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen500,
                    greyDisp: false,
                    value: '',
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: '1',
                    greyDisp: false,
                    value: '',
                    undercoin: true,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _yen1,
                    greyDisp: false,
                    value: '',
                    undercoin: true,
                    currencyDisp: true),
              ]),
            ],
          ),
        ),
        Divider(
          color: Colors.white.withOpacity(0.3),
          indent: 10.0,
          endIndent: 10.0,
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              _utility.makeCurrencyDisplay(_temochi.toString()),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              _utility.makeCurrencyDisplay(_undercoin.toString()),
              style: const TextStyle(
                color: Colors.orangeAccent,
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
  Widget _dispDeposit() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 12,
            fontFamily: "Yomogi",
          ),
          child: Table(
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
              TableRow(children: [
                _getTextDispWidget(
                    text: 'bank_a',
                    greyDisp: true,
                    value: _bankA,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankA,
                    greyDisp: true,
                    value: _bankA,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'bank_e',
                    greyDisp: true,
                    value: _bankE,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankE,
                    greyDisp: true,
                    value: _bankE,
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: 'bank_b',
                    greyDisp: true,
                    value: _bankD,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankB,
                    greyDisp: true,
                    value: _bankD,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'bank_f',
                    greyDisp: true,
                    value: _bankF,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankF,
                    greyDisp: true,
                    value: _bankF,
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: 'bank_c',
                    greyDisp: true,
                    value: _bankC,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankC,
                    greyDisp: true,
                    value: _bankC,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'bank_g',
                    greyDisp: true,
                    value: _bankG,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankG,
                    greyDisp: true,
                    value: _bankG,
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: 'bank_d',
                    greyDisp: true,
                    value: _bankD,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankD,
                    greyDisp: true,
                    value: _bankD,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'bank_h',
                    greyDisp: true,
                    value: _bankH,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _bankH,
                    greyDisp: true,
                    value: _bankH,
                    undercoin: false,
                    currencyDisp: true),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Widget _dispEMoney() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 12,
            fontFamily: "Yomogi",
          ),
          child: Table(
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
              TableRow(children: [
                _getTextDispWidget(
                    text: 'pay_a',
                    greyDisp: true,
                    value: _payA,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payA,
                    greyDisp: true,
                    value: _payA,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'pay_e',
                    greyDisp: true,
                    value: _payE,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payE,
                    greyDisp: true,
                    value: _payE,
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: 'pay_b',
                    greyDisp: true,
                    value: _payB,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payB,
                    greyDisp: true,
                    value: _payB,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'pay_f',
                    greyDisp: true,
                    value: _payF,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payF,
                    greyDisp: true,
                    value: _payF,
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: 'pay_c',
                    greyDisp: true,
                    value: _payC,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payC,
                    greyDisp: true,
                    value: _payC,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'pay_g',
                    greyDisp: true,
                    value: _payG,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payG,
                    greyDisp: true,
                    value: _payG,
                    undercoin: false,
                    currencyDisp: true),
              ]),
              TableRow(children: [
                _getTextDispWidget(
                    text: 'pay_d',
                    greyDisp: true,
                    value: _payD,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payD,
                    greyDisp: true,
                    value: _payD,
                    undercoin: false,
                    currencyDisp: true),
                _getTextDispWidget(
                    text: 'pay_h',
                    greyDisp: true,
                    value: _payH,
                    undercoin: false,
                    currencyDisp: false),
                _getTextDispWidget(
                    text: _payH,
                    greyDisp: true,
                    value: _payH,
                    undercoin: false,
                    currencyDisp: true),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  /**
   * リスト表示
   */
  Widget _monthDaysList() {
    return ListView(
      scrollDirection: Axis.vertical,
      controller: _controller,
      children: _monthDays.map<Widget>((data) {
        return (data[0] == 0)
            ? Container()
            : Card(
                color: _utility.getBgColor(
                    '${_displayYear}-${_displayMonth}-${data[1]}',
                    _holidayList),
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

  /**
   * テキスト部分表示
   */
  Widget _getTextDispWidget(
      {String text,
      bool greyDisp,
      String value,
      bool undercoin,
      bool currencyDisp}) {
    //----------------------------------------
    if (currencyDisp == false) {
      //見出し

      if (greyDisp == true && value == '0') {
        return Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            _getDisplayText(text: text, currencyDisp: currencyDisp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        );
      } else {
        if (undercoin == true) {
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              _getDisplayText(text: text, currencyDisp: currencyDisp),
              style: TextStyle(
                color: Colors.orangeAccent,
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              _getDisplayText(text: text, currencyDisp: currencyDisp),
            ),
          );
        }
      }
    } else {
      //値

      if (greyDisp == true && value == '0') {
        return Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(right: 10),
          child: Text(
            _getDisplayText(text: text, currencyDisp: currencyDisp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        );
      } else {
        if (undercoin == true) {
          return Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              _getDisplayText(text: text, currencyDisp: currencyDisp),
              style: TextStyle(
                color: Colors.orangeAccent,
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              _getDisplayText(text: text, currencyDisp: currencyDisp),
            ),
          );
        }
      }
    }
    //----------------------------------------
  }

  /**
   * 表示テキスト取得
   */
  String _getDisplayText({String text, bool currencyDisp}) {
    if (currencyDisp) {
      return _utility.makeCurrencyDisplay(text);
    } else {
      if (_bankNames[text] != "" && _bankNames[text] != null) {
        return _bankNames[text];
      } else {
        return text;
      }
    }
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

  /**
   * 画面遷移（MonthlyValueListScreen）
   */
  void _goSpendDetailDisplayScreen({BuildContext context, String date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpendDetailDisplayScreen(date: date),
      ),
    );
  }
}
