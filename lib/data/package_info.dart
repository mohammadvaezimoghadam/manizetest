class PackageInfoEntity {
  final int id;
  final String trackingCode;

  PackageInfoEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        trackingCode = json["tracking_code"];
}