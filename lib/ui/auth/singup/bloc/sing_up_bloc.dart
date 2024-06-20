import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/common/exception.dart';
import 'package:manize/data/repo/auth_repo.dart';

part 'sing_up_event.dart';
part 'sing_up_state.dart';

class SingUpBloc extends Bloc<SingUpEvent, SingUpState> {
  final IAuthReposetory reposetory;
  SingUpBloc(this.reposetory) : super(SingUpInitial()) {
    on<SingUpEvent>((event, emit) async {
      if (event is SingUpBtnClicked) {
        emit(SingUpLoading());
        if (event.phone.length != 11 || event.phone.isEmpty) {
          emit(SingUpError(AppException(message: "اطلاعات وارد شده صحیح نمی باشد")));
        } else {
          try {
            final baseResponse = await reposetory.sendCode(event.phone);
            if (baseResponse.error == true) {
              emit(SingUpError(AppException(message: baseResponse.body)));
            } else {
              emit(SingUpSuccess(baseResponse.body));
            }
          } catch (e) {
            emit(SingUpError(e is AppException ? e : AppException()));
          }
        }
      }
    });
  }
}
