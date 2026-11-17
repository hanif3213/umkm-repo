# UMKM REST API (CodeIgniter 4) + Flutter Client

Praktik Topic 10 – REST API & JSON Parsing. Monorepo:

- `backend-ci4/`  – file `app/` untuk CodeIgniter 4 (CRUD `/api/umkm`)
- `flutter-app/`  – aplikasi Flutter (Dio + model `fromJson/toJson`)
- `docs/`         – template laporan & checklist pengujian

## 1. Menjalankan backend
Prasyarat: PHP 8.1+ (ekstensi intl, mbstring, mysqlnd/sqlite3), Composer.

```bash
composer create-project codeigniter4/appstarter backend-ci4-run
# salin isi backend-ci4/app/* ke backend-ci4-run/app/ (timpa/gabung)
cd backend-ci4-run
cp env .env
```
Edit `.env`:
```
CI_ENVIRONMENT = development
database.default.hostname = localhost
database.default.database = db_umkm
database.default.username = root
database.default.password =
database.default.DBDriver = MySQLi
```
Buat database `db_umkm`, tambahkan route dari `app/Config/Routes.snippet.php`
ke `app/Config/Routes.php`, lalu:
```bash
php spark migrate
php spark serve --host 0.0.0.0 --port 8080
```
(Opsional: ganti struktur repo agar `backend-ci4/` berisi proyek CI4 penuh sebelum di-push.)

## 2. Endpoint
| Method | URL | Keterangan |
|---|---|---|
| GET | /api/umkm?page=1&per_page=10&q=&kategori= | list + pagination (`meta`) |
| GET | /api/umkm/{id} | detail |
| POST | /api/umkm | tambah (201) |
| PUT | /api/umkm/{id} | ubah |
| DELETE | /api/umkm/{id} | hapus |

Body POST/PUT (JSON):
```json
{"nama_umkm":"Kopi Nusantara","pemilik":"Rafi A","alamat":"Jl. Ayani No. 10, Banjarbaru","kategori":"Kuliner","kontak":"08123456789"}
```

## 3. Menjalankan Flutter
```bash
cd flutter-app
flutter create .        # membuat folder android/ios (sekali saja; lib/ & pubspec tidak ditimpa)
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:8080/api   # emulator Android
```
HP fisik: pakai IP LAN komputer. Android 9+ melarang HTTP biasa: tambahkan
`android:usesCleartextTraffic="true"` pada `<application>` di `android/app/src/main/AndroidManifest.xml`
dan izin `<uses-permission android:name="android.permission.INTERNET"/>`.

## Perbaikan desain di atas modul
Validasi + pesan error per-field, pagination & pencarian, state loading/error/kosong, konfirmasi hapus,
pull-to-refresh, versi `http` pembanding (`umkm_service_http.dart`).
