// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bidData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidData _$BidDataFromJson(Map<String, dynamic> json) {
  return BidData()
    ..paraId = json['paraId'] as String
    ..value = json['value']
    ..firstSlot = json['firstSlot'] as int
    ..lastSlot = json['lastSlot'] as int
    ..isCrowdloan = json['isCrowdloan'] as bool;
}

Map<String, dynamic> _$BidDataToJson(BidData instance) => <String, dynamic>{
      'paraId': instance.paraId,
      'value': instance.value,
      'firstSlot': instance.firstSlot,
      'lastSlot': instance.lastSlot,
      'isCrowdloan': instance.isCrowdloan,
    };
