part of 'rating_cart_item_bloc.dart';

abstract class RatingCartItemEvent extends Equatable {
  const RatingCartItemEvent();

  @override
  List<Object> get props => [];
}
class RatingCartStarted extends RatingCartItemEvent{}

class RatingCartSabtClicked extends RatingCartItemEvent {
  final String score;
  final bool isAPackageRequest;
  final String requestId;
  final String note;
  final BuildContext context;
  

  const RatingCartSabtClicked(this.score, this.requestId, this.note, this.context, this.isAPackageRequest);
  @override
  // TODO: implement props
  List<Object> get props => [score, requestId, note,context,isAPackageRequest];
}
