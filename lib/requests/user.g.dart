// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['username'] as String,
      json['email'] as String,
      json['password'] as String,
      json['tokenID'] as String,
      json['sessionTime'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'tokenID': instance.tokenID,
      'sessionTime': instance.sessionTime
    };
