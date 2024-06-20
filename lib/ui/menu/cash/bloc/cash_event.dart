part of 'cash_bloc.dart';

abstract class CashEvent extends Equatable {
  const CashEvent();

  @override
  List<Object> get props => [];
}

class CashStarted extends CashEvent{
  final ThemeData theme;
  final BuildContext parentContex;

  const CashStarted(this.theme, this.parentContex);
  @override
  // TODO: implement props
  List<Object> get props => [theme,parentContex];
}

class CashConvertScore extends CashEvent{
  final String amount;
  final String moneyTypeId;
  

  const CashConvertScore(this.amount, this.moneyTypeId);
  @override
  // TODO: implement props
  List<Object> get props => [amount,moneyTypeId];
}