import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/address.dart';

abstract class IAddressDataSource {
  Future<List<AddressEntity>> getAllAddress();
}

class AddressDataSource
    with HttpResponseValidator
    implements IAddressDataSource {
  final Dio httpClient;

  AddressDataSource(this.httpClient);
  @override
  Future<List<AddressEntity>> getAllAddress() async {
    final response = await httpClient.post('address/get-all');
    await validateResponse(response);
    final List<AddressEntity> addresss = [];
    (response.data["data"] as List).forEach((element) {
      addresss.add(AddressEntity(element));
    });
    return addresss;
  }
}
