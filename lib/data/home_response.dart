import 'package:manize/data/address.dart';
import 'package:manize/data/waste.dart';

class HomeResponse {
  final String score;
  final int rank;
  final List<AddressEntity> addressList;
  final List<WasteEntity> wasteList;

  HomeResponse.fromJson(Map<String, dynamic> json)
      : score = json["score"],
        rank = json["rank"],
        addressList = AddressEntity.parseJsonArray(json["address"]),
        wasteList = WasteEntity.parseJsonArray(json["history"]);
}
