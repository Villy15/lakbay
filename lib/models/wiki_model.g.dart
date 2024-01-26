// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wiki_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WikiModelImpl _$$WikiModelImplFromJson(Map<String, dynamic> json) =>
    _$WikiModelImpl(
      uid: json['uid'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$WikiModelImplToJson(_$WikiModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'description': instance.description,
      'imagePath': instance.imagePath,
      'imageUrl': instance.imageUrl,
    };
