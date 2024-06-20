part of 'about_screen_bloc.dart';

sealed class AboutScreenEvent extends Equatable {
  const AboutScreenEvent();

  @override
  List<Object> get props => [];
}

class AboutScreenStarted extends AboutScreenEvent{
  
}
