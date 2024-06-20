part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent{}

class HomeDeletAddressClicked extends HomeEvent{
  final int addressId;

  const HomeDeletAddressClicked(this.addressId);
  @override
  // TODO: implement props
  List<Object> get props => [addressId];
}

