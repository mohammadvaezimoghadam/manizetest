import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/common/exception.dart';
import 'package:manize/data/address.dart';
import 'package:manize/data/repo/address_repo.dart';
import 'package:manize/data/repo/check_address_repo.dart';

part 'bottom_sheet_event.dart';
part 'bottom_sheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  final IAddressRepository addressRepository;
  final ICheckAddressRepository checkAddressRepository;
  BottomSheetBloc(this.addressRepository, this.checkAddressRepository)
      : super(BottomSheetLoading()) {
    on<BottomSheetEvent>((event, emit) async {
      if (event is BSheetStrted || event is BSheetRefreshClicked) {
        emit(BottomSheetLoading());
        try {
          final addressList = await addressRepository.getAllAddress();
          if (addressList.isNotEmpty) {
            emit(BottomSheetSuccess(addressList));
          } else {
            emit(BottomSheetEmptyState());
          }
        } catch (e) {
          emit(BottomSheetError(e is AppException ? e : AppException()));
        }
      } else if (event is BSheetCheckAddressClicked) {
        emit(BottomSheetLoading());
        try {
          final response =
              await checkAddressRepository.checkAddress(event.addressId);
          if (response.error == false) {
            emit(BottomSheetCheckAddressResponse(response.hasPackage));
          } else {
            emit(BottomSheetError(
                AppException(message: 'خطا در برقراری ارتباط')));
          }
        } catch (e) {
          emit(BottomSheetError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
