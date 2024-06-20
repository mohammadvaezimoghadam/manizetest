import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/data/repo/waste_repo.dart';
import 'package:manize/data/repo/work_times_repository.dart';
import 'package:manize/data/waste.dart';
import 'package:manize/data/work_times.dart';

part 'collect_package_event.dart';
part 'collect_package_state.dart';

class CollectPackageBloc
    extends Bloc<CollectPackageEvent, CollectPackageState> {
  final IWorkTimesRepository workTimesRepository;
  final IWasteRepository wasteRepository;
  CollectPackageBloc(this.workTimesRepository, this.wasteRepository)
      : super(CollectSkletonLoading()) {
    on<CollectPackageEvent>((event, emit) async {
      if (event is CollectPackageStarted) {
        emit(CollectSkletonLoading());
        await Future.delayed(Duration(seconds: 1));
        try {
          final wasteList = await wasteRepository.getAllWaste();
          final timesList = await workTimesRepository.getWorkTimes();
          emit(CollectPackageSuccess(wasteList, timesList));
        } catch (e) {
          emit(CollectPackageError());
        }
      }
    });
  }
}
