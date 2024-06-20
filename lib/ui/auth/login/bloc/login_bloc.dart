import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/common/exception.dart';
import 'package:manize/data/repo/auth_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthReposetory reposetory;
  LoginBloc(this.reposetory) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginBtnIsClicked) {
        emit(LoginLoading());
        if(event.phone.length != 11 || event.phone.isEmpty){
          emit(LoginError(AppException(message:'فرمت شماره تلفن اشتباه است')));

        }else{
          try {
            final baseResponse = await reposetory.sendCode(event.phone);
            if (baseResponse.error == true) {
              emit(LoginError(AppException(message: baseResponse.body)));
            } else {
              emit(LoginSuccess(baseResponse.body));
            }
          } catch (e) {
            emit(LoginError(AppException(message: "خطا در برقراری ارتباط")));
          }
        }
      }
    });
  }
}
