class MoneyTypesEntity {
  final int id;
  final String title;
  final String moneyBase;
  final String question;

  MoneyTypesEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        moneyBase = json["base"],
        question = json["question"];

  static List<MoneyTypesEntity> getMoneyTypesList(List<dynamic> json) {
    final List<MoneyTypesEntity> moneyTypesList = [];
    json.forEach((element) {
      moneyTypesList.add(MoneyTypesEntity.fromJson(element));
    });
    return moneyTypesList;
  }
}
