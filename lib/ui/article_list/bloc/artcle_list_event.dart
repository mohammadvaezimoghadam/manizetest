part of 'artcle_list_bloc.dart';

sealed class ArtcleListEvent extends Equatable {
  const ArtcleListEvent();

  @override
  List<Object> get props => [];
}

final class ArticleListStarted extends ArtcleListEvent {}

final class ArticleListLoadArticels extends ArtcleListEvent {

}
