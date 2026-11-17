import 'package:dio/dio.dart';

import '../models/umkm.dart';
import 'api_exception.dart';

/// Ganti sesuai lingkungan:
///  - Emulator Android : http://10.0.2.2:8080/api
///  - iOS simulator/web: http://localhost:8080/api
///  - HP fisik         : http://<IP-LAN-komputer>:8080/api
class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8080/api',
  );
}

/// Implementasi memakai Dio (timeout, logging, error handling terpusat).
class UmkmService {
  UmkmService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Accept': 'application/json'},
          // Biarkan 4xx masuk ke response agar bisa dibaca pesan errornya.
          validateStatus: (s) => s != null && s < 500,
        )) {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  final Dio _dio;

  Future<UmkmPage> fetchAll({int page = 1, String? query}) async {
    final res = await _call(() => _dio.get('/umkm', queryParameters: {
          'page': page,
          'per_page': 10,
          if (query != null && query.isNotEmpty) 'q': query,
        }));
    return UmkmPage.fromJson(res);
  }

  Future<Umkm> create(Umkm u) async {
    final res = await _call(() => _dio.post('/umkm', data: u.toJson()));
    return Umkm.fromJson(res['data']);
  }

  Future<Umkm> update(int id, Umkm u) async {
    final res = await _call(() => _dio.put('/umkm/$id', data: u.toJson()));
    return Umkm.fromJson(res['data']);
  }

  Future<void> delete(int id) async {
    await _call(() => _dio.delete('/umkm/$id'));
  }

  Future<Map<String, dynamic>> _call(Future<Response> Function() request) async {
    try {
      final r = await request();
      final body = r.data is Map<String, dynamic> ? r.data as Map<String, dynamic> : <String, dynamic>{};
      if (r.statusCode != null && r.statusCode! >= 400 || body['success'] == false) {
        final errs = (body['errors'] as Map?)?.map((k, v) => MapEntry('$k', '$v')) ?? {};
        throw ApiException(body['message'] ?? 'Terjadi kesalahan', statusCode: r.statusCode, fieldErrors: errs);
      }
      return body;
    } on DioException catch (e) {
      final msg = switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout =>
          'Koneksi timeout, coba lagi.',
        DioExceptionType.connectionError =>
          'Tidak dapat terhubung ke ${ApiConfig.baseUrl}\n(${e.message ?? e.error})',
        _ => 'Gagal memanggil ${ApiConfig.baseUrl}: ${e.type.name} ${e.response?.statusCode ?? ''} ${e.message ?? e.error}',
      };
      throw ApiException(msg, statusCode: e.response?.statusCode);
    }
  }
}
