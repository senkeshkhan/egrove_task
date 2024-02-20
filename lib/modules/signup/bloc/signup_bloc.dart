import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/api/api_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  bool isVisible = false;
  final _apiRepo = ApiRepository();
  SignupBloc() : super(SignupInitial()) {
    on<SignupUserEvent>(signupUserBloc);
    on<ChangeVisibilityEvent>(changeVisibilityBloc);
  }

  signupUserBloc(SignupUserEvent event, Emitter<SignupState> emit) async {
    try {
      emit(SignupUserLoadingState());

      // Validations
      if (event.email.trim().isEmpty) {
        emit(const SignupUserErrorState(message: "Email can't be empty"));
        return;
      } else if (event.password.trim().isEmpty) {
        emit(const SignupUserErrorState(message: "Password can't be empty"));
        return;
      } else if (event.firstName.isEmpty) {
        emit(const SignupUserErrorState(message: "First name can't be empty"));
        return;
      } else if (event.lastName.isEmpty) {
        emit(const SignupUserErrorState(message: "Last name can't be empty"));
        return;
      }

      final HttpClientResponse response = await _apiRepo.signup(
          event.email, event.firstName, event.lastName, event.password);

      final body = await response.transform(utf8.decoder).join();
      print("Response body:- $body");

      if (response.runtimeType == Exception) {
        emit(
          const SignupUserErrorState(
            message: "Unable to Signup right now",
          ),
        );
      } else {
        if (response.statusCode == 200) {
          emit(SignupUserSuccessState());
        } else {
          final decodedBody = jsonDecode(body);
          if (decodedBody.containsKey("message")) {
            emit(SignupUserErrorState(message: decodedBody['message']));
          } else if (decodedBody.containsKey("error")) {
            emit(SignupUserErrorState(message: decodedBody['error']));
          } else {
            emit(const SignupUserErrorState(message: "Something went wrong"));
          }
        }
      }
    } catch (e) {
      print(e);
      emit(const SignupUserErrorState(message: "Internal Error Occured"));
    }
  }

  changeVisibilityBloc(
    ChangeVisibilityEvent event,
    Emitter<SignupState> emit,
  ) async {
    isVisible = event.isVisible;
    emit(ChangeVisibilityState(isVisible: isVisible));
  }
}
