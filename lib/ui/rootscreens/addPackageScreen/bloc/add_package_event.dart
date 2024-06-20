part of 'add_package_bloc.dart';

abstract class AddPackageEvent extends Equatable {
  const AddPackageEvent();

  @override
  List<Object> get props => [];
}

class AddPackageStarted extends AddPackageEvent{
  
}
