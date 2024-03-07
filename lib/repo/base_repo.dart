//Third Party Imports
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

//Local Imports
import 'package:online_offline/utils/my_sharedpreference.dart';


class BaseRepository {
  /// For POST request
  Future<http.Response> postHttp({
    required Map<String, dynamic> data,
    required String api,
    bool token = false,
  }) async {
    String? accessToken;
    final url = 'http://192.168.0.113:8000' + api;
    log(url, name: 'postHttp');
    log(data.toString(), name: '$api data');
    if (token) {
      accessToken =
          await MySharedPreferences.instance.getStringValue("access_token");
      log(accessToken.toString(), name: "access_token");
    }

    final response = await http.post(
      Uri.parse(url),
      headers: accessToken == null
          ? {'Content-Type': 'application/json'}
          : {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
      body: json.encode(data),
    );
    log(response.statusCode.toString(),name: "Status Code");
    // if (response.statusCode == 403 || token) {
    //   signOut();
    //   // return refreshToken()
    //   //     .then((value) => postHttp(data: data, api: api, token: token));
    // }
    return response;
  }

  /// For GET request
  Future<http.Response> getHttp({
    required String api,
    bool token = false,
  }) async {
    String? accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5ZDQ0OTNkYy00MjJhLTRiOGYtYTk2OS1jODczYmRhMDllMjMiLCJpYXQiOjE3MDMxNjA0MDEsIm5iZiI6MTcwMzE2MDQwMSwianRpIjoiNDVhZmU2MzgtYTAyYi00NzgzLTlhMTgtNjFiN2JmNDIzNWE3IiwiZXhwIjoxNzAzMTY0MDAxLCJ0eXBlIjoiYWNjZXNzIiwiZnJlc2giOmZhbHNlfQ.EeHmpisa2fwQ0X6qPxmDE3McZqgk9rjvl4M8VFmKxqY";
    final url = 'http://192.168.0.113:8000' + api;
    log(url, name: 'getHttp');
    if (token) {
      accessToken =
          await MySharedPreferences.instance.getStringValue("access_token");
      log(accessToken.toString(), name: "access_token");
    }

    final response = await http.get(
      Uri.parse(url),
      headers: accessToken == null
          ? {'Content-Type': 'application/json'}
          : {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
    );
    log(response.statusCode.toString());
    if (response.statusCode == 403 && token) {
      return refreshToken().then((value) => getHttp(api: api, token: token));
    }
    return response;
  }

  /// For PUT request
  Future<http.Response> putHttp({
    required Map<String, dynamic> data,
    required String api,
    bool token = false,
  }) async {
    String? accessToken;
    final url = 'http://192.168.0.113:8000' + api;
    log(url, name: 'putHttp');
    log(data.toString(), name: '$api data');
    if (token) {
      accessToken =
          await MySharedPreferences.instance.getStringValue("access_token");
      log(accessToken.toString(), name: "access_token");
    }
    final response = await http.put(
      Uri.parse(url),
      headers: accessToken == null
          ? {'Content-Type': 'application/json'}
          : {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
      body: json.encode(data),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 403 && token) {
      return refreshToken()
          .then((value) => putHttp(data: data, api: api, token: token));
    }
    return response;
  }

  /// For DELETE request
  Future<http.Response> deleteHttp({
    required String api,
    bool token = false,
  }) async {
    String? accessToken;
    final url = 'http://192.168.0.113:8000' + api;
    log(url, name: 'deleteHttp');
    if (token) {
      accessToken =
          await MySharedPreferences.instance.getStringValue("access_token");
      log(accessToken.toString(), name: "access_token");
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: accessToken == null
          ? {'Content-Type': 'application/json'}
          : {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
    );
    if (response.statusCode == 403 && token) {
      log(response.statusCode.toString());
      return refreshToken().then((value) => deleteHttp(api: api, token: token));
    }
    return response;
  }

  Future<void> refreshToken() async {
    String? refreshToken =
        await MySharedPreferences.instance.getStringValue("refresh_token");
    final url = 'http://192.168.0.113:8000' + 'http://192.168.0.113:8000';
    log(refreshToken.toString(), name: 'refreshToken');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken'
      },
    );
    log(response.body, name: 'response refreshToken');
    String accessToken = json.decode(response.body)['data'];
    MySharedPreferences.instance.setStringValue("access_token", accessToken);
  }

  Future<http.Response> getRequest({
    required Map<String, dynamic> data,
    required String api,
    bool token = false,
  }) async {
    final url = 'http://192.168.0.113:8000' + api;
    log(url, name: 'getRequest');
    log(data.toString(), name: '$api data');

    final headers = {'Content-Type': 'application/json'};

    final request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(data);
    request.headers.addAll(headers);

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 403 && token) {
      log(response.statusCode.toString());
      return refreshToken()
          .then((value) => putHttp(data: data, api: api, token: token));
    }
    return response;
  }
}