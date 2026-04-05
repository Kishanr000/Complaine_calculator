// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationRecordAdapter extends TypeAdapter<CalculationRecord> {
  @override
  final int typeId = 0;

  @override
  CalculationRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationRecord(
      year: fields[0] as int,
      month: fields[1] as int,
      workingDays: fields[2] as int,
      requiredDays: fields[3] as int,
      attendedDays: fields[4] as int,
      calculatedAt: fields[5] as DateTime,
      percentage: fields[6] as double,
      isCompliant: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.workingDays)
      ..writeByte(3)
      ..write(obj.requiredDays)
      ..writeByte(4)
      ..write(obj.attendedDays)
      ..writeByte(5)
      ..write(obj.calculatedAt)
      ..writeByte(6)
      ..write(obj.percentage)
      ..writeByte(7)
      ..write(obj.isCompliant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
