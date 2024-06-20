import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/data/repo/top_users_repo.dart';
import 'package:manize/data/top_user_entity.dart';
import 'package:manize/ui/menu/topUsers/topUsers.dart';

part 'top_users_event.dart';
part 'top_users_state.dart';

class TopUsersBloc extends Bloc<TopUsersEvent, TopUsersState> {
  final ITopUserRepository topUserRepository;
  TopUsersBloc(this.topUserRepository) : super(TopUsersLoading()) {
    on<TopUsersEvent>((event, emit) async {
      if (event is TopUsersStarted) {
        emit(TopUsersLoading());
        try {
          final baseResponse = await topUserRepository.getTopUsers();

          if (baseResponse.error == true) {
            emit(TopUsersError());
          } else {
            final itesList = await _getItemList(baseResponse.body);
            emit(TopUsersSuccess(itesList));
          }
        } catch (e) {
          emit(TopUsersError());
        }
      }
    });
  }
}

Future<List<TopUsersItem>> _getItemList(List<TopUserEntity> dataList) async {
  List<TopUsersItem> itemsList = [];
  dataList.forEach((topUserEntity) {
    itemsList.add(TopUsersItem(
        userName: topUserEntity.firstName +" "+ topUserEntity.lastName,
        fullScore: topUserEntity.fullScore));
  });
  return itemsList;
}
