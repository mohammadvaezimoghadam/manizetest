part of 'bottom_sheet_bloc.dart';

abstract class BottomSheetEvent extends Equatable {
  const BottomSheetEvent();

  @override
  List<Object> get props => [];
}

class BSheetStrted extends BottomSheetEvent {}

class BSheetRefreshClicked extends BottomSheetEvent {}

class BSheetCheckAddressClicked extends BottomSheetEvent {
  final int addressId;

  const BSheetCheckAddressClicked(this.addressId);
  @override
  // TODO: implement props
  List<Object> get props => [addressId];
}
