part of 'code_required_bloc.dart';

abstract class CodeRequiredState extends Equatable {
  const CodeRequiredState();
  
  @override
  List<Object> get props => [];
}

class CodeRequiredInitial extends CodeRequiredState {}

class CodeRequiredLoading extends CodeRequiredState{}
class CodeRequiredSuccess extends CodeRequiredState{}
class CodeRequiredError extends CodeRequiredState{
  final AppException appException;

  CodeRequiredError(this.appException);
  @override
  // TODO: implement props
  List<Object> get props => [appException];
}
