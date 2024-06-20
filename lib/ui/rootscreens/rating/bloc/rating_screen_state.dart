part of 'rating_screen_bloc.dart';

abstract class RatingScreenState extends Equatable {
  const RatingScreenState();

  @override
  List<Object> get props => [];
}

class RatingScreenLoading extends RatingScreenState {}

class RatingScreenSuccessForTow extends RatingScreenState {
  final List<Widget> packageChildren;
  final List<Widget> collectChilderen;

  const RatingScreenSuccessForTow(this.packageChildren, this.collectChilderen);
  @override
  // TODO: implement props
  List<Object> get props => [packageChildren, collectChilderen];
}

class RatingScreenSuccessForOne extends RatingScreenState {
  final List<Widget> children;
  final bool evalutionForPackage;

  const RatingScreenSuccessForOne(this.children, this.evalutionForPackage);
  @override
  // TODO: implement props
  List<Object> get props => [children, evalutionForPackage];
}

class RatingIsFineshed extends RatingScreenState{}
