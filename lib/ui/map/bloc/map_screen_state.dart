part of 'map_screen_bloc.dart';

abstract class MapScreenState  {
  const MapScreenState();

  

}

class MapScreenInitial extends MapScreenState {}
class MapScreenLoading extends MapScreenState{}
class MapScreenSuccess extends MapScreenState {
  final String messege;

  const MapScreenSuccess(this.messege);

}

class MapScreenError extends MapScreenState {
  final AppException appException;

  const MapScreenError(this.appException);


}

class MapGetUserLocation extends MapScreenState{
  final double lat;
  final double long;

  const MapGetUserLocation(this.lat, this.long);
  
  
}
