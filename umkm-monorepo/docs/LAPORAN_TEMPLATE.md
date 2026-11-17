# Laporan Praktik Topic 10 – REST API & JSON Parsing
Nama / NIM: ........   Kelas: ........

## 1. Hasil Test API (screenshot)
Ambil screenshot di Postman/Apidog/Thunder Client; sertakan URL, method, body, status code, dan response.

| # | Skenario | Request | Status diharapkan | Screenshot |
|---|---|---|---|---|
| 1 | Tambah data valid | POST /api/umkm | 201 | [ ] |
| 2 | Tambah data tidak valid (kosong / kategori salah) | POST /api/umkm | 400 + `errors` | [ ] |
| 3 | List data + pagination | GET /api/umkm?page=1&per_page=10 | 200 + `meta` | [ ] |
| 4 | Detail data | GET /api/umkm/1 | 200 | [ ] |
| 5 | Ubah data | PUT /api/umkm/1 | 200 | [ ] |
| 6 | Ubah id tidak ada | PUT /api/umkm/9999 | 404 | [ ] |
| 7 | Hapus data | DELETE /api/umkm/1 | 200 | [ ] |
| 8 | Hapus id tidak ada | DELETE /api/umkm/9999 | 404 | [ ] |

Tambahkan juga screenshot aplikasi Flutter: daftar, form tambah, error validasi dari server, hapus.

## 2. Refleksi Hasil
Tulis dengan pengalaman Anda sendiri. Poin pemandu:
- Apa konsep yang paling baru dipahami (stateless, status code, format `success/message/data/meta/errors`)?
- Kendala saat membuat API/CI4 dan Flutter (mis. CORS, base URL emulator 10.0.2.2, cleartext HTTP, migrasi) dan solusinya.
- Perbedaan http vs dio yang Anda rasakan.
- Manfaat model class (`fromJson/toJson`) dibanding `map['key']`.
- Improvisasi yang dilakukan dan rencana pengembangan (autentikasi, upload foto, dsb.).

## 3. Link Source Code
GitHub (public): https://github.com/<username>/<repo>
