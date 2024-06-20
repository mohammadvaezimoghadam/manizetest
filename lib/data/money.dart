
class MoneyEntity {
  final String title;
  final String amount;

  MoneyEntity.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        amount = json["amount"].toString();


 static List<MoneyEntity> getMoneyList(List<dynamic> json){
  final  List<MoneyEntity> moneyList=[];
    json.forEach((element) { 
      moneyList.add(MoneyEntity.fromJson(element));
    });
    return moneyList;

  }      
}
