import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final _dio = Dio();

  Future<List<dynamic>> fetchData(String path,
      {CancelToken? cancelToken}) async {
    final response = await _dio.get(path, cancelToken: cancelToken);

    return response.statusCode == 200
        ? response.data
        : throw Exception('Failed to fetch data');
  }
}
