import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/umkm.dart';
import 'api_exception.dart';
import 'umkm_service.dart' show ApiConfig;

/// Versi pembanding memakai package `http` (tanpa interceptor/timeout bawaan).
/// Tidak dipakai UI; ada untuk membandingkan http vs dio pada laporan.
class UmkmServiceHttp {
  final _headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Future<UmkmPage> fetchAll({int page = 1}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/umkm').replace(queryParameters: {'page': '$page'});
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 10));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) throw ApiException(body['message'] ?? 'Gagal', statusCode: res.statusCode);
    return UmkmPage.fromJson(body);
  }

  Future<Umkm> create(Umkm u) async {
    final res = await http
        .post(Uri.parse('${ApiConfig.baseUrl}/umkm'), headers: _headers, body: jsonEncode(u.toJson()))
        .timeout(const Duration(seconds: 10));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) throw ApiException(body['message'] ?? 'Gagal', statusCode: res.statusCode);
    return Umkm.fromJson(body['data']);
  }
}
