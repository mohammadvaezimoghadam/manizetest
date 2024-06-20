import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/exception.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLLoading()) {
    on<ProfileEvent>((event, emit) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (event is ProfileStarted) {
        emit(ProfileLLoading());
        try {
          final String firstName =
              await sharedPreferences.getString("first_name") ?? "";
          final String lastName =
              await sharedPreferences.getString("last_name") ?? "";
          final String phone = await sharedPreferences.getString("phone") ?? "";
          emit(ProfileSuccess(firstName, lastName, phone));
        } catch (e) {
          emit(ProfileEError(AppException()));
        }
      }
    });
  }
}
