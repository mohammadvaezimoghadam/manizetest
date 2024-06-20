import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/common/exception.dart';
import 'package:manize/data/repo/auth_repo.dart';

part 'code_required_event.dart';
part 'code_required_state.dart';

class CodeRequiredBloc extends Bloc<CodeRequiredEvent, CodeRequiredState> {
  final IAuthReposetory reposetory;
  CodeRequiredBloc(this.reposetory) : super(CodeRequiredInitial()) {
    on<CodeRequiredEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is CodeBtnClicked) {
        emit(CodeRequiredLoading());
        if (event.isLoginMod) {
          try {
            final baseResponse =
                await reposetory.login(event.phone, event.code);
            if (baseResponse.error == true) {
              emit(CodeRequiredError(AppException(message: baseResponse.body)));
            } else {
              emit(CodeRequiredSuccess());
            }
          } catch (e) {
            emit(CodeRequiredError(
                AppException(message: "خطا در برقراری ارتباط")));
          }
        } else if (event.isLoginMod == false) {
          try {
            final baseResponse = await reposetory.singUp(event.firstName,
                event.phone, event.code, event.regent, event.lastName);
            if (baseResponse.error == true) {
              emit(CodeRequiredError(AppException(message: baseResponse.body)));
            } else {
              emit(CodeRequiredSuccess());
            }
          } catch (e) {
            emit(CodeRequiredError(e is AppException ? e : AppException()));
          }
        }
      } else if (event is RefreshCodeClicked) {
        emit(CodeRequiredLoading());
        try {
          final baseResponse = await reposetory.sendCode(event.phone);
          if (baseResponse.error == true) {
            emit(CodeRequiredError(AppException(message: baseResponse.body)));
          } else {
            emit(CodeRequiredError(
                AppException(message: 'کد با موفقیت ارساال شد')));
          }
        } catch (e) {
          emit(CodeRequiredError(
              AppException(message: "خطا در برقراری ارتباط")));
        }
      }
    });
  }
}
