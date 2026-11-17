/// Model manual (fromJson / toJson) sesuai struktur JSON API.
class Umkm {
  final int? id;
  final String namaUmkm;
  final String pemilik;
  final String alamat;
  final String kategori;
  final String kontak;

  const Umkm({
    this.id,
    required this.namaUmkm,
    required this.pemilik,
    required this.alamat,
    required this.kategori,
    required this.kontak,
  });

  factory Umkm.fromJson(Map<String, dynamic> json) => Umkm(
        id: json['id'] is String ? int.tryParse(json['id']) : json['id'] as int?,
        namaUmkm: (json['nama_umkm'] ?? '') as String,
        pemilik: (json['pemilik'] ?? '') as String,
        alamat: (json['alamat'] ?? '') as String,
        kategori: (json['kategori'] ?? '') as String,
        kontak: (json['kontak'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'nama_umkm': namaUmkm,
        'pemilik': pemilik,
        'alamat': alamat,
        'kategori': kategori,
        'kontak': kontak,
      };
}

/// Hasil list + metadata pagination dari `meta`.
class UmkmPage {
  final List<Umkm> items;
  final int page;
  final int totalPages;
  final int total;

  const UmkmPage({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  factory UmkmPage.fromJson(Map<String, dynamic> json) {
    final meta = (json['meta'] ?? <String, dynamic>{}) as Map<String, dynamic>;
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => Umkm.fromJson(e as Map<String, dynamic>))
        .toList();
    return UmkmPage(
      items: list,
      page: meta['page'] ?? 1,
      totalPages: meta['total_pages'] ?? 1,
      total: meta['total'] ?? list.length,
    );
  }
}
