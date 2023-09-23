import 'dart:convert';

TokenModel tokenModelFromJsonFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelFromJsonToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  String accessToken;
  String refreshToken;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
