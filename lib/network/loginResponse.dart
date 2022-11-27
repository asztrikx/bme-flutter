import 'dart:convert';

class LoginResponse{
  final String? token;
  final String? message;

  LoginResponse(this.token, this.message);

  LoginResponse.fromJson(Map<String, dynamic> json): this(json["token"], json["message"]);
}