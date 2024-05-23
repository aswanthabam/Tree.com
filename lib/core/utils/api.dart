import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:tree_com/core/utils/preferences.dart';

class API {
  static String apiUrl = 'https://treecom.vercel.app';

  // static String apiUrl = 'http://10.0.2.2:8000';
  static String? accessToken;
  static final Map<String, String> headers = {};

  static void fetchAccessToken() async {
    API.accessToken = await AppPreferences.accessToken;
    headers['Authorization'] = 'Bearer $accessToken';
  }

  static void setAPIUrl(String url) {
    apiUrl = url;
  }

  API() {
    headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<APIResponse> get(String path) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$path'),
          headers: headers..addAll({'Content-Type': 'application/json'}));
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse('$apiUrl/$path'),
          body: json.encode(body),
          headers: headers..addAll({'Content-Type': 'application/json'}));
      print(response.body);
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> postImage(
      String path, File file, Map<String, dynamic> body) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$apiUrl/$path"));
      request.headers.addAll(headers);
      body.forEach((key, value) {
        request.fields[key] = value;
      });
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('image', fileStream, length,
          filename: file.path.split('/').last,
          contentType: MediaType(
              'image', 'jpeg')); // Adjust the content type accordingly

      request.files.add(multipartFile);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      return getResponse(responseString);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.put(Uri.parse('$apiUrl/$path'),
          body: json.encode(body),
          headers: headers..addAll({'Content-Type': 'application/json'}));
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> delete(String path) async {
    try {
      final response =
          await http.delete(Uri.parse('$apiUrl/$path'), headers: headers);
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  APIResponse getResponse(String body) {
    final data = json.decode(body);
    return APIResponse(
        hasError: data['has_error'],
        message: data['message'],
        data: data['data']);
  }

  static String getImageUrl(String imgUrl) {
    return API.apiUrl + imgUrl;
  }
}

class APIResponse {
  final bool hasError;
  final String message;
  final Map<String, dynamic> data;

  APIResponse(
      {required this.hasError, required this.message, required this.data});

  @override
  String toString() {
    return 'APIResponse{hasError: $hasError, message: $message, data: $data}';
  }
}
