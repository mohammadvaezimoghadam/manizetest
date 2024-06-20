import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/top_user_entity.dart';

abstract class ITopUserDataSource {
  Future<BaseResponse> getTopUsers();
}

class TopUserDataSource
    with HttpResponseValidator
    implements ITopUserDataSource {
  final Dio httpClient;

  TopUserDataSource(this.httpClient);

  @override
  Future<BaseResponse> getTopUsers() async {
    final response = await httpClient.get('top');
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      List<TopUserEntity> topUsers = [];
      (response.data["data"]["users"] as List).forEach((element) {
        topUsers.add(TopUserEntity.fromJson(element));
      });

      return BaseResponse(response.data["error"], topUsers);
    }
  }
}
