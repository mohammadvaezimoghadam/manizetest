part of 'rating_cart_item_bloc.dart';

abstract class RatingCartItemState extends Equatable {
  const RatingCartItemState();
  
  @override
  List<Object> get props => [];
}

class RatingCartItemInitial extends RatingCartItemState {}

class RatingCartLoading extends RatingCartItemState{}
class RatingCartError extends RatingCartItemState{
  final String message;

  const RatingCartError(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
class RatingCartSuccess extends RatingCartItemState{
  final String message;
  final int packageRequestId;

  const RatingCartSuccess(this.message, this.packageRequestId);
  @override
  // TODO: implement props
  List<Object> get props => [message,packageRequestId];
}

class RatingCartSkltonLoading extends RatingCartItemState{

}


