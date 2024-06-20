part of 'top_users_bloc.dart';

abstract class TopUsersState extends Equatable {
  const TopUsersState();
  
  @override
  List<Object> get props => [];
}

class TopUsersLoading extends TopUsersState {}
class TopUsersError extends TopUsersState {}
class TopUsersSuccess extends TopUsersState {
  final List<TopUsersItem> itemsList;

  const TopUsersSuccess(this.itemsList);
  @override
  // TODO: implement props
  List<Object> get props => [itemsList];
}
