part of 'rating_screen_bloc.dart';

abstract class RatingScreenEvent extends Equatable {
  const RatingScreenEvent();

  @override
  List<Object> get props => [];
}

class RatingScreenStarted extends RatingScreenEvent{
  final List<int> packageRequestIds;
  final List<int> collectRepuestIds;
  final ThemeData theme;

  const RatingScreenStarted(this.packageRequestIds, this.theme, this.collectRepuestIds);
  @override
  // TODO: implement props
  List<Object> get props => [packageRequestIds,theme,collectRepuestIds];
}

class RatingScreenChangeOnList extends RatingScreenEvent{
  final String packageId;
  final bool isAPackageRequest;

  const RatingScreenChangeOnList(this.packageId, this.isAPackageRequest);
  @override
  // TODO: implement props
  List<Object> get props => [packageId,isAPackageRequest];
}
