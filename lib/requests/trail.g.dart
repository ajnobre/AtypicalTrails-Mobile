// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trail _$TrailFromJson(Map<String, dynamic> json) {
  return Trail(
      json['codeName'] as String,
      json['username'] as String,
      json['feedback'] as int,
      json['comment'] as String,
      json['timeToComplete'] as int);
}

Map<String, dynamic> _$TrailToJson(Trail instance) => <String, dynamic>{
      'codeName': instance.codeName,
      'username': instance.username,
      'feedback': instance.feedback,
      'comment': instance.comment,
      'timeToComplete': instance.timeToComplete
    };
