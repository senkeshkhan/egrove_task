part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class ChangeVisibilityEvent extends SignupEvent {
  final bool isVisible;

  const ChangeVisibilityEvent({required this.isVisible});
}

class SignupUserEvent extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const SignupUserEvent(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});
}
