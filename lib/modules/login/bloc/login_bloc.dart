import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/api/api_repository.dart';
import 'package:login/utils/app_utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool isVisible = false;
  final ApiRepository _apiRepo = ApiRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>(loginUserBloc);
    on<ChangeVisibilityEvent>(changeVisibilityBloc);
  }

  loginUserBloc(LoginUserEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginUserLoadingState());

      // Validations
      if (event.userName.trim().isEmpty) {
        emit(const LoginUserErrorState(message: "Username can't be empty"));
        return;
      } else if (event.password.trim().isEmpty) {
        emit(const LoginUserErrorState(message: "Password can't be empty"));
        return;
      }

      final HttpClientResponse response = await _apiRepo
          .loginWithUsernameAndPassword(event.userName, event.password);

      final body = await response.transform(utf8.decoder).join();
      print("Response body:- $body");
      if (response.runtimeType == Exception) {
        emit(const LoginUserErrorState(message: "Unable to login right now"));
      } else {
        if (response.statusCode == 200) {
          await AppUtils.setToken(body);
          emit(LoginUserSuccessState());
        } else {
          final decodedBody = jsonDecode(body);
          if (decodedBody.containsKey("message")) {
            emit(LoginUserErrorState(message: decodedBody['message']));
          } else if (decodedBody.containsKey("error")) {
            emit(LoginUserErrorState(message: decodedBody['error']));
          } else {
            emit(const LoginUserErrorState(message: "Something went wrong"));
          }
        }
      }
    } catch (e) {
      print(e);
      emit(const LoginUserErrorState(message: "Internal Error Occured"));
    }
  }

  changeVisibilityBloc(
    ChangeVisibilityEvent event,
    Emitter<LoginState> emit,
  ) async {
    isVisible = event.isVisible;
    emit(ChangeVisibilityState(isVisible: isVisible));
  }
}
