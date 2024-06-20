import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/data/repo/package_request_evalution_repo.dart';
import 'package:manize/ui/rootscreens/rating/bloc/rating_screen_bloc.dart';

part 'rating_cart_item_event.dart';
part 'rating_cart_item_state.dart';

class RatingCartItemBloc
    extends Bloc<RatingCartItemEvent, RatingCartItemState> {
  final IPackageEvaluationRepository packageEvaluationRepository;
  RatingCartItemBloc(this.packageEvaluationRepository)
      : super(RatingCartItemInitial()) {
    on<RatingCartItemEvent>((event, emit) async {
      if (event is RatingCartSabtClicked) {
        emit(RatingCartLoading());
        await Future.delayed(Duration(milliseconds: 2000));
        try {
          final response = event.isAPackageRequest
              ? await packageEvaluationRepository.packageEvaluation(
                  event.requestId, event.score, event.note)
              : await packageEvaluationRepository.collectEvaluation(
                  event.requestId, event.score, event.note);
          if (response.error == true) {
            emit(RatingCartError('لطفا دوباره تلاش کنید'));
          } else {
            emit(RatingCartSuccess(
                response.message, int.parse(event.requestId)));
            event.context.read<RatingScreenBloc>().add(RatingScreenChangeOnList(
                event.requestId, event.isAPackageRequest));
          }
        } catch (e) {
          emit(const RatingCartError('خطا در برقراری ارتباط'));
        }
      } else if (event is RatingCartStarted) {
        emit(RatingCartSkltonLoading());
        await Future.delayed(Duration(seconds: 2));
        emit(RatingCartItemInitial());
      }
    });
  }
}
