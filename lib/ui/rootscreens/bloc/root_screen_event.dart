part of 'root_screen_bloc.dart';

abstract class RootScreenEvent extends Equatable {
  const RootScreenEvent();

  @override
  List<Object> get props => [];
}

class AddPackageEvent extends RootScreenEvent {
  final String requestDate;
  final String addressId;
  final String timesLotId;

  const AddPackageEvent(this.requestDate, this.addressId, this.timesLotId);
  @override
  // TODO: implement props
  List<Object> get props => [requestDate, addressId, timesLotId];
}

class CollectPackageEvent extends RootScreenEvent {
  final String requestDate;
  final String addressId;
  final String timesLotId;
  final String wasteId;

  const CollectPackageEvent(
      this.requestDate, this.addressId, this.timesLotId, this.wasteId);
  @override
  // TODO: implement props
  List<Object> get props => [requestDate, addressId, timesLotId, wasteId];
}
