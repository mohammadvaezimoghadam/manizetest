class TopUserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String imagUrl;
  final String fullScore;

  TopUserEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        firstName = json["first_name"],
        lastName = json["last_name"],
        imagUrl = json["image"],
        fullScore = json["full_score"];
}
