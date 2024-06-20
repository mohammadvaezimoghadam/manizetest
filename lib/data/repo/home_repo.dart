import 'package:manize/common/http_client.dart';
import 'package:manize/data/article_entity.dart';
import 'package:manize/data/home_response.dart';
import 'package:manize/data/source/article_data_source.dart';
import 'package:manize/data/source/home_data_source.dart';

import '../product_entity.dart';

final homerepository =
    Homerepository(HomeDataSource(httpClient, httpClientProduct),ArticleDataSource());

abstract class IHomeRepository {
  Future<HomeResponse> getHomeInfo();
  Future<void> deletAAddressById(int addressId);
  Future<void> addAddress(
      String title, String address, String lat, String long);
  Future<List<ProductEntity>> getProductList();
  Future<List<ArticleEntity>> getArticleList();
}

class Homerepository implements IHomeRepository {
  final IHomeDataSource dataSource;
  final IArticleDataSource articleDataSource;

  Homerepository(this.dataSource, this.articleDataSource);
  @override
  Future<HomeResponse> getHomeInfo() async {
    return await dataSource.getHomeInfo();
  }

  @override
  Future<void> deletAAddressById(int addressId) async {
    await dataSource.deletAAddressById(addressId);
  }

  @override
  Future<void> addAddress(
      String title, String address, String lat, String long) async {
    await dataSource.addAddress(title, address, lat, long);
  }

  @override
  Future<List<ProductEntity>> getProductList() {
    return dataSource.getProductList();
  }

  @override
  Future<List<ArticleEntity>> getArticleList() async {
    return articleDataSource.getHomeArticleList(5,1);
  }
}
