import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


part 'about_screen_event.dart';
part 'about_screen_state.dart';

class AboutScreenBloc extends Bloc<AboutScreenEvent, AboutScreenState> {
  final Dio httpClient;
  AboutScreenBloc(this.httpClient) : super(AboutScreenInitial()) {
    on<AboutScreenEvent>((event, emit) async {
      if (event is AboutScreenStarted) {
        emit(AboutScreenLoading());
        try {
          final response = await httpClient.get('about');
          if(response.data["error"] == false){
            emit(AboutScreenSuccess(response.data["about"]));
          }else{
            emit(AboutScreenError());
          }

        } catch (e) {
          emit(AboutScreenError());
        }
      }
    });
  }
}
