class WasteEntity {
  final int id;
  final String title;
  final String value;
  final String description;

  WasteEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        value = json["value"],
        description = json["description"];

  WasteEntity.fromJsonHome(Map<String, dynamic> json)
      : title = json["waste"].toString(),
        value = json["amount"].toString(),
        id = 1,
        description = "";

  static List<WasteEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<WasteEntity> wasteList = [];
    jsonArray.forEach((element) {
      wasteList.add(WasteEntity.fromJson(element));
    });
    return wasteList;
  }
}
