import 'package:manize/common/http_client.dart';
import 'package:manize/data/check_address.dart';

import '../source/check_address_data_source.dart';

final checkAddressRepository =
    CheckAddressRepositori(CheckAddressDataSource(httpClient));

abstract class ICheckAddressRepository {
  Future<CheckAddressEntity> checkAddress(int addressId);
}

class CheckAddressRepositori implements ICheckAddressRepository {
  final ICheckAddressDataSource checkAddressDataSource;

  CheckAddressRepositori(this.checkAddressDataSource);
  @override
  Future<CheckAddressEntity> checkAddress(int addressId) async {
    return await checkAddressDataSource.checkAddress(addressId);
  }
}
