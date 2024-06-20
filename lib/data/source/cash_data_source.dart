import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/wallet.dart';

abstract class ICashDataSource {
  Future<BaseResponse> getCash();
  Future<BaseResponse> getUserWalletData();
  Future<BaseResponse> convertCash(String moneyTypeId, String amount);
}

class CashDataSource with HttpResponseValidator implements ICashDataSource {
  final Dio httpClient;

  CashDataSource(this.httpClient);

  @override
  Future<BaseResponse> getCash() async {
    final response = await httpClient.get('user/cash');
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"], response.data["value"]);
    }
  }

  @override
  Future<BaseResponse> getUserWalletData() async {
    final response = await httpClient.get('user/wallet');
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"],
          WalletEntity.fromJson(response.data["wallet"]));
    }
  }

  @override
  Future<BaseResponse> convertCash(String moneyTypeId, String amount) async {
    final response = await httpClient.post('user/convert-score', data: {
      "money_type_id": moneyTypeId,
      "amount": amount,
    });
    validateResponse(response);

    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"], response.data["message"]);
    }
  }
}
