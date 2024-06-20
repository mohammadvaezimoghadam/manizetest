part of 'cash_bloc.dart';

abstract class CashState extends Equatable {
  const CashState();

  @override
  List<Object> get props => [];
}

class CashLoading extends CashState {}

class CashError extends CashState {
  final String messeg;

  const CashError(this.messeg);
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CashSuccess extends CashState {
  // final List<Widget> cartchildren;
  final List<MoneyEntity> moneyList;
  final List<MoneyTypesEntity> typesList;
  final List<Widget> lastTransChildren;
  final String fullScore;
  final String messege;

  const CashSuccess(this.fullScore, this.lastTransChildren, this.messege,
      this.moneyList, this.typesList);
  @override
  // TODO: implement props
  List<Object> get props =>
      [fullScore, lastTransChildren, messege, moneyList, typesList];
}

class CashDialogError extends CashState {
  final String messeg;

  const CashDialogError(this.messeg);
  @override
  // TODO: implement props
  List<Object> get props => [messeg];
}

class CashDialogLoading extends CashState {
  final List<MoneyEntity> moneyList;
  final List<MoneyTypesEntity> typesList;
  final List<Widget> lastTransChildren;
  final String fullScore;
  final String messege;
  final bool isLoading;

  const CashDialogLoading(this.fullScore, this.lastTransChildren, this.messege,
      this.moneyList, this.typesList, this.isLoading);
  @override
  // TODO: implement props
  List<Object> get props =>
      [fullScore, lastTransChildren, messege, moneyList, typesList, isLoading];
}
