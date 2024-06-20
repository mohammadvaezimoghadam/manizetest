class AuthInfoEntity {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String accessToken;
  final String refreshToken;

  AuthInfoEntity(this.accessToken, this.refreshToken)
      : id = null,
        firstName = null,
        lastName = null,
        phone = null;

  AuthInfoEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        firstName = json["first_name"],
        lastName = json["last_name"],
        phone = json["phone"],
        accessToken = json["token"],
        refreshToken = json["token"];
}
