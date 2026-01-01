// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProviderHiveModelAdapter extends TypeAdapter<ProviderHiveModel> {
  @override
  final int typeId = 5;

  @override
  ProviderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderHiveModel(
      providerId: fields[0] as String?,
      business_Name: fields[1] as String,
      address: fields[2] as String?,
      phone: fields[3] as String?,
      rating: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.providerId)
      ..writeByte(1)
      ..write(obj.business_Name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
