part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  final List<AddressEntity> addressList;
  final List<ProductEntity> productList;

  const HomeLoading(this.addressList, this.productList);
  @override
  // TODO: implement props
  List<Object> get props => [addressList,productList];
}
class HomeSuccess extends HomeState{
  final HomeResponse homeResponse;
  final List<ProductEntity> productList;
  final List<ArticleEntity> articelList;
  

  const HomeSuccess(this.homeResponse, this.productList, this.articelList);
  @override
  // TODO: implement props
  List<Object> get props => [homeResponse,productList,articelList];
}
class HomeError extends HomeState{}

class HomeSkeletonLoading extends HomeState{}