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
  final String strBankE;
  final String strBankF;
  final String strBankG;
  final String strBankH;
  final String strPayA;
  final String strPayB;
  final String strPayC;
  final String strPayD;
  final String strPayE;
  final String strPayF;
  final String strPayG;
  final String strPayH;
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
      @required this.strBankE,
      @required this.strBankF,
      @required this.strBankG,
      @required this.strBankH,
      @required this.strPayA,
      @required this.strPayB,
      @required this.strPayC,
      @required this.strPayD,
      @required this.strPayE,
      @required this.strPayF,
      @required this.strPayG,
      @required this.strPayH});
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
      strBankE: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_e']),
      strBankF: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_f']),
      strBankG: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_g']),
      strBankH: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank_h']),
      strPayA: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_a']),
      strPayB: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_b']),
      strPayC: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_c']),
      strPayD: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_d']),
      strPayE: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_e']),
      strPayF: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_f']),
      strPayG: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_g']),
      strPayH: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_pay_h']),
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
    if (!nullToAbsent || strBankE != null) {
      map['str_bank_e'] = Variable<String>(strBankE);
    }
    if (!nullToAbsent || strBankF != null) {
      map['str_bank_f'] = Variable<String>(strBankF);
    }
    if (!nullToAbsent || strBankG != null) {
      map['str_bank_g'] = Variable<String>(strBankG);
    }
    if (!nullToAbsent || strBankH != null) {
      map['str_bank_h'] = Variable<String>(strBankH);
    }
    if (!nullToAbsent || strPayA != null) {
      map['str_pay_a'] = Variable<String>(strPayA);
    }
    if (!nullToAbsent || strPayB != null) {
      map['str_pay_b'] = Variable<String>(strPayB);
    }
    if (!nullToAbsent || strPayC != null) {
      map['str_pay_c'] = Variable<String>(strPayC);
    }
    if (!nullToAbsent || strPayD != null) {
      map['str_pay_d'] = Variable<String>(strPayD);
    }
    if (!nullToAbsent || strPayE != null) {
      map['str_pay_e'] = Variable<String>(strPayE);
    }
    if (!nullToAbsent || strPayF != null) {
      map['str_pay_f'] = Variable<String>(strPayF);
    }
    if (!nullToAbsent || strPayG != null) {
      map['str_pay_g'] = Variable<String>(strPayG);
    }
    if (!nullToAbsent || strPayH != null) {
      map['str_pay_h'] = Variable<String>(strPayH);
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
      strBankE: strBankE == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankE),
      strBankF: strBankF == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankF),
      strBankG: strBankG == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankG),
      strBankH: strBankH == null && nullToAbsent
          ? const Value.absent()
          : Value(strBankH),
      strPayA: strPayA == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayA),
      strPayB: strPayB == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayB),
      strPayC: strPayC == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayC),
      strPayD: strPayD == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayD),
      strPayE: strPayE == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayE),
      strPayF: strPayF == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayF),
      strPayG: strPayG == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayG),
      strPayH: strPayH == null && nullToAbsent
          ? const Value.absent()
          : Value(strPayH),
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
      strBankE: serializer.fromJson<String>(json['strBankE']),
      strBankF: serializer.fromJson<String>(json['strBankF']),
      strBankG: serializer.fromJson<String>(json['strBankG']),
      strBankH: serializer.fromJson<String>(json['strBankH']),
      strPayA: serializer.fromJson<String>(json['strPayA']),
      strPayB: serializer.fromJson<String>(json['strPayB']),
      strPayC: serializer.fromJson<String>(json['strPayC']),
      strPayD: serializer.fromJson<String>(json['strPayD']),
      strPayE: serializer.fromJson<String>(json['strPayE']),
      strPayF: serializer.fromJson<String>(json['strPayF']),
      strPayG: serializer.fromJson<String>(json['strPayG']),
      strPayH: serializer.fromJson<String>(json['strPayH']),
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
      'strBankE': serializer.toJson<String>(strBankE),
      'strBankF': serializer.toJson<String>(strBankF),
      'strBankG': serializer.toJson<String>(strBankG),
      'strBankH': serializer.toJson<String>(strBankH),
      'strPayA': serializer.toJson<String>(strPayA),
      'strPayB': serializer.toJson<String>(strPayB),
      'strPayC': serializer.toJson<String>(strPayC),
      'strPayD': serializer.toJson<String>(strPayD),
      'strPayE': serializer.toJson<String>(strPayE),
      'strPayF': serializer.toJson<String>(strPayF),
      'strPayG': serializer.toJson<String>(strPayG),
      'strPayH': serializer.toJson<String>(strPayH),
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
          String strBankE,
          String strBankF,
          String strBankG,
          String strBankH,
          String strPayA,
          String strPayB,
          String strPayC,
          String strPayD,
          String strPayE,
          String strPayF,
          String strPayG,
          String strPayH}) =>
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
        strBankE: strBankE ?? this.strBankE,
        strBankF: strBankF ?? this.strBankF,
        strBankG: strBankG ?? this.strBankG,
        strBankH: strBankH ?? this.strBankH,
        strPayA: strPayA ?? this.strPayA,
        strPayB: strPayB ?? this.strPayB,
        strPayC: strPayC ?? this.strPayC,
        strPayD: strPayD ?? this.strPayD,
        strPayE: strPayE ?? this.strPayE,
        strPayF: strPayF ?? this.strPayF,
        strPayG: strPayG ?? this.strPayG,
        strPayH: strPayH ?? this.strPayH,
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
          ..write('strBankE: $strBankE, ')
          ..write('strBankF: $strBankF, ')
          ..write('strBankG: $strBankG, ')
          ..write('strBankH: $strBankH, ')
          ..write('strPayA: $strPayA, ')
          ..write('strPayB: $strPayB, ')
          ..write('strPayC: $strPayC, ')
          ..write('strPayD: $strPayD, ')
          ..write('strPayE: $strPayE, ')
          ..write('strPayF: $strPayF, ')
          ..write('strPayG: $strPayG, ')
          ..write('strPayH: $strPayH')
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
                                                                  strBankE
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      strBankF
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          strBankG
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              strBankH.hashCode,
                                                                              $mrjc(strPayA.hashCode, $mrjc(strPayB.hashCode, $mrjc(strPayC.hashCode, $mrjc(strPayD.hashCode, $mrjc(strPayE.hashCode, $mrjc(strPayF.hashCode, $mrjc(strPayG.hashCode, strPayH.hashCode)))))))))))))))))))))))))));
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
          other.strBankE == this.strBankE &&
          other.strBankF == this.strBankF &&
          other.strBankG == this.strBankG &&
          other.strBankH == this.strBankH &&
          other.strPayA == this.strPayA &&
          other.strPayB == this.strPayB &&
          other.strPayC == this.strPayC &&
          other.strPayD == this.strPayD &&
          other.strPayE == this.strPayE &&
          other.strPayF == this.strPayF &&
          other.strPayG == this.strPayG &&
          other.strPayH == this.strPayH);
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
  final Value<String> strBankE;
  final Value<String> strBankF;
  final Value<String> strBankG;
  final Value<String> strBankH;
  final Value<String> strPayA;
  final Value<String> strPayB;
  final Value<String> strPayC;
  final Value<String> strPayD;
  final Value<String> strPayE;
  final Value<String> strPayF;
  final Value<String> strPayG;
  final Value<String> strPayH;
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
    this.strBankE = const Value.absent(),
    this.strBankF = const Value.absent(),
    this.strBankG = const Value.absent(),
    this.strBankH = const Value.absent(),
    this.strPayA = const Value.absent(),
    this.strPayB = const Value.absent(),
    this.strPayC = const Value.absent(),
    this.strPayD = const Value.absent(),
    this.strPayE = const Value.absent(),
    this.strPayF = const Value.absent(),
    this.strPayG = const Value.absent(),
    this.strPayH = const Value.absent(),
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
    @required String strBankE,
    @required String strBankF,
    @required String strBankG,
    @required String strBankH,
    @required String strPayA,
    @required String strPayB,
    @required String strPayC,
    @required String strPayD,
    @required String strPayE,
    @required String strPayF,
    @required String strPayG,
    @required String strPayH,
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
        strBankE = Value(strBankE),
        strBankF = Value(strBankF),
        strBankG = Value(strBankG),
        strBankH = Value(strBankH),
        strPayA = Value(strPayA),
        strPayB = Value(strPayB),
        strPayC = Value(strPayC),
        strPayD = Value(strPayD),
        strPayE = Value(strPayE),
        strPayF = Value(strPayF),
        strPayG = Value(strPayG),
        strPayH = Value(strPayH);
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
    Expression<String> strBankE,
    Expression<String> strBankF,
    Expression<String> strBankG,
    Expression<String> strBankH,
    Expression<String> strPayA,
    Expression<String> strPayB,
    Expression<String> strPayC,
    Expression<String> strPayD,
    Expression<String> strPayE,
    Expression<String> strPayF,
    Expression<String> strPayG,
    Expression<String> strPayH,
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
      if (strBankE != null) 'str_bank_e': strBankE,
      if (strBankF != null) 'str_bank_f': strBankF,
      if (strBankG != null) 'str_bank_g': strBankG,
      if (strBankH != null) 'str_bank_h': strBankH,
      if (strPayA != null) 'str_pay_a': strPayA,
      if (strPayB != null) 'str_pay_b': strPayB,
      if (strPayC != null) 'str_pay_c': strPayC,
      if (strPayD != null) 'str_pay_d': strPayD,
      if (strPayE != null) 'str_pay_e': strPayE,
      if (strPayF != null) 'str_pay_f': strPayF,
      if (strPayG != null) 'str_pay_g': strPayG,
      if (strPayH != null) 'str_pay_h': strPayH,
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
      Value<String> strBankE,
      Value<String> strBankF,
      Value<String> strBankG,
      Value<String> strBankH,
      Value<String> strPayA,
      Value<String> strPayB,
      Value<String> strPayC,
      Value<String> strPayD,
      Value<String> strPayE,
      Value<String> strPayF,
      Value<String> strPayG,
      Value<String> strPayH}) {
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
      strBankE: strBankE ?? this.strBankE,
      strBankF: strBankF ?? this.strBankF,
      strBankG: strBankG ?? this.strBankG,
      strBankH: strBankH ?? this.strBankH,
      strPayA: strPayA ?? this.strPayA,
      strPayB: strPayB ?? this.strPayB,
      strPayC: strPayC ?? this.strPayC,
      strPayD: strPayD ?? this.strPayD,
      strPayE: strPayE ?? this.strPayE,
      strPayF: strPayF ?? this.strPayF,
      strPayG: strPayG ?? this.strPayG,
      strPayH: strPayH ?? this.strPayH,
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
    if (strBankE.present) {
      map['str_bank_e'] = Variable<String>(strBankE.value);
    }
    if (strBankF.present) {
      map['str_bank_f'] = Variable<String>(strBankF.value);
    }
    if (strBankG.present) {
      map['str_bank_g'] = Variable<String>(strBankG.value);
    }
    if (strBankH.present) {
      map['str_bank_h'] = Variable<String>(strBankH.value);
    }
    if (strPayA.present) {
      map['str_pay_a'] = Variable<String>(strPayA.value);
    }
    if (strPayB.present) {
      map['str_pay_b'] = Variable<String>(strPayB.value);
    }
    if (strPayC.present) {
      map['str_pay_c'] = Variable<String>(strPayC.value);
    }
    if (strPayD.present) {
      map['str_pay_d'] = Variable<String>(strPayD.value);
    }
    if (strPayE.present) {
      map['str_pay_e'] = Variable<String>(strPayE.value);
    }
    if (strPayF.present) {
      map['str_pay_f'] = Variable<String>(strPayF.value);
    }
    if (strPayG.present) {
      map['str_pay_g'] = Variable<String>(strPayG.value);
    }
    if (strPayH.present) {
      map['str_pay_h'] = Variable<String>(strPayH.value);
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

  final VerificationMeta _strBankEMeta = const VerificationMeta('strBankE');
  GeneratedTextColumn _strBankE;
  @override
  GeneratedTextColumn get strBankE => _strBankE ??= _constructStrBankE();
  GeneratedTextColumn _constructStrBankE() {
    return GeneratedTextColumn(
      'str_bank_e',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankFMeta = const VerificationMeta('strBankF');
  GeneratedTextColumn _strBankF;
  @override
  GeneratedTextColumn get strBankF => _strBankF ??= _constructStrBankF();
  GeneratedTextColumn _constructStrBankF() {
    return GeneratedTextColumn(
      'str_bank_f',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankGMeta = const VerificationMeta('strBankG');
  GeneratedTextColumn _strBankG;
  @override
  GeneratedTextColumn get strBankG => _strBankG ??= _constructStrBankG();
  GeneratedTextColumn _constructStrBankG() {
    return GeneratedTextColumn(
      'str_bank_g',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strBankHMeta = const VerificationMeta('strBankH');
  GeneratedTextColumn _strBankH;
  @override
  GeneratedTextColumn get strBankH => _strBankH ??= _constructStrBankH();
  GeneratedTextColumn _constructStrBankH() {
    return GeneratedTextColumn(
      'str_bank_h',
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

  final VerificationMeta _strPayCMeta = const VerificationMeta('strPayC');
  GeneratedTextColumn _strPayC;
  @override
  GeneratedTextColumn get strPayC => _strPayC ??= _constructStrPayC();
  GeneratedTextColumn _constructStrPayC() {
    return GeneratedTextColumn(
      'str_pay_c',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayDMeta = const VerificationMeta('strPayD');
  GeneratedTextColumn _strPayD;
  @override
  GeneratedTextColumn get strPayD => _strPayD ??= _constructStrPayD();
  GeneratedTextColumn _constructStrPayD() {
    return GeneratedTextColumn(
      'str_pay_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayEMeta = const VerificationMeta('strPayE');
  GeneratedTextColumn _strPayE;
  @override
  GeneratedTextColumn get strPayE => _strPayE ??= _constructStrPayE();
  GeneratedTextColumn _constructStrPayE() {
    return GeneratedTextColumn(
      'str_pay_e',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayFMeta = const VerificationMeta('strPayF');
  GeneratedTextColumn _strPayF;
  @override
  GeneratedTextColumn get strPayF => _strPayF ??= _constructStrPayF();
  GeneratedTextColumn _constructStrPayF() {
    return GeneratedTextColumn(
      'str_pay_f',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayGMeta = const VerificationMeta('strPayG');
  GeneratedTextColumn _strPayG;
  @override
  GeneratedTextColumn get strPayG => _strPayG ??= _constructStrPayG();
  GeneratedTextColumn _constructStrPayG() {
    return GeneratedTextColumn(
      'str_pay_g',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPayHMeta = const VerificationMeta('strPayH');
  GeneratedTextColumn _strPayH;
  @override
  GeneratedTextColumn get strPayH => _strPayH ??= _constructStrPayH();
  GeneratedTextColumn _constructStrPayH() {
    return GeneratedTextColumn(
      'str_pay_h',
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
        strBankE,
        strBankF,
        strBankG,
        strBankH,
        strPayA,
        strPayB,
        strPayC,
        strPayD,
        strPayE,
        strPayF,
        strPayG,
        strPayH
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
    if (data.containsKey('str_bank_e')) {
      context.handle(_strBankEMeta,
          strBankE.isAcceptableOrUnknown(data['str_bank_e'], _strBankEMeta));
    } else if (isInserting) {
      context.missing(_strBankEMeta);
    }
    if (data.containsKey('str_bank_f')) {
      context.handle(_strBankFMeta,
          strBankF.isAcceptableOrUnknown(data['str_bank_f'], _strBankFMeta));
    } else if (isInserting) {
      context.missing(_strBankFMeta);
    }
    if (data.containsKey('str_bank_g')) {
      context.handle(_strBankGMeta,
          strBankG.isAcceptableOrUnknown(data['str_bank_g'], _strBankGMeta));
    } else if (isInserting) {
      context.missing(_strBankGMeta);
    }
    if (data.containsKey('str_bank_h')) {
      context.handle(_strBankHMeta,
          strBankH.isAcceptableOrUnknown(data['str_bank_h'], _strBankHMeta));
    } else if (isInserting) {
      context.missing(_strBankHMeta);
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
    if (data.containsKey('str_pay_c')) {
      context.handle(_strPayCMeta,
          strPayC.isAcceptableOrUnknown(data['str_pay_c'], _strPayCMeta));
    } else if (isInserting) {
      context.missing(_strPayCMeta);
    }
    if (data.containsKey('str_pay_d')) {
      context.handle(_strPayDMeta,
          strPayD.isAcceptableOrUnknown(data['str_pay_d'], _strPayDMeta));
    } else if (isInserting) {
      context.missing(_strPayDMeta);
    }
    if (data.containsKey('str_pay_e')) {
      context.handle(_strPayEMeta,
          strPayE.isAcceptableOrUnknown(data['str_pay_e'], _strPayEMeta));
    } else if (isInserting) {
      context.missing(_strPayEMeta);
    }
    if (data.containsKey('str_pay_f')) {
      context.handle(_strPayFMeta,
          strPayF.isAcceptableOrUnknown(data['str_pay_f'], _strPayFMeta));
    } else if (isInserting) {
      context.missing(_strPayFMeta);
    }
    if (data.containsKey('str_pay_g')) {
      context.handle(_strPayGMeta,
          strPayG.isAcceptableOrUnknown(data['str_pay_g'], _strPayGMeta));
    } else if (isInserting) {
      context.missing(_strPayGMeta);
    }
    if (data.containsKey('str_pay_h')) {
      context.handle(_strPayHMeta,
          strPayH.isAcceptableOrUnknown(data['str_pay_h'], _strPayHMeta));
    } else if (isInserting) {
      context.missing(_strPayHMeta);
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

class Benefit extends DataClass implements Insertable<Benefit> {
  final String strDate;
  final String strCompany;
  final String strPrice;
  Benefit(
      {@required this.strDate,
      @required this.strCompany,
      @required this.strPrice});
  factory Benefit.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Benefit(
      strDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_date']),
      strCompany: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_company']),
      strPrice: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_price']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || strDate != null) {
      map['str_date'] = Variable<String>(strDate);
    }
    if (!nullToAbsent || strCompany != null) {
      map['str_company'] = Variable<String>(strCompany);
    }
    if (!nullToAbsent || strPrice != null) {
      map['str_price'] = Variable<String>(strPrice);
    }
    return map;
  }

  BenefitsCompanion toCompanion(bool nullToAbsent) {
    return BenefitsCompanion(
      strDate: strDate == null && nullToAbsent
          ? const Value.absent()
          : Value(strDate),
      strCompany: strCompany == null && nullToAbsent
          ? const Value.absent()
          : Value(strCompany),
      strPrice: strPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(strPrice),
    );
  }

  factory Benefit.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Benefit(
      strDate: serializer.fromJson<String>(json['strDate']),
      strCompany: serializer.fromJson<String>(json['strCompany']),
      strPrice: serializer.fromJson<String>(json['strPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'strDate': serializer.toJson<String>(strDate),
      'strCompany': serializer.toJson<String>(strCompany),
      'strPrice': serializer.toJson<String>(strPrice),
    };
  }

  Benefit copyWith({String strDate, String strCompany, String strPrice}) =>
      Benefit(
        strDate: strDate ?? this.strDate,
        strCompany: strCompany ?? this.strCompany,
        strPrice: strPrice ?? this.strPrice,
      );
  @override
  String toString() {
    return (StringBuffer('Benefit(')
          ..write('strDate: $strDate, ')
          ..write('strCompany: $strCompany, ')
          ..write('strPrice: $strPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(strDate.hashCode, $mrjc(strCompany.hashCode, strPrice.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Benefit &&
          other.strDate == this.strDate &&
          other.strCompany == this.strCompany &&
          other.strPrice == this.strPrice);
}

class BenefitsCompanion extends UpdateCompanion<Benefit> {
  final Value<String> strDate;
  final Value<String> strCompany;
  final Value<String> strPrice;
  const BenefitsCompanion({
    this.strDate = const Value.absent(),
    this.strCompany = const Value.absent(),
    this.strPrice = const Value.absent(),
  });
  BenefitsCompanion.insert({
    @required String strDate,
    @required String strCompany,
    @required String strPrice,
  })  : strDate = Value(strDate),
        strCompany = Value(strCompany),
        strPrice = Value(strPrice);
  static Insertable<Benefit> custom({
    Expression<String> strDate,
    Expression<String> strCompany,
    Expression<String> strPrice,
  }) {
    return RawValuesInsertable({
      if (strDate != null) 'str_date': strDate,
      if (strCompany != null) 'str_company': strCompany,
      if (strPrice != null) 'str_price': strPrice,
    });
  }

  BenefitsCompanion copyWith(
      {Value<String> strDate,
      Value<String> strCompany,
      Value<String> strPrice}) {
    return BenefitsCompanion(
      strDate: strDate ?? this.strDate,
      strCompany: strCompany ?? this.strCompany,
      strPrice: strPrice ?? this.strPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (strDate.present) {
      map['str_date'] = Variable<String>(strDate.value);
    }
    if (strCompany.present) {
      map['str_company'] = Variable<String>(strCompany.value);
    }
    if (strPrice.present) {
      map['str_price'] = Variable<String>(strPrice.value);
    }
    return map;
  }
}

class $BenefitsTable extends Benefits with TableInfo<$BenefitsTable, Benefit> {
  final GeneratedDatabase _db;
  final String _alias;
  $BenefitsTable(this._db, [this._alias]);
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

  final VerificationMeta _strCompanyMeta = const VerificationMeta('strCompany');
  GeneratedTextColumn _strCompany;
  @override
  GeneratedTextColumn get strCompany => _strCompany ??= _constructStrCompany();
  GeneratedTextColumn _constructStrCompany() {
    return GeneratedTextColumn(
      'str_company',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPriceMeta = const VerificationMeta('strPrice');
  GeneratedTextColumn _strPrice;
  @override
  GeneratedTextColumn get strPrice => _strPrice ??= _constructStrPrice();
  GeneratedTextColumn _constructStrPrice() {
    return GeneratedTextColumn(
      'str_price',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [strDate, strCompany, strPrice];
  @override
  $BenefitsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'benefits';
  @override
  final String actualTableName = 'benefits';
  @override
  VerificationContext validateIntegrity(Insertable<Benefit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('str_date')) {
      context.handle(_strDateMeta,
          strDate.isAcceptableOrUnknown(data['str_date'], _strDateMeta));
    } else if (isInserting) {
      context.missing(_strDateMeta);
    }
    if (data.containsKey('str_company')) {
      context.handle(
          _strCompanyMeta,
          strCompany.isAcceptableOrUnknown(
              data['str_company'], _strCompanyMeta));
    } else if (isInserting) {
      context.missing(_strCompanyMeta);
    }
    if (data.containsKey('str_price')) {
      context.handle(_strPriceMeta,
          strPrice.isAcceptableOrUnknown(data['str_price'], _strPriceMeta));
    } else if (isInserting) {
      context.missing(_strPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {strDate};
  @override
  Benefit map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Benefit.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $BenefitsTable createAlias(String alias) {
    return $BenefitsTable(_db, alias);
  }
}

class Credit extends DataClass implements Insertable<Credit> {
  final int intId;
  final String strDate;
  final String strBank;
  final String strItem;
  final String strPrice;
  Credit(
      {@required this.intId,
      @required this.strDate,
      @required this.strBank,
      @required this.strItem,
      @required this.strPrice});
  factory Credit.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Credit(
      intId: intType.mapFromDatabaseResponse(data['${effectivePrefix}int_id']),
      strDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_date']),
      strBank: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_bank']),
      strItem: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_item']),
      strPrice: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_price']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || intId != null) {
      map['int_id'] = Variable<int>(intId);
    }
    if (!nullToAbsent || strDate != null) {
      map['str_date'] = Variable<String>(strDate);
    }
    if (!nullToAbsent || strBank != null) {
      map['str_bank'] = Variable<String>(strBank);
    }
    if (!nullToAbsent || strItem != null) {
      map['str_item'] = Variable<String>(strItem);
    }
    if (!nullToAbsent || strPrice != null) {
      map['str_price'] = Variable<String>(strPrice);
    }
    return map;
  }

  CreditsCompanion toCompanion(bool nullToAbsent) {
    return CreditsCompanion(
      intId:
          intId == null && nullToAbsent ? const Value.absent() : Value(intId),
      strDate: strDate == null && nullToAbsent
          ? const Value.absent()
          : Value(strDate),
      strBank: strBank == null && nullToAbsent
          ? const Value.absent()
          : Value(strBank),
      strItem: strItem == null && nullToAbsent
          ? const Value.absent()
          : Value(strItem),
      strPrice: strPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(strPrice),
    );
  }

  factory Credit.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Credit(
      intId: serializer.fromJson<int>(json['intId']),
      strDate: serializer.fromJson<String>(json['strDate']),
      strBank: serializer.fromJson<String>(json['strBank']),
      strItem: serializer.fromJson<String>(json['strItem']),
      strPrice: serializer.fromJson<String>(json['strPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'intId': serializer.toJson<int>(intId),
      'strDate': serializer.toJson<String>(strDate),
      'strBank': serializer.toJson<String>(strBank),
      'strItem': serializer.toJson<String>(strItem),
      'strPrice': serializer.toJson<String>(strPrice),
    };
  }

  Credit copyWith(
          {int intId,
          String strDate,
          String strBank,
          String strItem,
          String strPrice}) =>
      Credit(
        intId: intId ?? this.intId,
        strDate: strDate ?? this.strDate,
        strBank: strBank ?? this.strBank,
        strItem: strItem ?? this.strItem,
        strPrice: strPrice ?? this.strPrice,
      );
  @override
  String toString() {
    return (StringBuffer('Credit(')
          ..write('intId: $intId, ')
          ..write('strDate: $strDate, ')
          ..write('strBank: $strBank, ')
          ..write('strItem: $strItem, ')
          ..write('strPrice: $strPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      intId.hashCode,
      $mrjc(
          strDate.hashCode,
          $mrjc(
              strBank.hashCode, $mrjc(strItem.hashCode, strPrice.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Credit &&
          other.intId == this.intId &&
          other.strDate == this.strDate &&
          other.strBank == this.strBank &&
          other.strItem == this.strItem &&
          other.strPrice == this.strPrice);
}

class CreditsCompanion extends UpdateCompanion<Credit> {
  final Value<int> intId;
  final Value<String> strDate;
  final Value<String> strBank;
  final Value<String> strItem;
  final Value<String> strPrice;
  const CreditsCompanion({
    this.intId = const Value.absent(),
    this.strDate = const Value.absent(),
    this.strBank = const Value.absent(),
    this.strItem = const Value.absent(),
    this.strPrice = const Value.absent(),
  });
  CreditsCompanion.insert({
    this.intId = const Value.absent(),
    @required String strDate,
    @required String strBank,
    @required String strItem,
    @required String strPrice,
  })  : strDate = Value(strDate),
        strBank = Value(strBank),
        strItem = Value(strItem),
        strPrice = Value(strPrice);
  static Insertable<Credit> custom({
    Expression<int> intId,
    Expression<String> strDate,
    Expression<String> strBank,
    Expression<String> strItem,
    Expression<String> strPrice,
  }) {
    return RawValuesInsertable({
      if (intId != null) 'int_id': intId,
      if (strDate != null) 'str_date': strDate,
      if (strBank != null) 'str_bank': strBank,
      if (strItem != null) 'str_item': strItem,
      if (strPrice != null) 'str_price': strPrice,
    });
  }

  CreditsCompanion copyWith(
      {Value<int> intId,
      Value<String> strDate,
      Value<String> strBank,
      Value<String> strItem,
      Value<String> strPrice}) {
    return CreditsCompanion(
      intId: intId ?? this.intId,
      strDate: strDate ?? this.strDate,
      strBank: strBank ?? this.strBank,
      strItem: strItem ?? this.strItem,
      strPrice: strPrice ?? this.strPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (intId.present) {
      map['int_id'] = Variable<int>(intId.value);
    }
    if (strDate.present) {
      map['str_date'] = Variable<String>(strDate.value);
    }
    if (strBank.present) {
      map['str_bank'] = Variable<String>(strBank.value);
    }
    if (strItem.present) {
      map['str_item'] = Variable<String>(strItem.value);
    }
    if (strPrice.present) {
      map['str_price'] = Variable<String>(strPrice.value);
    }
    return map;
  }
}

class $CreditsTable extends Credits with TableInfo<$CreditsTable, Credit> {
  final GeneratedDatabase _db;
  final String _alias;
  $CreditsTable(this._db, [this._alias]);
  final VerificationMeta _intIdMeta = const VerificationMeta('intId');
  GeneratedIntColumn _intId;
  @override
  GeneratedIntColumn get intId => _intId ??= _constructIntId();
  GeneratedIntColumn _constructIntId() {
    return GeneratedIntColumn('int_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

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

  final VerificationMeta _strBankMeta = const VerificationMeta('strBank');
  GeneratedTextColumn _strBank;
  @override
  GeneratedTextColumn get strBank => _strBank ??= _constructStrBank();
  GeneratedTextColumn _constructStrBank() {
    return GeneratedTextColumn(
      'str_bank',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strItemMeta = const VerificationMeta('strItem');
  GeneratedTextColumn _strItem;
  @override
  GeneratedTextColumn get strItem => _strItem ??= _constructStrItem();
  GeneratedTextColumn _constructStrItem() {
    return GeneratedTextColumn(
      'str_item',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strPriceMeta = const VerificationMeta('strPrice');
  GeneratedTextColumn _strPrice;
  @override
  GeneratedTextColumn get strPrice => _strPrice ??= _constructStrPrice();
  GeneratedTextColumn _constructStrPrice() {
    return GeneratedTextColumn(
      'str_price',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [intId, strDate, strBank, strItem, strPrice];
  @override
  $CreditsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'credits';
  @override
  final String actualTableName = 'credits';
  @override
  VerificationContext validateIntegrity(Insertable<Credit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('int_id')) {
      context.handle(
          _intIdMeta, intId.isAcceptableOrUnknown(data['int_id'], _intIdMeta));
    }
    if (data.containsKey('str_date')) {
      context.handle(_strDateMeta,
          strDate.isAcceptableOrUnknown(data['str_date'], _strDateMeta));
    } else if (isInserting) {
      context.missing(_strDateMeta);
    }
    if (data.containsKey('str_bank')) {
      context.handle(_strBankMeta,
          strBank.isAcceptableOrUnknown(data['str_bank'], _strBankMeta));
    } else if (isInserting) {
      context.missing(_strBankMeta);
    }
    if (data.containsKey('str_item')) {
      context.handle(_strItemMeta,
          strItem.isAcceptableOrUnknown(data['str_item'], _strItemMeta));
    } else if (isInserting) {
      context.missing(_strItemMeta);
    }
    if (data.containsKey('str_price')) {
      context.handle(_strPriceMeta,
          strPrice.isAcceptableOrUnknown(data['str_price'], _strPriceMeta));
    } else if (isInserting) {
      context.missing(_strPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {intId};
  @override
  Credit map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Credit.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CreditsTable createAlias(String alias) {
    return $CreditsTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $MoniesTable _monies;
  $MoniesTable get monies => _monies ??= $MoniesTable(this);
  $BenefitsTable _benefits;
  $BenefitsTable get benefits => _benefits ??= $BenefitsTable(this);
  $CreditsTable _credits;
  $CreditsTable get credits => _credits ??= $CreditsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [monies, benefits, credits];
}
