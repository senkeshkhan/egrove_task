import 'dart:convert';
import 'dart:io';

import 'package:login/api/api_urls.dart';

class ApiProvider {
  // Http Client
  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  // Headers
  getHeader(String token) {
    return {
      'device': 'mobile',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  // Login api call
  Future<dynamic> loginWithUsernameAndPassword(
      String userName, String password) async {
    try {
      final Uri url = Uri.parse(ApiUrls.loginUrl);
      final HttpClientRequest request = await client.postUrl(url);

      request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
      final String body = jsonEncode(
        {"username": userName, "password": password},
      );

      request.add(utf8.encode(body));
      final HttpClientResponse response = await request.close();

      // API DETAILS
      print("------------------- API DETAILS -------------------");
      print("API Url:- ${ApiUrls.loginUrl}");
      print("Request headers:- ${request.headers}");
      print("Request body:- $body");
      print("Response status Code:- ${response.statusCode}");

      return response;
    } catch (e) {
      return Exception("Cannot login right now");
    }
  }

  // Signup Api call
  Future<dynamic> signup(
      String email, String firstName, String lastName, String password) async {
    try {
      final Uri url = Uri.parse(ApiUrls.signupUrl);
      final request = await client.postUrl(url);

      final String body = jsonEncode({
        "customer": {
          'email': email,
          'firstname': firstName,
          'lastname': lastName,
          "website_id": "1",
          "Store_id": "1",
          "group_id": "4",
          "custom_attributes": [
            {"attribute_code": "business_gst", "value": "33AAGCT8582P1ZI"},
            {
              "attribute_code": "fcm_token",
              "value":
                  """ej_5EhtOrw0:APA91bHmTc1O94kUbiyzi1SrIwCyiiXaeQ8xoKWQstB
ln0BmE49BnBgZi95XCQrQqbnpr1ON4rvJv5VJNsnUkP_sOrXuhC_KSLSVy7r2x7H
ek5fJAQP9UzgIFeRviohgDb0QUc1Bw9VW"""
            },
            {"attribute_code": "app_id", "value": "1"},
            {"attribute_code": "device_type", "value": "android"},
            {"attribute_code": "push_status", "value": true}
          ]
        },
        'password': password,
      });
      request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');

      request.add(utf8.encode(body));
      final HttpClientResponse response = await request.close();

      // API DETAILS
      print("------------------- API DETAILS -------------------");
      print("API Url:- ${ApiUrls.signupUrl}");
      print("Request headers:- ${request.headers}");
      print("Request body:- $body");
      print("Response status Code:- ${response.statusCode}");

      return response;
    } catch (e) {
      return Exception("Cannot signup right now");
    }
  }

  Future<dynamic> getCustomerDetails(String token) async {
    try {
      final Uri url = Uri.parse(ApiUrls.customerDetailsUrl);
      final request = await client.getUrl(url);
      request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
      final HttpClientResponse response = await request.close();

      // API DETAILS
      print("------------------- API DETAILS -------------------");
      print("API Url:- ${ApiUrls.customerDetailsUrl}");
      print("Request headers:- ${request.headers}");
      print("Response status Code:- ${response.statusCode}");
      return response;
    } catch (e) {
      return Exception("Cannot get details right now");
    }
  }
}
