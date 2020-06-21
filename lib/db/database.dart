import 'package:moor/moor.dart';
import 'dart:io';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

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

  TextColumn get strPayA => text()();
  TextColumn get strPayB => text()();

  @override
  Set<Column> get primaryKey => {strDate};
}

class Benefits extends Table {
  TextColumn get strDate => text()();
  TextColumn get strCompany => text()();
  TextColumn get strPrice => text()();

  @override
  Set<Column> get primaryKey => {strDate};
}

class Credits extends Table {
  IntColumn get intId => integer().autoIncrement()();

  TextColumn get strDate => text()();
  TextColumn get strBank => text()();
  TextColumn get strItem => text()();
  TextColumn get strPrice => text()();

  @override
  Set<Column> get primaryKey => {intId};
}

@UseMoor(tables: [Monies, Benefits, Credits])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.createTable(benefits);
        }

        if (from == 2) {
          await m.createTable(credits);
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

  ////////////////////////////////////////////////////////////Credits
  //追加
  Future insertCreditRecord(Credit credit) => into(credits).insert(credit);

  //更新
  Future updateCreditRecord(Credit credit) => update(credits).replace(credit);

  //全削除
  Future deleteCreditAllRecord() => delete(credits).go();

  //削除
  Future deleteCreditIdRecord(Credit credit) =>
      (delete(credits)..where((tbl) => tbl.intId.equals(credit.intId))).go();

  //選択(id)
  Future selectCreditRecord(int id) =>
      (select(credits)..where((tbl) => tbl.intId.equals(id))).get();

  //選択(日付)
  Future selectCreditDateRecord(String date) =>
      (select(credits)..where((tbl) => tbl.strDate.equals(date))).get();

  //選択（勘定科目）
  Future<List<Credit>> selectCreditItemRecord(String item) => (select(credits)
        ..where((tbl) => tbl.strItem.equals(item))
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.strDate),
          (tbl) => OrderingTerm(expression: tbl.intId)
        ]))
      .get();

  //全選択（日付順）
  Future<List<Credit>> get selectCreditSortedAllRecord => (select(credits)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.strDate),
          (tbl) => OrderingTerm(expression: tbl.intId)
        ]))
      .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneynote.db'));
    return VmDatabase(file);
  });
}
