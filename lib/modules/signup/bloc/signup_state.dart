part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {}

class ChangeVisibilityState extends SignupState {
  final bool isVisible;

  const ChangeVisibilityState({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}

class SignupUserLoadingState extends SignupState {}

class SignupUserErrorState extends SignupState {
  final String message;
  const SignupUserErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SignupUserSuccessState extends SignupState {}
