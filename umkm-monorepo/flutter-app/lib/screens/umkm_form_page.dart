import 'package:flutter/material.dart';

import '../models/umkm.dart';
import '../services/api_exception.dart';
import '../services/umkm_service.dart';

const kategoriList = ['Kuliner', 'Fashion', 'Kerajinan', 'Jasa', 'Pertanian', 'Lainnya'];

class UmkmFormPage extends StatefulWidget {
  final Umkm? item;
  const UmkmFormPage({super.key, this.item});

  @override
  State<UmkmFormPage> createState() => _UmkmFormPageState();
}

class _UmkmFormPageState extends State<UmkmFormPage> {
  final _service = UmkmService();
  final _key = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.item?.namaUmkm);
  late final _pemilik = TextEditingController(text: widget.item?.pemilik);
  late final _alamat = TextEditingController(text: widget.item?.alamat);
  late final _kontak = TextEditingController(text: widget.item?.kontak);
  late String? _kategori =
      kategoriList.contains(widget.item?.kategori) ? widget.item?.kategori : null;

  Map<String, String> _serverErrors = {};
  bool _saving = false;

  bool get _isEdit => widget.item != null;

  String? _req(String field, String? v) {
    if (_serverErrors[field] != null) return _serverErrors[field];
    return (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;
  }

  Future<void> _submit() async {
    setState(() => _serverErrors = {});
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);

    final u = Umkm(
      namaUmkm: _nama.text.trim(),
      pemilik: _pemilik.text.trim(),
      alamat: _alamat.text.trim(),
      kategori: _kategori ?? '',
      kontak: _kontak.text.trim(),
    );
    try {
      _isEdit ? await _service.update(widget.item!.id!, u) : await _service.create(u);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      // Tampilkan pesan validasi dari server (objek "errors") di bawah field.
      setState(() => _serverErrors = e.fieldErrors);
      _key.currentState!.validate();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Ubah UMKM' : 'Tambah UMKM')),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(labelText: 'Nama UMKM', border: OutlineInputBorder()),
              validator: (v) => _req('nama_umkm', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pemilik,
              decoration: const InputDecoration(labelText: 'Pemilik', border: OutlineInputBorder()),
              validator: (v) => _req('pemilik', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamat,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Alamat', border: OutlineInputBorder()),
              validator: (v) => _req('alamat', v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              items: kategoriList.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (v) => setState(() => _kategori = v),
              validator: (v) => _req('kategori', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kontak,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Kontak', border: OutlineInputBorder()),
              validator: (v) => _req('kontak', v),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEdit ? 'Simpan perubahan' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
