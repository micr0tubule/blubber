// GENERATED CODE - DO NOT MODIFY BY HAND


part of 'signup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) {
  return SignUpResponse(json['message'] as String, token: json['token'] as String); 
}

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) => <String, dynamic>{
      'message': instance.message,
      'token': instance.token
    };
