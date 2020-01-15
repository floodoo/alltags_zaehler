// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countButton.obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountButtonObj _$CountButtonObjFromJson(Map<String, dynamic> json) {
  return CountButtonObj(
    json['name'] as String,
    json['message'] as String,
    json['icon'] as String,
    json['color'] as int,
  );
}

Map<String, dynamic> _$CountButtonObjToJson(CountButtonObj instance) =>
    <String, dynamic>{
      'name': instance.name,
      'message': instance.message,
      'icon': instance.icon,
      'color': instance.color,
    };
