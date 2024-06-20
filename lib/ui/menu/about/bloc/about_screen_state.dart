part of 'about_screen_bloc.dart';

sealed class AboutScreenState extends Equatable {
  const AboutScreenState();

  @override
  List<Object> get props => [];
}

final class AboutScreenInitial extends AboutScreenState {}

class AboutScreenSuccess extends AboutScreenState {
  final String aboutText;

  const AboutScreenSuccess(this.aboutText);
  @override
  // TODO: implement props
  List<Object> get props => [aboutText];
}

class AboutScreenError extends AboutScreenState {}

class AboutScreenLoading extends AboutScreenState {}
