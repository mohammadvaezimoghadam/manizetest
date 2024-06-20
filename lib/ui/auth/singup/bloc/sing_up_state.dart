part of 'sing_up_bloc.dart';

abstract class SingUpState extends Equatable {
  const SingUpState();

  @override
  List<Object> get props => [];
}

class SingUpInitial extends SingUpState {}

class SingUpLoading extends SingUpState {}

class SingUpSuccess extends SingUpState {
  final String message;

  const SingUpSuccess(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class SingUpError extends SingUpState {
  final AppException appException;

  const SingUpError(this.appException);
  @override
  // TODO: implement props
  List<Object> get props => [appException];
}
