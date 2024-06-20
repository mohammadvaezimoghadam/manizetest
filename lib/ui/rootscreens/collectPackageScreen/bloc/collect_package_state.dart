part of 'collect_package_bloc.dart';

abstract class CollectPackageState extends Equatable {
  const CollectPackageState();
  
  @override
  List<Object> get props => [];
}


class CollectPackageSuccess extends CollectPackageState {
  final List<WasteEntity> wasteList;
  final List<WorkTimesEntity> timesList;

  const CollectPackageSuccess(this.wasteList, this.timesList);
  @override
  // TODO: implement props
  List<Object> get props => [wasteList,timesList];
}
class CollectPackageError extends CollectPackageState {}
class CollectSkletonLoading extends CollectPackageState{}