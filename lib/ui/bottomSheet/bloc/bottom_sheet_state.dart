part of 'bottom_sheet_bloc.dart';

abstract class BottomSheetState extends Equatable {
  const BottomSheetState();

  @override
  List<Object> get props => [];
}

class BottomSheetLoading extends BottomSheetState {}

class BottomSheetError extends BottomSheetState {
  final AppException appException;

  const BottomSheetError(this.appException);
  @override
  // TODO: implement props
  List<Object> get props => [appException];
}

class BottomSheetSuccess extends BottomSheetState {
  final List<AddressEntity> addressList;

  const BottomSheetSuccess(this.addressList);
  @override
  // TODO: implement props
  List<Object> get props => [addressList];
}

class BottomSheetEmptyState extends BottomSheetState{

}

class BottomSheetCheckAddressResponse extends BottomSheetState{
  final bool hasPackage;

  const BottomSheetCheckAddressResponse(this.hasPackage);
  @override
  // TODO: implement props
  List<Object> get props => [hasPackage];
}
