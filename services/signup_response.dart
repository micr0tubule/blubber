part 'signup_response.g.dart';

class SignUpResponse{
  String message;
  String token = '';

  SignUpResponse(this.message, {this.token});

  factory SignUpResponse.fromJson(Map<String,dynamic> json) => _$SignUpResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}
