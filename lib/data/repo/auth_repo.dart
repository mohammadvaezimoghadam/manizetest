import 'package:flutter/material.dart';
import 'package:manize/common/http_client.dart';
import 'package:manize/data/auth_info.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemotDataSource(httpClient));

abstract class IAuthReposetory {
  Future<BaseResponse> login(String phone, String code);
  Future<BaseResponse> singUp(
      String firstName, String phone, String code, String regent,String lastName);
  Future<BaseResponse> sendCode(String phone);
  Future<void> singOut();
  // Future<void> refreshToken(String token);
}

class AuthRepository implements IAuthReposetory {
  static final ValueNotifier<AuthInfoEntity?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  @override
  Future<BaseResponse> login(String phone, String code) async {
    final BaseResponse baseResponse = await dataSource.login(phone, code);
    if (baseResponse.error == false) {
      final AuthInfoEntity authInfoEntity = baseResponse.body;
      _persistAuthToken(authInfoEntity);
      return baseResponse;
    } else {
      return baseResponse;
    }
  }

  @override
  Future<BaseResponse> singUp(
      String name, String phone, String code, String regent,String lastName) async {
    final BaseResponse baseResponse =
        await dataSource.signUp(name, phone, code, regent,lastName);
    if (baseResponse.error == false) {
      final AuthInfoEntity authInfoEntity = baseResponse.body;
      _persistAuthToken(authInfoEntity);
      return baseResponse;
    } else {
      return baseResponse;
    }
  }

  // @override
  // Future<void> refreshToken(String token) {
  //   // TODO: implement refreshToken
  //   throw UnimplementedError();
  // }

  Future<void> _persistAuthToken(AuthInfoEntity authInfoEntity) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfoEntity.accessToken);
    sharedPreferences.setString("refresh_token", authInfoEntity.refreshToken);
    sharedPreferences.setString("phone", authInfoEntity.phone!);
    sharedPreferences.setString("first_name", authInfoEntity.firstName!);
    sharedPreferences.setString("last_name", authInfoEntity.lastName!);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? "";
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? "";

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfoEntity(
        accessToken,
        refreshToken,
      );
    }
  }

  @override
  Future<BaseResponse> sendCode(String phone) async {
    final baseResoinse = await dataSource.sendCode(phone);
    return baseResoinse ;
  }

  @override
  Future<void> singOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    authChangeNotifier.value = null;
    loadAuthInfo();
  }
}
