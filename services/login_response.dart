part 'login_response.g.dart';

class LoginResponse{
  String message;
  String token = '';

  LoginResponse(this.message, {this.token});

  factory LoginResponse.fromJson(Map<String,dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
