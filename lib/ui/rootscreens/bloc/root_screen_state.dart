part of 'root_screen_bloc.dart';

abstract class RootScreenState extends Equatable {
  const RootScreenState();

  @override
  List<Object> get props => [];
}

class RootScreenInitial extends RootScreenState {}

class RootScreenSuccess extends RootScreenState {
  final PackageInfoEntity packageInfo;

  const RootScreenSuccess(this.packageInfo);
  @override
  // TODO: implement props
  List<Object> get props => [packageInfo];
}

class RootScreenError extends RootScreenState {
  final String errorMessage;

  const RootScreenError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object> get props => [errorMessage];
}

class RootScreenLoading extends RootScreenState{}