import 'dart:convert';

import 'package:http/http.dart' as http;

var baseUrl = 'http://localhost:3000';

class BaseClient {
  var client = http.Client();

  Future<dynamic> get(String path) async {
    var url = Uri.parse(baseUrl + path);
    var _headers = {
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmFtZSI6Ikx1Y2FzIEJyYXoiLCJlbWFpbCI6Imx1Y2FzLmJyYXpAZ21haWwuY29tIiwiaWF0IjoxNzMyNTY2NDk5LCJleHAiOjE3MzI1OTUyOTl9.FJRG3eFJRpVdWiFjMdSiPipT03mz2-KT0T8lbUv7TFw',
    };
    var response = await client.get(url, headers: _headers);
    return response.body;
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    var url = Uri.parse(baseUrl + path);
    var _headers = {
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmFtZSI6Ikx1Y2FzIEJyYXoiLCJlbWFpbCI6Imx1Y2FzLmJyYXpAZ21haWwuY29tIiwiaWF0IjoxNzMyNTY2NDk5LCJleHAiOjE3MzI1OTUyOTl9.FJRG3eFJRpVdWiFjMdSiPipT03mz2-KT0T8lbUv7TFw',
      'Content-Type': 'application/json',
    };
    var response =
        await client.post(url, body: jsonEncode(body), headers: _headers);
    return response.body;
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    var url = Uri.parse(baseUrl + path);
    var _headers = {
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmFtZSI6Ikx1Y2FzIEJyYXoiLCJlbWFpbCI6Imx1Y2FzLmJyYXpAZ21haWwuY29tIiwiaWF0IjoxNzMyNTY2NDk5LCJleHAiOjE3MzI1OTUyOTl9.FJRG3eFJRpVdWiFjMdSiPipT03mz2-KT0T8lbUv7TFw',
      'Content-Type': 'application/json',
    };
    var response =
        await client.put(url, body: jsonEncode(body), headers: _headers);
    return response.body;
  }

  Future<dynamic> delete(String path, List<int> ids) async {
    var url = Uri.parse(baseUrl + path);
    Map<String, String> params = {};
    for (int i = 0; i < ids.length; i++) {
      params['id$i'] = ids[i].toString();
    }
    var urlWithParams = url.replace(
      queryParameters: params,
    );
    var _headers = {
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmFtZSI6Ikx1Y2FzIEJyYXoiLCJlbWFpbCI6Imx1Y2FzLmJyYXpAZ21haWwuY29tIiwiaWF0IjoxNzMyNTY2NDk5LCJleHAiOjE3MzI1OTUyOTl9.FJRG3eFJRpVdWiFjMdSiPipT03mz2-KT0T8lbUv7TFw',
    };
    var response = await client.delete(urlWithParams, headers: _headers);
    return response.body;
  }
}
