part of 'top_users_bloc.dart';

abstract class TopUsersEvent extends Equatable {
  const TopUsersEvent();

  @override
  List<Object> get props => [];
}

class TopUsersStarted extends TopUsersEvent{}
