import 'package:manize/data/last_trans.dart';
import 'package:manize/data/money.dart';
import 'package:manize/data/money_types.dart';

class WalletEntity {
  final String score;
  final List<MoneyEntity> money;
  final List<LastTransEntity> lastTrans;
  final List<MoneyTypesEntity> types;

  WalletEntity.fromJson(Map<String, dynamic> json)
      : score = json["score"],
        money = MoneyEntity.getMoneyList(json['money']),
        lastTrans = LastTransEntity.getLastTransList(json['last_trans']),
        types = MoneyTypesEntity.getMoneyTypesList(json['types']);
}
