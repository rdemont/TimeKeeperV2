// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeSlotAdapter extends TypeAdapter<TimeSlot> {
  @override
  final int typeId = 1;

  @override
  TimeSlot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeSlot(fields[0] as String, fields[1] as String,
        fields[2] as String, fields[3] as String?);
  }

  @override
  void write(BinaryWriter writer, TimeSlot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._date)
      ..writeByte(1)
      ..write(obj._startTime)
      ..writeByte(2)
      ..write(obj._endTime)
      ..writeByte(3)
      ..write(obj._description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
