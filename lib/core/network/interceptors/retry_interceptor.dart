import "dart:async";
import "package:dio/dio.dart";

class RetryInterceptor extends Interceptor {
  final Dio dio;

  RetryInterceptor({required this.dio});

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    RetryOptions extra =
        RetryOptions.fromExtra(err.requestOptions, const RetryOptions());
    final bool shouldRetry =
        extra.retries > 0 && await extra.retryEvaluator(err);

    if (shouldRetry) {
      extra = extra.copyWith(retries: extra.retries - 1);
      err.requestOptions.extra["cache_retry_request"] = extra;

      await Future<dynamic>.delayed(extra.retryInterval);

      final Response<dynamic> response = await dio.request<dynamic>(
        err.requestOptions.path,
        options: Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          responseType: err.requestOptions.responseType,
          contentType: err.requestOptions.contentType,
        ),
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
      return handler.resolve(response);
    }
    return handler.next(err);
  }
}

class RetryOptions {
  final int retries;
  final Duration retryInterval;
  final FutureOr<bool> Function(DioException error) retryEvaluator;

  const RetryOptions({
    this.retries = 3,
    this.retryInterval = const Duration(seconds: 1),
    this.retryEvaluator = defaultRetryEvaluator,
  });

  static const String extraKey = "cache_retry_request";

  factory RetryOptions.fromExtra(
      RequestOptions request, RetryOptions defaultOptions) {
    return request.extra[extraKey] ?? defaultOptions;
  }

  RetryOptions copyWith({int? retries, Duration? retryInterval}) {
    return RetryOptions(
      retries: retries ?? this.retries,
      retryInterval: retryInterval ?? this.retryInterval,
    );
  }

  Map<String, dynamic> toExtra() => <String, dynamic>{extraKey: this};

  static FutureOr<bool> defaultRetryEvaluator(DioException error) {
    return error.type != DioExceptionType.cancel &&
        error.type != DioExceptionType.badResponse;
  }
}
