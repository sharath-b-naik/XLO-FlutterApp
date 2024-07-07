import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared/shared.dart';

typedef ApiResponseType = Either<Failure, Success>;
typedef FutureEither<T> = Future<Either<Failure, T>>;

class ApiHelper {
  static Map<String, String> _headers([String? vesrion]) => {
        if (authToken != null) "Authorization": "Bearer $authToken",
        "content-type": "application/json; charset=utf-8",
      };

  static Map<String, dynamic>? convertPararmsToHttpsFormat(Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) return null;

    Map<String, dynamic> output = {};
    for (String key in queryParams.keys) {
      final valueOfkey = queryParams[key];
      if (valueOfkey is List) {
        final formatted = valueOfkey.map((value) => "$key=$value").join("&").split("=").sublist(1).join("=");
        output.addAll({key: formatted});
      } else {
        output.addAll({key: valueOfkey.toString()});
      }
    }

    return output;
  }

  static Uri _getUri(String path, {Map<String, dynamic>? queryParams}) {
    final schema = apiUrl.split("//")[1];
    final uri = Uri.https(schema, path, convertPararmsToHttpsFormat(queryParams));
    return uri;
  }

  static Future<ApiResponseType> get(String path, {Map<String, dynamic>? queryParams, String? vesrion}) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await http.get(uri, headers: _headers(vesrion));
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - GET - $path");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> post(
    String path, {
    dynamic body,
    String? vesrion,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await http.post(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers(vesrion),
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - POST");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> put(
    String path, {
    String? vesrion,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await http.put(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers(vesrion),
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - PUT");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> delete(
    String path, {
    String? vesrion,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await http.delete(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers(vesrion),
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - DELETE");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> patch(
    String path, {
    String? vesrion,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await http.patch(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers(vesrion),
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - PATCH");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> upload(String path, List<String> files) async {
    try {
      final uri = _getUri(path);
      var request = http.MultipartRequest('POST', uri);
      final multipartFiles = files.map((element) {
        final file = File(element);
        return http.MultipartFile(
          "files",
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: element.split("/").last,
        );
      });
      request.headers.addAll(_headers());
      request.files.addAll(multipartFiles);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - POST - UPLOAD");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Either<Failure, Success> parseResponse(http.Response response) {
    final decodedResponse = json.decode(utf8.decode(response.bodyBytes, allowMalformed: true));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Right(Success(decodedResponse['data']));
    } else if (response.statusCode == 401) {
      return const Left(Failure("Unauthorized"));
    } else {
      return Left(Failure("${decodedResponse['message']}"));
    }
  }
}

/// Return results
@immutable
class Success {
  final dynamic data;
  const Success(this.data);
}

@immutable
class Failure {
  final String message;
  const Failure(this.message);
}
