import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/data/repo/work_times_repository.dart';
import 'package:manize/data/work_times.dart';

part 'add_package_event.dart';
part 'add_package_state.dart';

class AddPackageBloc extends Bloc<AddPackageEvent, AddPackageState> {
  final IWorkTimesRepository workTimesRepository;
  AddPackageBloc(this.workTimesRepository) : super(AddPackageLoading()) {
    on<AddPackageEvent>((event, emit) async {
      if (event is AddPackageStarted) {
        emit(AddPackageSkletonLoading());
         await Future.delayed(Duration(milliseconds: 500));
        try {
          final workTimes = await workTimesRepository.getWorkTimes();
          emit(AddPackageSuccess(workTimes));
          //emit(AddPackageSkletonLoading());
        } catch (e) {
          emit(AddPackageError());
        }
      }
    });
  }
}
