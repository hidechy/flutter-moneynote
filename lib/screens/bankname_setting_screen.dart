import 'package:flutter/material.dart';
import 'package:moneynote/db/database.dart';
import 'package:moneynote/main.dart';
import 'package:toast/toast.dart';

import '../utilities/utility.dart';

class BanknameSettingScreen extends StatefulWidget {
  @override
  _BanknameSettingScreenState createState() => _BanknameSettingScreenState();
}

class _BanknameSettingScreenState extends State<BanknameSettingScreen> {
  Utility _utility = Utility();

  String _text = '';

  TextEditingController _teContBankA = TextEditingController(text: '');
  TextEditingController _teContBankB = TextEditingController(text: '');
  TextEditingController _teContBankC = TextEditingController(text: '');
  TextEditingController _teContBankD = TextEditingController(text: '');
  TextEditingController _teContBankE = TextEditingController(text: '');
  TextEditingController _teContBankF = TextEditingController(text: '');
  TextEditingController _teContBankG = TextEditingController(text: '');
  TextEditingController _teContBankH = TextEditingController(text: '');

  TextEditingController _teContPayA = TextEditingController(text: '');
  TextEditingController _teContPayB = TextEditingController(text: '');
  TextEditingController _teContPayC = TextEditingController(text: '');
  TextEditingController _teContPayD = TextEditingController(text: '');
  TextEditingController _teContPayE = TextEditingController(text: '');
  TextEditingController _teContPayF = TextEditingController(text: '');
  TextEditingController _teContPayG = TextEditingController(text: '');
  TextEditingController _teContPayH = TextEditingController(text: '');

  Map<String, String> _bankNames = Map();

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
    var values = await database.selectBanknameSortedAllRecord;

    if (values.length > 0) {
      for (int i = 0; i < values.length; i++) {
        _bankNames[values[i].strBank] = values[i].strName;

        switch (values[i].strBank) {
          case 'bank_a':
            _teContBankA.text = values[i].strName;
            break;
          case 'bank_b':
            _teContBankB.text = values[i].strName;
            break;
          case 'bank_c':
            _teContBankC.text = values[i].strName;
            break;
          case 'bank_d':
            _teContBankD.text = values[i].strName;
            break;
          case 'bank_e':
            _teContBankE.text = values[i].strName;
            break;
          case 'bank_f':
            _teContBankF.text = values[i].strName;
            break;
          case 'bank_g':
            _teContBankG.text = values[i].strName;
            break;
          case 'bank_h':
            _teContBankH.text = values[i].strName;
            break;
          case 'pay_a':
            _teContPayA.text = values[i].strName;
            break;
          case 'pay_b':
            _teContPayB.text = values[i].strName;
            break;
          case 'pay_c':
            _teContPayC.text = values[i].strName;
            break;
          case 'pay_d':
            _teContPayD.text = values[i].strName;
            break;
          case 'pay_e':
            _teContPayE.text = values[i].strName;
            break;
          case 'pay_f':
            _teContPayF.text = values[i].strName;
            break;
          case 'pay_g':
            _teContPayG.text = values[i].strName;
            break;
          case 'pay_h':
            _teContPayH.text = values[i].strName;
            break;
        }
      }
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('銀行名設定'),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        Table(children: [
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
                                  child: Text('bank'),
                                ),
                              ),
                            ),
                            Container(),
                            Container(),
                            Container(),
                          ]),
                        ]),
                        _getTextField(text: 'bank_a', con: _teContBankA),
                        _getTextField(text: 'bank_b', con: _teContBankB),
                        _getTextField(text: 'bank_c', con: _teContBankC),
                        _getTextField(text: 'bank_d', con: _teContBankD),
                        _getTextField(text: 'bank_e', con: _teContBankE),
                        _getTextField(text: 'bank_f', con: _teContBankF),
                        _getTextField(text: 'bank_g', con: _teContBankG),
                        _getTextField(text: 'bank_h', con: _teContBankH),
                        const Divider(
                          color: Colors.indigo,
                          height: 20.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Table(children: [
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
                        ]),
                        _getTextField(text: 'pay_a', con: _teContPayA),
                        _getTextField(text: 'pay_b', con: _teContPayB),
                        _getTextField(text: 'pay_c', con: _teContPayC),
                        _getTextField(text: 'pay_d', con: _teContPayD),
                        _getTextField(text: 'pay_e', con: _teContPayE),
                        _getTextField(text: 'pay_f', con: _teContPayF),
                        _getTextField(text: 'pay_g', con: _teContPayG),
                        _getTextField(text: 'pay_h', con: _teContPayH),
                        const Divider(
                          color: Colors.indigo,
                          height: 20.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.black.withOpacity(0.1),
                            onPressed: () => _insertRecord(context: context),
                            child: Icon(
                              Icons.input,
                              color: Colors.greenAccent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height / 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * テキストフィールド部分表示
   */
  Widget _getTextField({String text, TextEditingController con}) {
    return Row(
      children: <Widget>[
        Container(width: 80, child: Text('${text}')),
        Expanded(
          child: TextField(
            controller: con,
            style: TextStyle(fontSize: 12.0),
            onChanged: (value) {
              setState(
                () {
                  _text = value;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _insertRecord({BuildContext context}) async {
    List<String> insertBanks = List();

    insertBanks.add('bank_a');
    insertBanks.add('bank_b');
    insertBanks.add('bank_c');
    insertBanks.add('bank_d');
    insertBanks.add('bank_e');
    insertBanks.add('bank_f');
    insertBanks.add('bank_g');
    insertBanks.add('bank_h');

    insertBanks.add('pay_a');
    insertBanks.add('pay_b');
    insertBanks.add('pay_c');
    insertBanks.add('pay_d');
    insertBanks.add('pay_e');
    insertBanks.add('pay_f');
    insertBanks.add('pay_g');
    insertBanks.add('pay_h');

    List<String> insertNames = List();

    insertNames.add(_teContBankA.text);
    insertNames.add(_teContBankB.text);
    insertNames.add(_teContBankC.text);
    insertNames.add(_teContBankD.text);
    insertNames.add(_teContBankE.text);
    insertNames.add(_teContBankF.text);
    insertNames.add(_teContBankG.text);
    insertNames.add(_teContBankH.text);

    insertNames.add(_teContPayA.text);
    insertNames.add(_teContPayB.text);
    insertNames.add(_teContPayC.text);
    insertNames.add(_teContPayD.text);
    insertNames.add(_teContPayE.text);
    insertNames.add(_teContPayF.text);
    insertNames.add(_teContPayG.text);
    insertNames.add(_teContPayH.text);

    try {
      for (int i = 0; i < insertBanks.length; i++) {
        var bankname =
            Bankname(strBank: insertBanks[i], strName: insertNames[i]);

        var updateFlag = (_bankNames[insertBanks[i]] != null) ? true : false;

        if (updateFlag) {
          //テーブルに登録されている
          if (insertNames[i] == "") {
            //今回の値が空白の場合は削除
            database.deleteBanknameRecord(bankname);
          } else {
            if (_bankNames[insertBanks[i]] != insertNames[i]) {
              //前回の値と異なる場合は更新
              database.updateBanknameRecord(bankname);
            }
          }
        } else {
          //テーブルに登録されていない場合は追加
          database.insertBanknameRecord(bankname);
        }
      }
    } catch (e) {}

    Toast.show('登録が完了しました', context, duration: Toast.LENGTH_LONG);

    _goBanknameSettingScreen();
  }

  /**
   * 画面遷移（BanknameSettingScreen）
   */
  void _goBanknameSettingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BanknameSettingScreen(),
      ),
    );
  }
}
