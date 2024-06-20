import 'package:manize/common/http_client.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/source/package_request_data_source.dart';

final packageRequestRepository =
    PackageRequestRepository(PackageRequestDataSource(httpClient));

abstract class IPackageRequestRepository {
  Future<BaseResponse> packageRequest(
      String requestDate, String addressId, String timesLotid);
  Future<BaseResponse> collectRequest(
      String requestDate, String addressId, String timesLotid, String wasteId);
}

class PackageRequestRepository
    with HttpResponseValidator
    implements IPackageRequestRepository {
  final IPackageRequestDataSource packageRequestDataSource;

  PackageRequestRepository(this.packageRequestDataSource);

  @override
  Future<BaseResponse> packageRequest(
      String requestDate, String addressId, String timesLotid) async {
    return await packageRequestDataSource.packageRequest(
        requestDate, addressId, timesLotid);
  }

  @override
  Future<BaseResponse> collectRequest(String requestDate, String addressId,
      String timesLotid, String wasteId) async {
    return await packageRequestDataSource.collectRequest(
        requestDate, addressId, timesLotid, wasteId);
  }
}
