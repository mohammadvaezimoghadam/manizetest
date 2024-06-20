import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:manize/common/exception.dart';
import 'package:manize/data/repo/home_repo.dart';
import 'package:manize/ui/home/bloc/home_bloc.dart';

part 'map_screen_event.dart';
part 'map_screen_state.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  final Homerepository homerepository;
  LocationData? userLocation;
  MapScreenBloc(this.homerepository) : super(MapScreenInitial()) {
    on<MapScreenEvent>((event, emit) async {
      if (event is MapStarted || event is MapUserLocationTap) {
        try {
          userLocation = await getUserLocation();
          emit(MapGetUserLocation(
              userLocation!.latitude!, userLocation!.longitude!));
        } catch (e) {
          emit(MapScreenError(AppException()));
        }
      } else if (event is MapAddAddress) {
        emit(MapScreenLoading());
        try {
          await homerepository.addAddress(
              event.title, event.address, event.lat, event.long);
          event.context.read<HomeBloc>().add(HomeStarted());
          emit(MapScreenSuccess('آدرس با موفقیت ثبت شد'));
        } catch (e) {
          emit(MapScreenError(AppException()));
        }
      }
    });
  }

  Future<LocationData> getUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {}
    }
    return await location.getLocation();
  }
}
