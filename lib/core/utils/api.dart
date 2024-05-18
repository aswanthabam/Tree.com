import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  // static String apiUrl = 'https://treecom.vercel.app';
  static String apiUrl = 'http://10.0.2.2:8000';

  Future<APIResponse> get(String path) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$path'));
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse('$apiUrl/$path'),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'}
      );
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.put(Uri.parse('$apiUrl/$path'),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'});
      return getResponse(response.body);
    } catch (e) {
      return APIResponse(hasError: true, message: e.toString(), data: {});
    }
  }

  Future<APIResponse> delete(String path) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$path'));
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
