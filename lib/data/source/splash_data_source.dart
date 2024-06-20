import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/splash_data.dart';

abstract class ISplashDataSource {
  Future<SplashData> getSplashData();
}

class SplashDataSource with HttpResponseValidator implements ISplashDataSource {
  final Dio httpClient;

  SplashDataSource(this.httpClient);
  @override
  Future<SplashData> getSplashData() async {
    final response = await httpClient.post('splash');
    validateResponse(response);
    return SplashData.fromJson(response.data["data"]);
  }
}
