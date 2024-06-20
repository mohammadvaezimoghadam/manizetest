import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/home_response.dart';
import 'package:manize/data/product_entity.dart';

abstract class IHomeDataSource {
  Future<HomeResponse> getHomeInfo();
  Future<void> deletAAddressById(int addressId);
  Future<void> addAddress(
      String title, String address, String lat, String long);
  Future<List<ProductEntity>> getProductList();
  
}

class HomeDataSource with HttpResponseValidator implements IHomeDataSource {
  final Dio httpClient;
  final Dio httpClientProduct;

  HomeDataSource(this.httpClient, this.httpClientProduct);
  @override
  Future<HomeResponse> getHomeInfo() async {
    final response = await httpClient.post('home');
    validateResponse(response);
    return HomeResponse.fromJson(response.data);
  }

  @override
  Future<void> deletAAddressById(int addressId) async {
    await httpClient.post('address/delete/$addressId');
  }

  @override
  Future<void> addAddress(
      String title, String address, String lat, String long) async {
    await httpClient.post('address', data: {
      "title": title,
      "address": address,
      "lat": lat,
      "long": long,
    });
  }

  @override
  Future<List<ProductEntity>> getProductList() async {
    final response = await httpClientProduct.get(
        'products?consumer_key=ck_55ca50ab7822c3e23241c9bc74f0eea8fdf673a7&consumer_secret=cs_2259a8b2d8f2e7630c4918c3896fe665d12830e4&page=1&per_page=10');
    validateResponse(response);
    List<ProductEntity> productList = [];
    (response.data as List).forEach((element) {
      productList.add(ProductEntity.fromJson(element));
    });
    return productList;
  }


}
