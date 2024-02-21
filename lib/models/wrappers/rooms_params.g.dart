// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetRoomsParamsImpl _$$GetRoomsParamsImplFromJson(Map<String, dynamic> json) =>
    _$GetRoomsParamsImpl(
      unavailableRoomUids: (json['unavailableRoomUids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      guests: json['guests'] as num?,
    );

Map<String, dynamic> _$$GetRoomsParamsImplToJson(
        _$GetRoomsParamsImpl instance) =>
    <String, dynamic>{
      'unavailableRoomUids': instance.unavailableRoomUids,
      'guests': instance.guests,
    };
