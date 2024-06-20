part of 'sing_up_bloc.dart';

abstract class SingUpEvent extends Equatable {
  const SingUpEvent();

  @override
  List<Object> get props => [];
}


class SingUpBtnClicked extends SingUpEvent{
  final String phone;
 

  const SingUpBtnClicked( this.phone);
  @override
  // TODO: implement props
  List<Object> get props => [phone];
}