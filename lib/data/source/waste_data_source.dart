import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/waste.dart';
  


abstract class IWasteDataSource {
  Future<List<WasteEntity>> getAllWaste();
}

class WasteDataSource with HttpResponseValidator implements IWasteDataSource {
  final Dio httpClient;

  WasteDataSource(this.httpClient);

  @override
  Future<List<WasteEntity>> getAllWaste() async {
    final response = await httpClient.get('wastes');
    validateResponse(response);
    final List<WasteEntity> wasteList = [];
    (response.data["data"] as List).forEach((element) {
      wasteList.add(WasteEntity.fromJson(element));
    });
    return wasteList;
  }
}
