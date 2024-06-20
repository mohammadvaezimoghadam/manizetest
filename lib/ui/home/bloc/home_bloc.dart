import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manize/data/address.dart';
import 'package:manize/data/article_entity.dart';
import 'package:manize/data/home_response.dart';
import 'package:manize/data/product_entity.dart';
import 'package:manize/data/repo/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository homerepository;
  late List<ProductEntity> productList = [];
  late HomeResponse homeResponse;
  late List<ArticleEntity> articelList;

  HomeBloc(this.homerepository) : super(HomeSkeletonLoading()) {
    on<HomeEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is HomeStarted) {
        emit(HomeSkeletonLoading());
        try {
          homeResponse = await homerepository.getHomeInfo();
          productList = productList.isNotEmpty
              ? productList
              : await homerepository.getProductList();
          articelList = await homerepository.getArticleList();

          ///final addressList= await addressRepository.getAllAddress();
          emit(HomeSuccess(homeResponse, productList, articelList));
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is HomeDeletAddressClicked) {
        emit(HomeLoading(homeResponse.addressList, productList));
        await Future.delayed(Duration(milliseconds: 1000));
        try {
          await homerepository.deletAAddressById(event.addressId);
          final resppnse = await homerepository.getHomeInfo();
          //final addressList= await addressRepository.getAllAddress();
          homeResponse.addressList.removeWhere(
            (element) {
              return element.id == event.addressId;
            },
          );
          emit(HomeSuccess(resppnse, productList, articelList));
        } catch (e) {
          emit(HomeError());
        }
      }
    });
  }
}
