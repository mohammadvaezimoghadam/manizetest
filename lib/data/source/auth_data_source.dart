import 'package:dio/dio.dart';

import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/auth_info.dart';
import 'package:manize/data/base_response.dart';

abstract class IAuthDataSource {
  Future<BaseResponse> login(String phone, String code);
  Future<BaseResponse> signUp(
      String name, String phone, String code, String regent, String lastName);
  Future<BaseResponse> sendCode(String phone);
  // Future<AuthInfoEntity> refreshToken(String token);
}

class AuthRemotDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemotDataSource(this.httpClient);
  @override
  Future<BaseResponse> login(String phone, String code) async {
    final response =
        await httpClient.post('login', data: {"phone": phone, "code": code});
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"],
          AuthInfoEntity.fromJson(response.data["user"]));
    }
  }

  @override
  Future<BaseResponse> signUp(String name, String phone, String code,
      String regent, String lastName) async {
    final response = await httpClient.post('register', data: {
      "first_name": name,
      "phone": phone,
      "code": code,
      "regent": regent.isEmpty?null:regent,
      "last_name": lastName
    });
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"],
          AuthInfoEntity.fromJson(response.data["user"]));
    }
  }

  @override
  Future<BaseResponse> sendCode(String phone) async {
    final response = await httpClient.get('code/$phone');
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"], response.data["message"]);
    }
  }

  // @override
  // Future<AuthInfoEntity> refreshToken(String token)async{
  //   final response=await httpClient.post('oauth/token',data: {
  //     "grant_type":"refresh_token",
  //     "refresh_token":token,
  //     "client_id":2,
  //     "client_secret":Constans.clientSecret,
  //     "scope":"",

  //   });
  //   validateResponse(response);
  //   return AuthInfoEntity(accessToken, refreshToken);
  // }
}
