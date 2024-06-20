import 'package:dio/dio.dart';
import 'package:manize/common/http_client.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/article_entity.dart';

abstract class IArticleDataSource {
  Future<List<ArticleEntity>> getHomeArticleList(int per_page, int page);
  Future<List<ArticleEntity>> getArticleList(int page);
}

class ArticleDataSource
    with HttpResponseValidator
    implements IArticleDataSource {
  @override
  Future<List<ArticleEntity>> getHomeArticleList(int per_page, int page) async {
    final response = await httpClientArtiles.get(
        'https://manize.ir/wp-json/wp/v2/posts?per_page=$per_page&page=$page');
    validateResponse(response);
    List<ArticleEntity> articelList = [];
    (response.data as List).forEach((element) {
      articelList.add(ArticleEntity.fromJson(element));
    });
    return articelList;
  }

  @override
  Future<List<ArticleEntity>> getArticleList(int page) async {
    final response = await httpClientArtiles
        .get('https://manize.ir/wp-json/wp/v2/posts?per_page=10&page=$page');
    // validateResponse(response);
    List<ArticleEntity> articelList = [];
    if (response.statusCode == 400) {
      return articelList;
    } else if (response.statusCode == 200) {
      (response.data as List).forEach((element) {
        articelList.add(ArticleEntity.fromJson(element));
      });
    }
    return articelList;
  }
}
