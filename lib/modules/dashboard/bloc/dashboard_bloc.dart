import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/api/api_repository.dart';
import 'package:login/modules/dashboard/models/customer_model.dart';
import 'package:login/utils/app_utils.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiRepository apiRepo = ApiRepository();
  DashboardBloc() : super(DashboardInitial()) {
    on<GetCustomerDetailsEvent>(getCustomerDetailsBloc);
  }
  getCustomerDetailsBloc(
    GetCustomerDetailsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(GetCustomerDetailsLoadingState());
      final token = await AppUtils.getToken();
      final response = await apiRepo.getCustomerDetails(token);
      final body =
          await jsonDecode(await response.transform(utf8.decoder).join());
      print("Response body:- $body");

      if (response.statusCode == 200) {
        emit(
          GetCustomerDetailsSuccessState(
            customer: CustomerModel.fromJson(body),
          ),
        );
      } else {
        if (body.containsKey("message")) {
          emit(GetCustomerDetailsErrorState(message: body['message']));
        } else if (body.containsKey("error")) {
          emit(GetCustomerDetailsErrorState(message: body['error']));
        } else {
          emit(const GetCustomerDetailsErrorState(
              message: "Something went wrong"));
        }
      }
    } catch (e) {
      emit(const GetCustomerDetailsErrorState(
          message: "Internal Error occured"));
    }
  }
}
