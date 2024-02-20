import 'package:login/api/api_provider.dart';

class ApiRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<dynamic> loginWithUsernameAndPassword(
      String userName, String password) async {
    return _apiProvider.loginWithUsernameAndPassword(userName, password);
  }

  Future<dynamic> signup(
      String email, String firstName, String lastName, String password) async {
    return _apiProvider.signup(email, firstName, lastName, password);
  }

  Future<dynamic> getCustomerDetails(String token) async {
    return _apiProvider.getCustomerDetails(token);
  }
}
