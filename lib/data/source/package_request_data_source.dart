import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/package_info.dart';

abstract class IPackageRequestDataSource {
  Future<BaseResponse> packageRequest(
      String requestDate, String addressId, String timesLotid);
  Future<BaseResponse> collectRequest(
      String requestDate, String addressId, String timesLotid, String wasteId);
}

class PackageRequestDataSource
    with HttpResponseValidator
    implements IPackageRequestDataSource {
  final Dio httpClient;

  PackageRequestDataSource(this.httpClient);

  @override
  Future<BaseResponse> packageRequest(
      String requestDate, String addressId, String timesLotid) async {
    final response = await httpClient.post("package-request", data: {
      "requested_date": requestDate,
      "address_id": addressId,
      "timeslot_id": timesLotid
    });
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"],
          PackageInfoEntity.fromJson(response.data['data']));
    }
    // return PackageInfoEntity.fromJson(response.data['data']);
  }

  @override
  Future<BaseResponse> collectRequest(String requestDate, String addressId,
      String timesLotid, String wasteId) async {
    final response = await httpClient.post('collect-request', data: {
      "requested_date": requestDate,
      "address_id": addressId,
      "timeslot_id": timesLotid,
      "wastes_id":wasteId
    });
    validateResponse(response);
    if (response.data["error"] == true) {
      return BaseResponse(response.data["error"], response.data["message"]);
    } else {
      return BaseResponse(response.data["error"],
          PackageInfoEntity.fromJson(response.data['request']));
    }
  }
}
