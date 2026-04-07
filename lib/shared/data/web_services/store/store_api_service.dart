import 'package:dio/dio.dart';

/// Plain Dio-based store API service (no Retrofit code generation needed).
class StoreApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://skill-swaapp.vercel.app';

  StoreApiService(this._dio);

  /// GET /store — Get all active store items
  Future<Map<String, dynamic>> getItems() async {
    final response = await _dio.get('$_baseUrl/store');

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// POST /store/purchase — Purchase an item using var_points
  Future<Map<String, dynamic>> joinTrack(String itemId) async {
    final response = await _dio.post(
      '$_baseUrl/store/purchase',
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }
}
