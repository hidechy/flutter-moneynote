import 'package:moor/moor.dart';
import 'dart:io';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/**
 * 金種クラス
 */
class Monies extends Table {
  TextColumn get strDate => text()();

  TextColumn get strYen10000 => text()();
  TextColumn get strYen5000 => text()();
  TextColumn get strYen2000 => text()();
  TextColumn get strYen1000 => text()();
  TextColumn get strYen500 => text()();
  TextColumn get strYen100 => text()();
  TextColumn get strYen50 => text()();
  TextColumn get strYen10 => text()();
  TextColumn get strYen5 => text()();
  TextColumn get strYen1 => text()();

  TextColumn get strBankA => text()();
  TextColumn get strBankB => text()();
  TextColumn get strBankC => text()();
  TextColumn get strBankD => text()();
  TextColumn get strBankE => text()();
  TextColumn get strBankF => text()();
  TextColumn get strBankG => text()();
  TextColumn get strBankH => text()();

  TextColumn get strPayA => text()();
  TextColumn get strPayB => text()();
  TextColumn get strPayC => text()();
  TextColumn get strPayD => text()();
  TextColumn get strPayE => text()();
  TextColumn get strPayF => text()();
  TextColumn get strPayG => text()();
  TextColumn get strPayH => text()();

  @override
  Set<Column> get primaryKey => {strDate};
}

/**
 * 収入クラス
 */
class Benefits extends Table {
  TextColumn get strDate => text()();
  TextColumn get strCompany => text()();
  TextColumn get strPrice => text()();

  @override
  Set<Column> get primaryKey => {strDate};
}

/**
 * 通帳履歴クラス
 */
class Deposits extends Table {
  IntColumn get intId => integer().autoIncrement()();

  TextColumn get strDate => text()();
  TextColumn get strBank => text()();
  TextColumn get strItem => text()();
  TextColumn get strPrice => text()();

  @override
  Set<Column> get primaryKey => {intId};
}

/**
 * 休業日クラス
 */
class Holidays extends Table {
  TextColumn get strDate => text()();

  @override
  Set<Column> get primaryKey => {strDate};
}

/**
 * 通帳履歴クラス
 */
class Banknames extends Table {
  IntColumn get intId => integer().autoIncrement()();

  TextColumn get strBank => text()();
  TextColumn get strName => text()();

  @override
  Set<Column> get primaryKey => {intId};
}

/**
 * データベース操作クラス
 */
@UseMoor(tables: [Monies, Benefits, Deposits, Holidays, Banknames])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.createTable(benefits);
        }

        if (from == 2) {
          await m.createTable(deposits);
        }

        if (from == 3) {
          await m.addColumn(monies, monies.strPayC);
        }

        if (from == 4) {
          await m.createTable(holidays);
        }

        if (from == 5) {
          await m.createTable(banknames);
        }
      });

  ////////////////////////////////////////////////////////////Monies
  //追加
  Future insertRecord(Monie monie) => into(monies).insert(monie);

  //更新
  Future updateRecord(Monie monie) => update(monies).replace(monie);

  //選択
  Future selectRecord(String date) =>
      (select(monies)..where((tbl) => tbl.strDate.equals(date))).get();

  //削除
  Future deleteRecord(Monie monie) =>
      (delete(monies)..where((tbl) => tbl.strDate.equals(monie.strDate))).go();

  //全削除
  Future deleteAllRecord() => delete(monies).go();

  //全選択（日付順）
  Future<List<Monie>> get selectSortedAllRecord => (select(monies)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.strDate)]))
      .get();

  ////////////////////////////////////////////////////////////Benefits
  //追加
  Future insertBenefitRecord(Benefit benefit) => into(benefits).insert(benefit);

  //更新
  Future updateBenefitRecord(Benefit benefit) =>
      update(benefits).replace(benefit);

  //選択
  Future selectBenefitRecord(String date) =>
      (select(benefits)..where((tbl) => tbl.strDate.equals(date))).get();

  //削除
  Future deleteBenefitRecord(Benefit benefit) =>
      (delete(benefits)..where((tbl) => tbl.strDate.equals(benefit.strDate)))
          .go();

  //全削除
  Future deleteBenefitAllRecord() => delete(benefits).go();

  //全選択（日付順）
  Future<List<Benefit>> get selectBenefitSortedAllRecord => (select(benefits)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.strDate)]))
      .get();

  ////////////////////////////////////////////////////////////Deposits
  //追加
  Future insertDepositRecord(Deposit deposit) => into(deposits).insert(deposit);

  //更新
  Future updateDepositRecord(Deposit deposit) =>
      update(deposits).replace(deposit);

  //全削除
  Future deleteDepositAllRecord() => delete(deposits).go();

  //削除
  Future deleteDepositIdRecord(Deposit deposit) =>
      (delete(deposits)..where((tbl) => tbl.intId.equals(deposit.intId))).go();

  //選択(id)
  Future selectDepositRecord(int id) =>
      (select(deposits)..where((tbl) => tbl.intId.equals(id))).get();

  //選択(日付)
  Future selectDepositDateRecord(String date) =>
      (select(deposits)..where((tbl) => tbl.strDate.equals(date))).get();

  //選択（勘定科目）
  Future<List<Deposit>> selectDepositItemRecord(String item) =>
      (select(deposits)
            ..where((tbl) => tbl.strItem.equals(item))
            ..orderBy([
              (tbl) => OrderingTerm(expression: tbl.strDate),
              (tbl) => OrderingTerm(expression: tbl.intId)
            ]))
          .get();

  //全選択（日付順）
  Future<List<Deposit>> get selectDepositSortedAllRecord => (select(deposits)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.strDate),
          (tbl) => OrderingTerm(expression: tbl.intId)
        ]))
      .get();

  ////////////////////////////////////////////////////////////Holidays
  //追加
  Future insertHolidayRecord(Holiday holiday) => into(holidays).insert(holiday);

  //削除
  Future deleteHolidayRecord(Holiday holiday) =>
      (delete(holidays)..where((tbl) => tbl.strDate.equals(holiday.strDate)))
          .go();

  //選択
  Future selectHolidayRecord(String date) =>
      (select(holidays)..where((tbl) => tbl.strDate.equals(date))).get();

  //全選択（日付順）
  Future<List<Holiday>> get selectHolidaySortedAllRecord => (select(holidays)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.strDate)]))
      .get();

  ////////////////////////////////////////////////////////////Banknames
  //追加
  Future insertBanknameRecord(Bankname bankname) =>
      into(banknames).insert(bankname);

  //更新
  Future updateBanknameRecord(Bankname bankname) =>
      update(banknames).replace(bankname);

  //削除
  Future deleteBanknameRecord(Bankname bankname) =>
      (delete(banknames)..where((tbl) => tbl.strBank.equals(bankname.strBank)))
          .go();

  //全選択（ID順）
  Future<List<Bankname>> get selectBanknameSortedAllRecord => (select(banknames)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.intId)]))
      .get();
}

/**
 * データベースコネクション
 */
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneynote.db'));
    return VmDatabase(file);
  });
}
