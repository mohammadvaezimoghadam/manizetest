part of 'code_required_bloc.dart';

abstract class CodeRequiredEvent extends Equatable {
  const CodeRequiredEvent();

  @override
  List<Object> get props => [];
}

class CodeBtnClicked extends CodeRequiredEvent {
  final String phone;
  final String code;
  final String firstName;
  final String lastName;
  final String regent;
  final bool isLoginMod;

  CodeBtnClicked(this.phone, this.code, this.isLoginMod,
      this.firstName, this.regent, this.lastName);
  @override
  // TODO: implement props
  List<Object> get props => [phone, code, isLoginMod, firstName, regent,lastName];
}

class RefreshCodeClicked extends CodeRequiredEvent{
  final String phone;

  const RefreshCodeClicked(this.phone);
  @override
  // TODO: implement props
  List<Object> get props => [phone];
}
