class AddressEntity {
  final int id;
  final String title;
  final String lat;
  final String long;
  final String state;
  final String city;
  final String address;
  AddressEntity(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        lat = json['lat'],
        long = json['long'],
        address = json['address'],
        state = "",
        city = "";
  AddressEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        lat = json['lat'],
        long = json['long'],
        state = json['state'],
        city = json['city'],
        address = json['address'];

  static List<AddressEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<AddressEntity> addressList = [];
    jsonArray.forEach((element) {
      addressList.add(AddressEntity.fromJson(element));
    });
    return addressList;
  }
}
