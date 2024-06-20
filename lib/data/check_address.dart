class CheckAddressEntity {
  final bool error;
  final bool hasPackage;

  CheckAddressEntity.fromJson(Map<String, dynamic> json)
      : error = json["error"],
        hasPackage = json["has_package"];
}
