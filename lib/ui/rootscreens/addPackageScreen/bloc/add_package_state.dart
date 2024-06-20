part of 'add_package_bloc.dart';

abstract class AddPackageState extends Equatable {
  const AddPackageState();
  
  @override
  List<Object> get props => [];
}

class AddPackageLoading extends AddPackageState {}
class AddPackageSuccess extends AddPackageState {
  final List<WorkTimesEntity> workTimes;

  const AddPackageSuccess(this.workTimes);
  @override
  // TODO: implement props
  List<Object> get props => [workTimes];
}
class AddPackageError extends AddPackageState {}
class AddPackageSkletonLoading extends AddPackageState{}
