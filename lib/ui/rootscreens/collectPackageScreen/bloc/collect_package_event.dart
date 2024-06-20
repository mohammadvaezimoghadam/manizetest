part of 'collect_package_bloc.dart';

abstract class CollectPackageEvent extends Equatable {
  const CollectPackageEvent();

  @override
  List<Object> get props => [];
}

class CollectPackageStarted extends CollectPackageEvent {}
