import 'package:manize/common/http_client.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/source/cash_data_source.dart';

final cashRepository = CashRepository(CashDataSource(httpClient));

abstract class ICashRepository {
  Future<BaseResponse> getCash();
  Future<BaseResponse> getUserWallet();
  Future<BaseResponse> convertCash(String moneyTypeId, String amount);
}

class CashRepository implements ICashRepository {
  final ICashDataSource cashDataSource;

  CashRepository(this.cashDataSource);

  @override
  Future<BaseResponse> getCash() async {
    return await cashDataSource.getCash();
  }

  @override
  Future<BaseResponse> getUserWallet() async {
    return await cashDataSource.getUserWalletData();
  }

  @override
  Future<BaseResponse> convertCash(String moneyTypeId, String amount) async {
    return await cashDataSource.convertCash(moneyTypeId, amount);
  }
}
