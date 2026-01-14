import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

export 'package:dio/dio.dart';

late Dio dio;
late Logger logger;

void initializeNetworkConfigurations() {
  logger = Logger();
  dio = Dio(
    BaseOptions(
      baseUrl: "https://verifacts-backend.onrender.com",
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            logger.i(
              '➡️ REQUEST[${options.method}] => PATH: ${options.uri}\n'
              'Headers: ${options.headers}\n'
              'Data: ${options.data}',
            );

            handler.next(options);
          } catch (e, stack) {
            logger.e(
              'Error preparing request for ${options.path}',
              error: e,
              stackTrace: stack,
            );
            handler.next(options);
          }
        },
        onResponse: (response, handler) {
          logger.i(
            '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}\n'
            'Data: ${response.data}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          logger.e(
            '⛔ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.uri}\n'
            'Message: ${error.response?.data}',
          );
          handler.next(error);
        },
      ),
    );
  }
}

String determineDioError(DioException e) {
  String message = "";
  switch (e.type) {
    case DioExceptionType.badResponse:
      {
        try {
          var msg = e.response?.data["errorMessage"];
          msg ??= e.response?.data["message"];

          if (msg is String) {
            message = msg;
          } else if (msg is List) {
            message = msg.join(". ");
          } else {
            message = "An error occurred";
          }
        } catch (e) {
          message = "An unexpected error occurred";
        }
      }
    case DioExceptionType.connectionError:
      message = "Unable to connect. Please check your internet connection";
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      message = "Request timeout. Please try again";
    case DioExceptionType.badCertificate:
      message = "Bad certificate.";
    case DioExceptionType.cancel:
      message = "Request canceled. Please try again";
    case DioExceptionType.unknown:
      message = "An unknown error occurred. Please try again.";
  }

  return message;
}
