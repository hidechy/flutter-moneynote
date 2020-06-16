import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';
import '../db/database.dart';
import '../utilities/utility.dart';

import 'detail_display_screen.dart';

class BenefitInputScreen extends StatefulWidget {
  final String date;
  BenefitInputScreen({@required this.date});

  @override
  _BenefitInputScreenState createState() => _BenefitInputScreenState();
}

class _BenefitInputScreenState extends State<BenefitInputScreen> {
  String _text = '';
  TextEditingController _teContCompany = TextEditingController();
  TextEditingController _teContPrice = TextEditingController();

  Utility _utility = Utility();

  String _dialogSelectedDate = "";

  bool _updateFlag = false;

  List<List<String>> _benefitData = List();

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
  _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);
    _dialogSelectedDate =
        _utility.year + "-" + _utility.month + "-" + _utility.day;

    //レコード取得
    var _benefit = await database.selectBenefitRecord(_dialogSelectedDate);
    if (_benefit.length > 0) {
      _teContCompany = new TextEditingController(text: _benefit[0].strCompany);
      _teContPrice = new TextEditingController(text: _benefit[0].strPrice);

      _updateFlag = true;
    }

    //リストデータ取得
    var benefits = await database.selectBenefitSortedAllRecord;
    if (benefits.length > 0) {
      for (int i = 0; i < benefits.length; i++) {
        _benefitData.add([
          benefits[i].strDate,
          benefits[i].strCompany,
          benefits[i].strPrice
        ]);
      }
    }

    _teContCompany = new TextEditingController(text: '');
    _teContPrice = new TextEditingController(text: '0');

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Benefit',
          style: const TextStyle(fontFamily: "Yomogi"),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  children: <Widget>[
                    _getTextField('company', _teContCompany, 'left'),
                    _getTextField('price', _teContPrice, 'right'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'reload',
                          onPressed: () => _goBenefitInputScreen(),
                          color: Colors.blueAccent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.details),
                          tooltip: 'detail',
                          onPressed: () => _goDetailDisplayScreen(),
                          color: Colors.blueAccent,
                        ),
                        Text(_dialogSelectedDate),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'jump',
                          onPressed: () => _showDatepicker(context),
                          color: Colors.blueAccent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.input),
                          tooltip: 'input',
                          onPressed: () => _insertRecord(context),
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _benefitList(),
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
  _benefitList() {
    return ListView.builder(
      itemCount: _benefitData.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem(int position) {
    return InkWell(
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: Card(
          color: Colors.black.withOpacity(0.3),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(
              '${_benefitData[position][0]}　${_benefitData[position][1]}　${_benefitData[position][2]}',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Yomogi',
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        //actions: <Widget>[],
        secondaryActions: <Widget>[
          IconSlideAction(
            color: Colors.black.withOpacity(0.3),
            foregroundColor: Colors.blueAccent,
            icon: Icons.delete,
            onTap: () => _deleteRecord(position),
          ),
        ],
      ),
    );
  }

  /**
   * テキストフィールド部分表示
   */
  Widget _getTextField(
      String text, TextEditingController con, String valueAlign) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType:
            (valueAlign == 'right') ? TextInputType.number : TextInputType.text,
        controller: con,
        textAlign: (valueAlign == 'right') ? TextAlign.end : TextAlign.start,
        decoration: InputDecoration(labelText: text),
        onChanged: (value) {
          setState(
            () {
              _text = value;
            },
          );
        },
      ),
    );
  }

  /**
   * デートピッカー表示
   */
  _showDatepicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
    );

    if (selectedDate != null) {
      _utility.makeYMDYData(selectedDate.toString(), 0);
      _dialogSelectedDate =
          _utility.year + "-" + _utility.month + "-" + _utility.day;

      //レコード取得
      var _benefit = await database.selectBenefitRecord(_dialogSelectedDate);
      if (_benefit.length > 0) {
        _teContCompany =
            new TextEditingController(text: _benefit[0].strCompany);
        _teContPrice = new TextEditingController(text: _benefit[0].strPrice);

        _updateFlag = true;
      }

      setState(() {});
    }
  }

  /**
   * データ作成/更新
   */
  _insertRecord(BuildContext context) async {
    if (_teContCompany.text == '') {
      Toast.show('companyが入力されていないため登録できません。', context,
          duration: Toast.LENGTH_LONG);
      return;
    }

    if (_teContPrice.text == '0') {
      Toast.show('priceが入力されていないため登録できません。', context,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var benefit = Benefit(
      strDate: _dialogSelectedDate,
      strCompany: _teContCompany.text,
      strPrice: _teContPrice.text,
    );

    if (_updateFlag == false) {
      await database.insertBenefitRecord(benefit);
      Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);
    } else {
      await database.updateBenefitRecord(benefit);
      Toast.show('更新が完了しました', context, duration: Toast.LENGTH_LONG);
    }

    _goBenefitInputScreen();
  }

  /**
   * データ削除
   */
  _deleteRecord(int position) async {
    var benefit = Benefit(
      strDate: _benefitData[position][0],
      strCompany: _benefitData[position][1],
      strPrice: _benefitData[position][2],
    );

    await database.deleteBenefitRecord(benefit);
    Toast.show('データを削除しました', context, duration: Toast.LENGTH_LONG);
    _goBenefitInputScreen();
  }

  /**
   * 画面遷移（BenefitInputScreen）
   */
  _goBenefitInputScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BenefitInputScreen(
          date: widget.date,
        ),
      ),
    );
  }

  /**
   * 画面遷移（DetailDisplayScreen）
   */
  _goDetailDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
