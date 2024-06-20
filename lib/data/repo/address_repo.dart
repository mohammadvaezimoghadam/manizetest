import 'package:manize/common/http_client.dart';
import 'package:manize/data/address.dart';

import '../source/address_data_source.dart';

final addressRepository = AddressRepository(AddressDataSource(httpClient));

abstract class IAddressRepository {
  Future<List<AddressEntity>> getAllAddress();
}

class AddressRepository implements IAddressRepository {
  final IAddressDataSource dataSource;

  AddressRepository(this.dataSource);
  @override
  Future<List<AddressEntity>> getAllAddress() async {
    final addresss = await dataSource.getAllAddress();
    return addresss;
  }
}
