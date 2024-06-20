part of 'map_screen_bloc.dart';

abstract class MapScreenEvent extends Equatable {
  const MapScreenEvent();

  @override
  List<Object> get props => [];
}

class MapStarted extends MapScreenEvent {}

class MapAddAddress extends MapScreenEvent {
  final String title;
  final String address;
  final String lat;
  final String long;
  final BuildContext context;

  const MapAddAddress(this.title, this.address, this.lat, this.long, this.context);

  @override
  // TODO: implement props
  List<Object> get props => [title, address, lat, long,context];
}

class MapUserLocationTap extends MapScreenEvent {}


