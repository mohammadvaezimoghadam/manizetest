part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String firstName;
  final String lastName;
  final String phone;

  const ProfileSuccess(this.firstName, this.lastName, this.phone);

  @override
  // TODO: implement props
  List<Object> get props => [phone, lastName, firstName];
}

class ProfileEError extends ProfileState {
  final AppException appException;

  const ProfileEError(this.appException);
  @override
  // TODO: implement props
  List<Object> get props => [appException];
}
