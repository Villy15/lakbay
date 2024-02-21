// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomsParamsImpl _$$RoomsParamsImplFromJson(Map<String, dynamic> json) =>
    _$RoomsParamsImpl(
      unavailableRoomUids: (json['unavailableRoomUids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      guests: json['guests'] as num,
    );

Map<String, dynamic> _$$RoomsParamsImplToJson(_$RoomsParamsImpl instance) =>
    <String, dynamic>{
      'unavailableRoomUids': instance.unavailableRoomUids,
      'guests': instance.guests,
    };
