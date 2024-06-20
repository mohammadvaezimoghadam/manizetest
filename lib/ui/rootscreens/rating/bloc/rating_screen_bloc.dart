import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/ui/rootscreens/rating/ratingcart/rating_cart.dart';

part 'rating_screen_event.dart';
part 'rating_screen_state.dart';

const onlyPackageId = 0;
const onlyCollectId = 1;
const packageAndCollect = 2;

class RatingScreenBloc extends Bloc<RatingScreenEvent, RatingScreenState> {
  late final List<int> packageChildrenInt;
  late final List<int> collectChilderenInt;
  late final List<RatingCart> newPackageChilderen;
  late final List<RatingCart> newCollectChilderen;
  late ThemeData theme;
  RatingScreenBloc() : super(RatingScreenLoading()) {
    on<RatingScreenEvent>((event, emit) async {
      if (event is RatingScreenStarted) {
        emit(RatingScreenLoading());
        packageChildrenInt = event.packageRequestIds;
        collectChilderenInt = event.collectRepuestIds;
        theme = event.theme;
        final packageChildren =
            await _getWidget(event.packageRequestIds, event.theme, true);
        final collectChilderen =
            await _getWidget(event.collectRepuestIds, event.theme, false);
        newPackageChilderen = await _getWidget(packageChildrenInt, theme, true);
        newCollectChilderen =
            await _getWidget(collectChilderenInt, theme, true);

        if (packageChildren.isNotEmpty && collectChilderen.isNotEmpty) {
          emit(RatingScreenSuccessForTow(packageChildren, collectChilderen));
        } else {
          if (packageChildren.isNotEmpty) {
            emit(RatingScreenSuccessForOne(packageChildren, true));
          } else {
            emit(RatingScreenSuccessForOne(collectChilderen, false));
          }
        }
      } else if (event is RatingScreenChangeOnList) {
        if (newCollectChilderen.length + newPackageChilderen.length == 1) {
          if (event.isAPackageRequest) {
            newPackageChilderen
                .removeWhere((element) => element.requestId == event.packageId);
          } else {
            newCollectChilderen
                .removeWhere((element) => element.requestId == event.packageId);
          }
          emit(RatingIsFineshed());
        } else {
          if (event.isAPackageRequest) {
            newPackageChilderen
                .removeWhere((element) => element.requestId == event.packageId);
          } else {
            newCollectChilderen
                .removeWhere((element) => element.requestId == event.packageId);
          }
        }
      }
    });
  }
}

Future<List<RatingCart>> _deletOnList(
    List<RatingCart> baseList, String ifRequestId) async {
  List<RatingCart> newRatingCart = baseList;
  baseList.removeWhere((element) => element.requestId == ifRequestId);
  return newRatingCart;
}

Future<List<RatingCart>> _getWidget(
    List<int> packageRequest, ThemeData theme, bool isAPackageRequest) async {
  List<RatingCart> children = [];
  packageRequest.forEach((element) {
    children.add(RatingCart(
      theme: theme,
      requestId: element.toString(),
      isAPackageRequest: isAPackageRequest,
    ));
  });
  return children;
}
