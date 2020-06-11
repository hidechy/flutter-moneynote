// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Monie extends DataClass implements Insertable<Monie> {
  final String strDate;
  final String strYen10000;
  final String strYen5000;
  final String strYen2000;
  final String strYen1000;
  final String strYen500;
  final String strYen100;
  final String strYen50;
  final String strYen10;
  final String strYen5;
  final String strYen1;
  final String strBankA;
  final String strBankB;
  final String strBankC;
  final String strBankD;
  final String strPayA;
  final String strPayB;
  Monie(
      {@required this.strDate,
      @required this.strYen10000,
      @required this.strYen5000,
      @required this.strYen2000,
      @required this.strYen1000,
      @required this.strYen500,
      @required this.strYen100,
      @required this.strYen50,
      @required this.strYen10,
      @required this.strYen5,
      @required this.strYen1,
      @required this.strBankA,
      @required this.strBankB,
      @required this.strBankC,
      @required this.strBankD,
      @required this.strPayA,
      @required this.strPayB});
  factory Monie.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Monie(
      strDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_date']),
      strYen10000: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen10000']),
      strYen5000: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen5000']),
      strYen2000: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen2000']),
      strYen1000: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen1000']),
      strYen500: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen500']),
      strYen100: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen100']),
      strYen50: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen50']),
      strYen10: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen10']),
      strYen5: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen5']),
      strYen1: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_yen1']),
      strBankA: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_a']),
      strBankB: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_b']),
      strBankC: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_c']),
      strBankD: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_d']),
      strPayA: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_a']),
      strPayB: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_b']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || strDate != null) {
      map['str_date'] = Variable<String>(strDate);
    }
    if (!nullToAbsent || strYen10000 != null) {
      map['str_yen10000'] = Variable<String>(strYen10000);
    }
    if (!nullToAbsent || strYen5000 != null) {
      map['str_yen5000'] = Variable<String>(strYen5000);
    }
    if (!nullToAbsent || strYen2000 != null) {
      map['str_yen2000'] = Variable<String>(strYen2000);
    }
    if (!nullToAbsent || strYen1000 != null) {
      map['str_yen1000'] = Variable<String>(strYen1000);
    }
    if (!nullToAbsent || strYen500 != null) {
      map['str_yen500'] = Variable<String>(strYen500);
    }
    if (!nullToAbsent || strYen100 != null) {
      map['str_yen100'] = Variable<String>(strYen100);
    }
    if (!nullToAbsent || strYen50 != null) {
      map['str_yen50'] = Variable<String>(strYen50);
    }
    if (!nullToAbsent || strYen10 != null) {
      map['str_yen10'] = Variable<String>(strYen10);
    }
    if (!nullToAbsent || strYen5 != null) {
      map['str_yen5'] = Variable<String>(strYen5);
    }
    if (!nullToAbsent || strYen1 != null) {
      map['str_yen1'] = Variable<String>(strYen1);
    }
    if (!nullToAbsent || strBankA != null) {
      map['str_bank_a'] = Variable<String>(strBankA);
    }
    if (!nullToAbsent || strBankB != null) {
      map['str_bank_b'] = Variable<String>(strBankB);
    }
    if (!nullToAbsent || strBankC != null) {
      map['str_bank_c'] = Variable<String>(strBankC);
    }
    if (!nullToAbsent || strBankD != null) {
      map['str_bank_d'] = Variable<String>(strBankD);
    }
    if (!nullToAbsent || strPayA != null) {
      map['str_pay_a'] = Variable<String>(strPayA);
    }
    if (!nullToAbsent || strPayB != null) {
      map['str_pay_b'] = Variable<String>(strPayB);
    }
    return map;
  }

  MoniesCompanion toCompanion(bool nullToAbsent) {
    return MoniesCompanion(
      strDate: strDate == null && nullToAbsent
          ? const Value.absent()
          : Value(strDate),
      strYen10000: strYen10000 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen10000),
      strYen5000: strYen5000 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen5000),
      strYen2000: strYen2000 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen2000),
      strYen1000: strYen1000 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen1000),
      strYen500: strYen500 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen500),
      strYen100: strYen100 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen100),
      strYen50: strYen50 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen50),
      strYen10: strYen10 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen10),
      strYen5: strYen5 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen5),
      strYen1: strYen1 == null && nullToAbsent
          ? const Value.absent()
          : Value(strYen1),
      strBankA: strBankA == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankA),
      strBankB: strBankB == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankB),
      strBankC: strBankC == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankC),
      strBankD: strBankD == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankD),
      strPayA: strPayA == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayA),
      strPayB: strPayB == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayB),
    );
  }

  factory Monie.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Monie(
      strDate: serializer.fromJson<String>(json['strDate']),
      strYen10000: serializer.fromJson<String>(json['strYen10000']),
      strYen5000: serializer.fromJson<String>(json['strYen5000']),
      strYen2000: serializer.fromJson<String>(json['strYen2000']),
      strYen1000: serializer.fromJson<String>(json['strYen1000']),
      strYen500: serializer.fromJson<String>(json['strYen500']),
      strYen100: serializer.fromJson<String>(json['strYen100']),
      strYen50: serializer.fromJson<String>(json['strYen50']),
      strYen10: serializer.fromJson<String>(json['strYen10']),
      strYen5: serializer.fromJson<String>(json['strYen5']),
      strYen1: serializer.fromJson<String>(json['strYen1']),
      strBankA: serializer.fromJson<String>(json['strBankA']),
      strBankB: serializer.fromJson<String>(json['strBankB']),
      strBankC: serializer.fromJson<String>(json['strBankC']),
      strBankD: serializer.fromJson<String>(json['strBankD']),
      strPayA: serializer.fromJson<String>(json['strPayA']),
      strPayB: serializer.fromJson<String>(json['strPayB']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'strDate': serializer.toJson<String>(strDate),
      'strYen10000': serializer.toJson<String>(strYen10000),
      'strYen5000': serializer.toJson<String>(strYen5000),
      'strYen2000': serializer.toJson<String>(strYen2000),
      'strYen1000': serializer.toJson<String>(strYen1000),
      'strYen500': serializer.toJson<String>(strYen500),
      'strYen100': serializer.toJson<String>(strYen100),
      'strYen50': serializer.toJson<String>(strYen50),
      'strYen10': serializer.toJson<String>(strYen10),
      'strYen5': serializer.toJson<String>(strYen5),
      'strYen1': serializer.toJson<String>(strYen1),
      'strBankA': serializer.toJson<String>(strBankA),
      'strBankB': serializer.toJson<String>(strBankB),
      'strBankC': serializer.toJson<String>(strBankC),
      'strBankD': serializer.toJson<String>(strBankD),
      'strPayA': serializer.toJson<String>(strPayA),
      'strPayB': serializer.toJson<String>(strPayB),
    };
  }

  Monie copyWith(
          {String strDate,
          String strYen10000,
          String strYen5000,
          String strYen2000,
          String strYen1000,
          String strYen500,
          String strYen100,
          String strYen50,
          String strYen10,
          String strYen5,
          String strYen1,
          String strBankA,
          String strBankB,
          String strBankC,
          String strBankD,
          String strPayA,
          String strPayB}) =>
      Monie(
        strDate: strDate ?? this.strDate,
        strYen10000: strYen10000 ?? this.strYen10000,
        strYen5000: strYen5000 ?? this.strYen5000,
        strYen2000: strYen2000 ?? this.strYen2000,
        strYen1000: strYen1000 ?? this.strYen1000,
        strYen500: strYen500 ?? this.strYen500,
        strYen100: strYen100 ?? this.strYen100,
        strYen50: strYen50 ?? this.strYen50,
        strYen10: strYen10 ?? this.strYen10,
        strYen5: strYen5 ?? this.strYen5,
        strYen1: strYen1 ?? this.strYen1,
        strBankA: strBankA ?? this.strBankA,
        strBankB: strBankB ?? this.strBankB,
        strBankC: strBankC ?? this.strBankC,
        strBankD: strBankD ?? this.strBankD,
        strPayA: strPayA ?? this.strPayA,
        strPayB: strPayB ?? this.strPayB,
      );
  @override
  String toString() {
    return (StringBuffer('Monie(')
          ..write('strDate: $strDate, ')
          ..write('strYen10000: $strYen10000, ')
          ..write('strYen5000: $strYen5000, ')
          ..write('strYen2000: $strYen2000, ')
          ..write('strYen1000: $strYen1000, ')
          ..write('strYen500: $strYen500, ')
          ..write('strYen100: $strYen100, ')
          ..write('strYen50: $strYen50, ')
          ..write('strYen10: $strYen10, ')
          ..write('strYen5: $strYen5, ')
          ..write('strYen1: $strYen1, ')
          ..write('strBankA: $strBankA, ')
          ..write('strBankB: $strBankB, ')
          ..write('strBankC: $strBankC, ')
          ..write('strBankD: $strBankD, ')
          ..write('strPayA: $strPayA, ')
          ..write('strPayB: $strPayB')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      strDate.hashCode,
      $mrjc(
          strYen10000.hashCode,
          $mrjc(
              strYen5000.hashCode,
              $mrjc(
                  strYen2000.hashCode,
                  $mrjc(
                      strYen1000.hashCode,
                      $mrjc(
                          strYen500.hashCode,
                          $mrjc(
                              strYen100.hashCode,
                              $mrjc(
                                  strYen50.hashCode,
                                  $mrjc(
                                      strYen10.hashCode,
                                      $mrjc(
                                          strYen5.hashCode,
                                          $mrjc(
                                              strYen1.hashCode,
                                              $mrjc(
                                                  strBankA.hashCode,
                                                  $mrjc(
                                                      strBankB.hashCode,
                                                      $mrjc(
                                                          strBankC.hashCode,
                                                          $mrjc(
                                                              strBankD.hashCode,
                                                              $mrjc(
                                                                  strPayA
                                                                      .hashCode,
                                                                  strPayB
                                                                      .hashCode)))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Monie &&
          other.strDate == this.strDate &&
          other.strYen10000 == this.strYen10000 &&
          other.strYen5000 == this.strYen5000 &&
          other.strYen2000 == this.strYen2000 &&
          other.strYen1000 == this.strYen1000 &&
          other.strYen500 == this.strYen500 &&
          other.strYen100 == this.strYen100 &&
          other.strYen50 == this.strYen50 &&
          other.strYen10 == this.strYen10 &&
          other.strYen5 == this.strYen5 &&
          other.strYen1 == this.strYen1 &&
          other.strBankA == this.strBankA &&
          other.strBankB == this.strBankB &&
          other.strBankC == this.strBankC &&
          other.strBankD == this.strBankD &&
          other.strPayA == this.strPayA &&
          other.strPayB == this.strPayB);
}

class MoniesCompanion extends UpdateCompanion<Monie> {
  final Value<String> strDate;
  final Value<String> strYen10000;
  final Value<String> strYen5000;
  final Value<String> strYen2000;
  final Value<String> strYen1000;
  final Value<String> strYen500;
  final Value<String> strYen100;
  final Value<String> strYen50;
  final Value<String> strYen10;
  final Value<String> strYen5;
  final Value<String> strYen1;
  final Value<String> strBankA;
  final Value<String> strBankB;
  final Value<String> strBankC;
  final Value<String> strBankD;
  final Value<String> strPayA;
  final Value<String> strPayB;
  const MoniesCompanion({
    this.strDate = const Value.absent(),
    this.strYen10000 = const Value.absent(),
    this.strYen5000 = const Value.absent(),
    this.strYen2000 = const Value.absent(),
    this.strYen1000 = const Value.absent(),
    this.strYen500 = const Value.absent(),
    this.strYen100 = const Value.absent(),
    this.strYen50 = const Value.absent(),
    this.strYen10 = const Value.absent(),
    this.strYen5 = const Value.absent(),
    this.strYen1 = const Value.absent(),
    this.strBankA = const Value.absent(),
    this.strBankB = const Value.absent(),
    this.strBankC = const Value.absent(),
    this.strBankD = const Value.absent(),
    this.strPayA = const Value.absent(),
    this.strPayB = const Value.absent(),
  });
  MoniesCompanion.insert({
    @required String strDate,
    @required String strYen10000,
    @required String strYen5000,
    @required String strYen2000,
    @required String strYen1000,
    @required String strYen500,
    @required String strYen100,
    @required String strYen50,
    @required String strYen10,
    @required String strYen5,
    @required String strYen1,
    @required String strBankA,
    @required String strBankB,
    @required String strBankC,
    @required String strBankD,
    @required String strPayA,
    @required String strPayB,
  })  : strDate = Value(strDate),
        strYen10000 = Value(strYen10000),
        strYen5000 = Value(strYen5000),
        strYen2000 = Value(strYen2000),
        strYen1000 = Value(strYen1000),
        strYen500 = Value(strYen500),
        strYen100 = Value(strYen100),
        strYen50 = Value(strYen50),
        strYen10 = Value(strYen10),
        strYen5 = Value(strYen5),
        strYen1 = Value(strYen1),
        strBankA = Value(strBankA),
        strBankB = Value(strBankB),
        strBankC = Value(strBankC),
        strBankD = Value(strBankD),
        strPayA = Value(strPayA),
        strPayB = Value(strPayB);
  static Insertable<Monie> custom({
    Expression<String> strDate,
    Expression<String> strYen10000,
    Expression<String> strYen5000,
    Expression<String> strYen2000,
    Expression<String> strYen1000,
    Expression<String> strYen500,
    Expression<String> strYen100,
    Expression<String> strYen50,
    Expression<String> strYen10,
    Expression<String> strYen5,
    Expression<String> strYen1,
    Expression<String> strBankA,
    Expression<String> strBankB,
    Expression<String> strBankC,
    Expression<String> strBankD,
    Expression<String> strPayA,
    Expression<String> strPayB,
  }) {
    return RawValuesInsertable({
      if (strDate != null) 'str_date': strDate,
      if (strYen10000 != null) 'str_yen10000': strYen10000,
      if (strYen5000 != null) 'str_yen5000': strYen5000,
      if (strYen2000 != null) 'str_yen2000': strYen2000,
      if (strYen1000 != null) 'str_yen1000': strYen1000,
      if (strYen500 != null) 'str_yen500': strYen500,
      if (strYen100 != null) 'str_yen100': strYen100,
      if (strYen50 != null) 'str_yen50': strYen50,
      if (strYen10 != null) 'str_yen10': strYen10,
      if (strYen5 != null) 'str_yen5': strYen5,
      if (strYen1 != null) 'str_yen1': strYen1,
      if (strBankA != null) 'str_bank_a': strBankA,
      if (strBankB != null) 'str_bank_b': strBankB,
      if (strBankC != null) 'str_bank_c': strBankC,
      if (strBankD != null) 'str_bank_d': strBankD,
      if (strPayA != null) 'str_pay_a': strPayA,
      if (strPayB != null) 'str_pay_b': strPayB,
    });
  }

  MoniesCompanion copyWith(
      {Value<String> strDate,
      Value<String> strYen10000,
      Value<String> strYen5000,
      Value<String> strYen2000,
      Value<String> strYen1000,
      Value<String> strYen500,
      Value<String> strYen100,
      Value<String> strYen50,
      Value<String> strYen10,
      Value<String> strYen5,
      Value<String> strYen1,
      Value<String> strBankA,
      Value<String> strBankB,
      Value<String> strBankC,
      Value<String> strBankD,
      Value<String> strPayA,
      Value<String> strPayB}) {
    return MoniesCompanion(
      strDate: strDate ?? this.strDate,
      strYen10000: strYen10000 ?? this.strYen10000,
      strYen5000: strYen5000 ?? this.strYen5000,
      strYen2000: strYen2000 ?? this.strYen2000,
      strYen1000: strYen1000 ?? this.strYen1000,
      strYen500: strYen500 ?? this.strYen500,
      strYen100: strYen100 ?? this.strYen100,
      strYen50: strYen50 ?? this.strYen50,
      strYen10: strYen10 ?? this.strYen10,
      strYen5: strYen5 ?? this.strYen5,
      strYen1: strYen1 ?? this.strYen1,
      strBankA: strBankA ?? this.strBankA,
      strBankB: strBankB ?? this.strBankB,
      strBankC: strBankC ?? this.strBankC,
      strBankD: strBankD ?? this.strBankD,
      strPayA: strPayA ?? this.strPayA,
      strPayB: strPayB ?? this.strPayB,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (strDate.present) {
      map['str_date'] = Variable<String>(strDate.value);
    }
    if (strYen10000.present) {
      map['str_yen10000'] = Variable<String>(strYen10000.value);
    }
    if (strYen5000.present) {
      map['str_yen5000'] = Variable<String>(strYen5000.value);
    }
    if (strYen2000.present) {
      map['str_yen2000'] = Variable<String>(strYen2000.value);
    }
    if (strYen1000.present) {
      map['str_yen1000'] = Variable<String>(strYen1000.value);
    }
    if (strYen500.present) {
      map['str_yen500'] = Variable<String>(strYen500.value);
    }
    if (strYen100.present) {
      map['str_yen100'] = Variable<String>(strYen100.value);
    }
    if (strYen50.present) {
      map['str_yen50'] = Variable<String>(strYen50.value);
    }
    if (strYen10.present) {
      map['str_yen10'] = Variable<String>(strYen10.value);
    }
    if (strYen5.present) {
      map['str_yen5'] = Variable<String>(strYen5.value);
    }
    if (strYen1.present) {
      map['str_yen1'] = Variable<String>(strYen1.value);
    }
    if (strBankA.present) {
      map['str_bank_a'] = Variable<String>(strBankA.value);
    }
    if (strBankB.present) {
      map['str_bank_b'] = Variable<String>(strBankB.value);
    }
    if (strBankC.present) {
      map['str_bank_c'] = Variable<String>(strBankC.value);
    }
    if (strBankD.present) {
      map['str_bank_d'] = Variable<String>(strBankD.value);
    }
    if (strPayA.present) {
      map['str_pay_a'] = Variable<String>(strPayA.value);
    }
    if (strPayB.present) {
      map['str_pay_b'] = Variable<String>(strPayB.value);
    }
    return map;
  }
}

class $MoniesTable extends Monies with TableInfo<$MoniesTable, Monie> {
  final GeneratedDatabase _db;
  final String _alias;
  $MoniesTable(this._db, [this._alias]);
  final VerificationMeta _strDateMeta = const VerificationMeta('strDate');
  GeneratedTextColumn _strDate;
  @override
  GeneratedTextColumn get strDate => _strDate ??= _constructStrDate();
  GeneratedTextColumn _constructStrDate() {
    return GeneratedTextColumn(
      'str_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen10000Meta =
      const VerificationMeta('strYen10000');
  GeneratedTextColumn _strYen10000;
  @override
  GeneratedTextColumn get strYen10000 =>
      _strYen10000 ??= _constructStrYen10000();
  GeneratedTextColumn _constructStrYen10000() {
    return GeneratedTextColumn(
      'str_yen10000',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen5000Meta = const VerificationMeta('strYen5000');
  GeneratedTextColumn _strYen5000;
  @override
  GeneratedTextColumn get strYen5000 => _strYen5000 ??= _constructStrYen5000();
  GeneratedTextColumn _constructStrYen5000() {
    return GeneratedTextColumn(
      'str_yen5000',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen2000Meta = const VerificationMeta('strYen2000');
  GeneratedTextColumn _strYen2000;
  @override
  GeneratedTextColumn get strYen2000 => _strYen2000 ??= _constructStrYen2000();
  GeneratedTextColumn _constructStrYen2000() {
    return GeneratedTextColumn(
      'str_yen2000',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen1000Meta = const VerificationMeta('strYen1000');
  GeneratedTextColumn _strYen1000;
  @override
  GeneratedTextColumn get strYen1000 => _strYen1000 ??= _constructStrYen1000();
  GeneratedTextColumn _constructStrYen1000() {
    return GeneratedTextColumn(
      'str_yen1000',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen500Meta = const VerificationMeta('strYen500');
  GeneratedTextColumn _strYen500;
  @override
  GeneratedTextColumn get strYen500 => _strYen500 ??= _constructStrYen500();
  GeneratedTextColumn _constructStrYen500() {
    return GeneratedTextColumn(
      'str_yen500',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen100Meta = const VerificationMeta('strYen100');
  GeneratedTextColumn _strYen100;
  @override
  GeneratedTextColumn get strYen100 => _strYen100 ??= _constructStrYen100();
  GeneratedTextColumn _constructStrYen100() {
    return GeneratedTextColumn(
      'str_yen100',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen50Meta = const VerificationMeta('strYen50');
  GeneratedTextColumn _strYen50;
  @override
  GeneratedTextColumn get strYen50 => _strYen50 ??= _constructStrYen50();
  GeneratedTextColumn _constructStrYen50() {
    return GeneratedTextColumn(
      'str_yen50',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen10Meta = const VerificationMeta('strYen10');
  GeneratedTextColumn _strYen10;
  @override
  GeneratedTextColumn get strYen10 => _strYen10 ??= _constructStrYen10();
  GeneratedTextColumn _constructStrYen10() {
    return GeneratedTextColumn(
      'str_yen10',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen5Meta = const VerificationMeta('strYen5');
  GeneratedTextColumn _strYen5;
  @override
  GeneratedTextColumn get strYen5 => _strYen5 ??= _constructStrYen5();
  GeneratedTextColumn _constructStrYen5() {
    return GeneratedTextColumn(
      'str_yen5',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strYen1Meta = const VerificationMeta('strYen1');
  GeneratedTextColumn _strYen1;
  @override
  GeneratedTextColumn get strYen1 => _strYen1 ??= _constructStrYen1();
  GeneratedTextColumn _constructStrYen1() {
    return GeneratedTextColumn(
      'str_yen1',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankAMeta = const VerificationMeta('strBankA');
  GeneratedTextColumn _strBankA;
  @override
  GeneratedTextColumn get strBankA => _strBankA ??= _constructStrBankA();
  GeneratedTextColumn _constructStrBankA() {
    return GeneratedTextColumn(
      'str_bank_a',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankBMeta = const VerificationMeta('strBankB');
  GeneratedTextColumn _strBankB;
  @override
  GeneratedTextColumn get strBankB => _strBankB ??= _constructStrBankB();
  GeneratedTextColumn _constructStrBankB() {
    return GeneratedTextColumn(
      'str_bank_b',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankCMeta = const VerificationMeta('strBankC');
  GeneratedTextColumn _strBankC;
  @override
  GeneratedTextColumn get strBankC => _strBankC ??= _constructStrBankC();
  GeneratedTextColumn _constructStrBankC() {
    return GeneratedTextColumn(
      'str_bank_c',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankDMeta = const VerificationMeta('strBankD');
  GeneratedTextColumn _strBankD;
  @override
  GeneratedTextColumn get strBankD => _strBankD ??= _constructStrBankD();
  GeneratedTextColumn _constructStrBankD() {
    return GeneratedTextColumn(
      'str_bank_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayAMeta = const VerificationMeta('strPayA');
  GeneratedTextColumn _strPayA;
  @override
  GeneratedTextColumn get strPayA => _strPayA ??= _constructStrPayA();
  GeneratedTextColumn _constructStrPayA() {
    return GeneratedTextColumn(
      'str_pay_a',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayBMeta = const VerificationMeta('strPayB');
  GeneratedTextColumn _strPayB;
  @override
  GeneratedTextColumn get strPayB => _strPayB ??= _constructStrPayB();
  GeneratedTextColumn _constructStrPayB() {
    return GeneratedTextColumn(
      'str_pay_b',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        strDate,
        strYen10000,
        strYen5000,
        strYen2000,
        strYen1000,
        strYen500,
        strYen100,
        strYen50,
        strYen10,
        strYen5,
        strYen1,
        strBankA,
        strBankB,
        strBankC,
        strBankD,
        strPayA,
        strPayB
      ];
  @override
  $MoniesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'monies';
  @override
  final String actualTableName = 'monies';
  @override
  VerificationContext validateIntegrity(Insertable<Monie> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('str_date')) {
      context.handle(_strDateMeta,
          strDate.isAcceptableOrUnknown(data['str_date'], _strDateMeta));
    } else if (isInserting) {
      context.missing(_strDateMeta);
    }
    if (data.containsKey('str_yen10000')) {
      context.handle(
          _strYen10000Meta,
          strYen10000.isAcceptableOrUnknown(
              data['str_yen10000'], _strYen10000Meta));
    } else if (isInserting) {
      context.missing(_strYen10000Meta);
    }
    if (data.containsKey('str_yen5000')) {
      context.handle(
          _strYen5000Meta,
          strYen5000.isAcceptableOrUnknown(
              data['str_yen5000'], _strYen5000Meta));
    } else if (isInserting) {
      context.missing(_strYen5000Meta);
    }
    if (data.containsKey('str_yen2000')) {
      context.handle(
          _strYen2000Meta,
          strYen2000.isAcceptableOrUnknown(
              data['str_yen2000'], _strYen2000Meta));
    } else if (isInserting) {
      context.missing(_strYen2000Meta);
    }
    if (data.containsKey('str_yen1000')) {
      context.handle(
          _strYen1000Meta,
          strYen1000.isAcceptableOrUnknown(
              data['str_yen1000'], _strYen1000Meta));
    } else if (isInserting) {
      context.missing(_strYen1000Meta);
    }
    if (data.containsKey('str_yen500')) {
      context.handle(_strYen500Meta,
          strYen500.isAcceptableOrUnknown(data['str_yen500'], _strYen500Meta));
    } else if (isInserting) {
      context.missing(_strYen500Meta);
    }
    if (data.containsKey('str_yen100')) {
      context.handle(_strYen100Meta,
          strYen100.isAcceptableOrUnknown(data['str_yen100'], _strYen100Meta));
    } else if (isInserting) {
      context.missing(_strYen100Meta);
    }
    if (data.containsKey('str_yen50')) {
      context.handle(_strYen50Meta,
          strYen50.isAcceptableOrUnknown(data['str_yen50'], _strYen50Meta));
    } else if (isInserting) {
      context.missing(_strYen50Meta);
    }
    if (data.containsKey('str_yen10')) {
      context.handle(_strYen10Meta,
          strYen10.isAcceptableOrUnknown(data['str_yen10'], _strYen10Meta));
    } else if (isInserting) {
      context.missing(_strYen10Meta);
    }
    if (data.containsKey('str_yen5')) {
      context.handle(_strYen5Meta,
          strYen5.isAcceptableOrUnknown(data['str_yen5'], _strYen5Meta));
    } else if (isInserting) {
      context.missing(_strYen5Meta);
    }
    if (data.containsKey('str_yen1')) {
      context.handle(_strYen1Meta,
          strYen1.isAcceptableOrUnknown(data['str_yen1'], _strYen1Meta));
    } else if (isInserting) {
      context.missing(_strYen1Meta);
    }
    if (data.containsKey('str_bank_a')) {
      context.handle(_strBankAMeta,
          strBankA.isAcceptableOrUnknown(data['str_bank_a'], _strBankAMeta));
    } else if (isInserting) {
      context.missing(_strBankAMeta);
    }
    if (data.containsKey('str_bank_b')) {
      context.handle(_strBankBMeta,
          strBankB.isAcceptableOrUnknown(data['str_bank_b'], _strBankBMeta));
    } else if (isInserting) {
      context.missing(_strBankBMeta);
    }
    if (data.containsKey('str_bank_c')) {
      context.handle(_strBankCMeta,
          strBankC.isAcceptableOrUnknown(data['str_bank_c'], _strBankCMeta));
    } else if (isInserting) {
      context.missing(_strBankCMeta);
    }
    if (data.containsKey('str_bank_d')) {
      context.handle(_strBankDMeta,
          strBankD.isAcceptableOrUnknown(data['str_bank_d'], _strBankDMeta));
    } else if (isInserting) {
      context.missing(_strBankDMeta);
    }
    if (data.containsKey('str_pay_a')) {
      context.handle(_strPayAMeta,
          strPayA.isAcceptableOrUnknown(data['str_pay_a'], _strPayAMeta));
    } else if (isInserting) {
      context.missing(_strPayAMeta);
    }
    if (data.containsKey('str_pay_b')) {
      context.handle(_strPayBMeta,
          strPayB.isAcceptableOrUnknown(data['str_pay_b'], _strPayBMeta));
    } else if (isInserting) {
      context.missing(_strPayBMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {strDate};
  @override
  Monie map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Monie.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $MoniesTable createAlias(String alias) {
    return $MoniesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $MoniesTable _monies;
  $MoniesTable get monies => _monies ??= $MoniesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [monies];
}
