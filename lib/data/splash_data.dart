class SplashData {
  final List<int> packageRequests;
  final List<int> collectRequests;

  SplashData.fromJson(Map<String, dynamic> json)
      : packageRequests =parseJsonArray(json["package_requests"]),
        collectRequests =parseJsonArray(json["collect_requests"]);

  static List<int> parseJsonArray(List<dynamic> jsonArray) {
    final List<int> idList = [];
    jsonArray.forEach((element) {
      idList.add(element);
    });
    return idList;
  }
}
