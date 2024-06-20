import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/check_address.dart';

abstract class ICheckAddressDataSource{
  Future<CheckAddressEntity> checkAddress(int addressId);
}

class CheckAddressDataSource with HttpResponseValidator implements ICheckAddressDataSource{
 final Dio httpClient;

  CheckAddressDataSource(this.httpClient);
  @override
  Future<CheckAddressEntity> checkAddress(int addressId) async{
    final response=await httpClient.post('address/check',data: {
      "address_id":addressId
    });
    validateResponse(response);
    return CheckAddressEntity.fromJson(response.data);
  }

}