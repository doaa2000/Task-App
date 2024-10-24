import 'package:dio/dio.dart';
import 'package:task/core/helper/storage_helper.dart';

class DioHelper {
  late Dio _dio;

  DioHelper() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://dev-hs-api.mroonah.com/',
      receiveDataWhenStatusError: true,
      headers: {
        'Content-Type': 'application/json',
        'x-api-version': 'v1',
      },
    );
    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("Request: ${options.method} ${options.path}");
          return handler.next(options); // continue with the request
        },
        onResponse: (response, handler) {
          print("Response: ${response.statusCode} ${response.data}");
          return handler.next(response); // continue with the response
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            String? refreshToken =
                await StorageHelper.instance.read('refreshToken');
            if (refreshToken != null) {
              try {
                final refreshResponse = await _dio.post(
                  'https://dev-hs-api.mroonah.com/api/customer/refresh',
                  options: Options(
                    headers: {
                      'Authorization': 'Bearer $refreshToken',
                    },
                  ),
                );

                if (refreshResponse.statusCode == 200) {
                  String newAccessToken =
                      refreshResponse.data['data']['access_token'];

                  await StorageHelper.instance
                      .write(key: 'accessToken', value: newAccessToken);

                  final retryOptions = e.requestOptions;
                  retryOptions.headers["Authorization"] =
                      "Bearer $newAccessToken";

                  final response = await _dio.request(
                    retryOptions.path,
                    options: Options(
                      method: retryOptions.method,
                      headers: retryOptions.headers,
                    ),
                    data: retryOptions.data,
                    queryParameters: retryOptions.queryParameters,
                  );

                  return handler.resolve(response);
                }
              } catch (refreshError) {
                await StorageHelper.instance.delete('accessToken');
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      String? accessToken = await StorageHelper.instance.read('accessToken');

      // Add Authorization header if the token is available
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      Response response = await _dio.get(endpoint,
          queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      rethrow; // Handle errors here or propagate it further
    }
  }

  // Example of a POST request
  Future<Response> post(String endpoint, dynamic data) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow; // Handle errors here or propagate it further
    }
  }
}
