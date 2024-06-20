part of 'artcle_list_bloc.dart';

sealed class ArtcleListState extends Equatable {
  const ArtcleListState(this.isLoading);
  final bool isLoading;

  @override
  List<Object> get props => [isLoading];
}

final class ArtcleListInitial extends ArtcleListState {
  ArtcleListInitial(super.isLoading);
}

final class ArtcleListError extends ArtcleListState {
  final List<ArticleEntity> articelList;
  final String messege;
  ArtcleListError(super.isLoading, this.articelList, this.messege);
  @override
  // TODO: implement props
  List<Object> get props => [articelList];
}

final class ArtcleListLoading extends ArtcleListState {
  ArtcleListLoading(super.isLoading);
}

final class ArtcleListSuccess extends ArtcleListState {
  final List<ArticleEntity> articelList;
  final bool isLoding;
  final String messege;

  const ArtcleListSuccess(this.isLoding, this.messege, {required this.articelList})
      : super(false);
  @override
  List<Object> get props => [articelList, isLoding,messege];
}

final class ArticleCheckState extends ArtcleListState {
  final List<ArticleEntity> articelList;
  ArticleCheckState(super.isLoading, this.articelList);
  @override
  // TODO: implement props
  List<Object> get props => [articelList];
}


