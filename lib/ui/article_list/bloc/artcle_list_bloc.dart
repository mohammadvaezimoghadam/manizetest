

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/data/article_entity.dart';
import 'package:manize/data/source/article_data_source.dart';

part 'artcle_list_event.dart';
part 'artcle_list_state.dart';

class ArtcleListBloc extends Bloc<ArtcleListEvent, ArtcleListState> {
  final IArticleDataSource dataSource;
  List<ArticleEntity> articelList = [];
  int currentPage = 1;
  bool isLoading = false;
  ArtcleListBloc(this.dataSource) : super(ArtcleListLoading(false)) {
    on<ArtcleListEvent>((event, emit) async {
      if (event is ArticleListStarted || event is ArticleListLoadArticels) {
        if (event is ArticleListStarted) {
          emit(ArtcleListLoading(false));
          try {
            List<ArticleEntity> response =
                await dataSource.getArticleList(currentPage);
            articelList.addAll(response);

            currentPage++;

            emit(ArtcleListSuccess(false, articelList: articelList,""));
          } catch (e) {
            emit(ArtcleListSuccess(
                isLoading,articelList:  articelList, "مقاله ای موجود نیست!"));
          }
        } else if (event is ArticleListLoadArticels) {
          emit(ArticleCheckState(true, articelList));
          try {
            List<ArticleEntity> response =
                await dataSource.getArticleList(currentPage);
            articelList.addAll(response);

            currentPage++;

            emit(ArtcleListSuccess(false, articelList: articelList,""));
          } catch (e) {
            emit(ArtcleListSuccess(
                isLoading,articelList:  articelList, "مقاله ای موجود نیست!"));
          }
        }
      }
    });
  }
}
