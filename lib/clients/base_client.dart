import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

var baseUrl = 'http://192.168.100.12:8000';

var storage = const FlutterSecureStorage();

class BaseClient {
  var client = http.Client();

  Future<dynamic> get(String path) async {
    String? token = await storage.read(key: 'token').then((value) => value);

    var url = Uri.parse(baseUrl + path);
    var headers = {'Authorization': '$token'};
    var response = await client.get(url, headers: headers);
    if (response.statusCode == 401) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'name');
      await storage.delete(key: 'email');
    }
    return response.body;
  }

  Future<dynamic> post(String path, Map<String, dynamic> body,
      {bool needToken = false}) async {
    String? token = await storage.read(key: 'token').then((value) => value);
    var url = Uri.parse(baseUrl + path);
    var headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };
    if (!needToken) {
      headers.remove('Authorization');
    }
    var response =
        await client.post(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 401) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'name');
      await storage.delete(key: 'email');
    }
    return response.body;
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    String? token = await storage.read(key: 'token').then((value) => value);
    var url = Uri.parse(baseUrl + path);
    var headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };
    var response =
        await client.put(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 401) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'name');
      await storage.delete(key: 'email');
    }
    return response.body;
  }

  Future<dynamic> delete(String path, List<int> ids) async {
    String? token = await storage.read(key: 'token').then((value) => value);
    var url = Uri.parse(baseUrl + path);
    Map<String, String> params = {};
    for (int i = 0; i < ids.length; i++) {
      params['id$i'] = ids[i].toString();
    }
    var urlWithParams = url.replace(
      queryParameters: params,
    );
    var headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };
    var response = await client.delete(urlWithParams, headers: headers);
    if (response.statusCode == 401) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'name');
      await storage.delete(key: 'email');
    }
    return response.body;
  }
}
