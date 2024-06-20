part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginBtnIsClicked extends LoginEvent{
  final String phone;

  const LoginBtnIsClicked(this.phone);
  @override
  // TODO: implement props
  List<Object> get props => [phone];
}
