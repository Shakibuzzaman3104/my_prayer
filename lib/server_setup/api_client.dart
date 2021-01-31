import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/model/ModelPrayer.dart';

import '../base_url.dart';


class ApiClient {
  ApiClient._() {
    _dio = Dio();
  }

  static Dio _dio;
  static ApiClient _client;

  static ApiClient getInstance() {
    if (_client == null) {
      _client = ApiClient._();
    }
    return _client;
  }
  Future<Response> fetchData(
      {Map<String, dynamic> query, String endPoint}) async {

    Response res;
    try {
      res = await _dio.get(
        ApiCred.BASE_URL+endPoint,
        //data: formData,
        queryParameters: query,

        options: Options(
          //method:"POST",
          followRedirects: false,
          //contentType: "application/x-www-form-urlencoded",
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (res.statusCode >= 200 && res.statusCode <= 250) {
        print("Transfer Succeed");
        print(res);
      } else {
        print(res);
        print("Else not successful");
      }
    } catch (e) {
      res = e;
    }

    return res;
  }



}
