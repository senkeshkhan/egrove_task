part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

class GetCustomerDetailsLoadingState extends DashboardState {}

class GetCustomerDetailsErrorState extends DashboardState {
  final String message;
  const GetCustomerDetailsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetCustomerDetailsSuccessState extends DashboardState {
  final CustomerModel customer;

  const GetCustomerDetailsSuccessState({required this.customer});

  @override
  List<Object> get props => [customer];
}
