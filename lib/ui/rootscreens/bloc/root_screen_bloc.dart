import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/data/package_info.dart';
import 'package:manize/data/repo/package_request_repo.dart';

part 'root_screen_event.dart';
part 'root_screen_state.dart';

class RootScreenBloc extends Bloc<RootScreenEvent, RootScreenState> {
  final IPackageRequestRepository packageRequestRepository;
  RootScreenBloc(this.packageRequestRepository) : super(RootScreenInitial()) {
    on<RootScreenEvent>((event, emit) async {
      if (event is AddPackageEvent) {
        emit(RootScreenLoading());
        try {
          final response = await packageRequestRepository.packageRequest(
              event.requestDate, event.addressId, event.timesLotId);
          if (response.error == true) {
            emit(RootScreenError(response.body));
          } else {
            emit(RootScreenSuccess(response.body));
          }
        } catch (e) {
          emit(RootScreenError("خطا در برقراری ارتباط"));
        }
      } else if (event is CollectPackageEvent) {
        emit(RootScreenLoading());
        try {
          final response = await packageRequestRepository.collectRequest(
              event.requestDate,
              event.addressId,
              event.timesLotId,
              event.wasteId);
          if (response.error == true) {
            emit(RootScreenError(response.body));
          } else {
            emit(RootScreenSuccess(response.body));
          }
        } catch (e) {
          emit(RootScreenError("خطا در برقراری ارتباط"));
        }
      }
    });
  }
}
