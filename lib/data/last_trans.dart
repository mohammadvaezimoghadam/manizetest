class LastTransEntity {
  final int id;
  final String type;
  final String amount;
  final String date;

  LastTransEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        type = json["type"],
        amount = json["amount"],
        date = json["date"];

  static List<LastTransEntity> getLastTransList(List<dynamic> json) {
    final List<LastTransEntity> lastTransList = [];
    json.forEach((element) {
      lastTransList.add(LastTransEntity.fromJson(element));
    });
    return lastTransList;
  }
}
