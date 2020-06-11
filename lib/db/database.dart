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

@UseMoor(tables: [Monies])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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

  //全選択（日付順）
  Future<List<Monie>> get selectSortedAllRecord => (select(monies)
    ..orderBy([(tbl) => OrderingTerm(expression: tbl.strDate)]))
      .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneynote.db'));
    return VmDatabase(file);
  });
}
