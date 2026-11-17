import 'package:flutter/material.dart';

import '../models/umkm.dart';
import '../services/api_exception.dart';
import '../services/umkm_service.dart';
import 'umkm_form_page.dart';

class UmkmListPage extends StatefulWidget {
  const UmkmListPage({super.key});

  @override
  State<UmkmListPage> createState() => _UmkmListPageState();
}

class _UmkmListPageState extends State<UmkmListPage> {
  final _service = UmkmService();
  final _search = TextEditingController();
  late Future<UmkmPage> _future;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.fetchAll(page: _page, query: _search.text.trim());
  }

  Future<void> _refresh() async {
    setState(_load);
    await _future.catchError((_) => const UmkmPage(items: [], page: 1, totalPages: 1, total: 0));
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _openForm([Umkm? item]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UmkmFormPage(item: item)),
    );
    if (saved == true) _refresh();
  }

  Future<void> _confirmDelete(Umkm u) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus UMKM?'),
        content: Text('"${u.namaUmkm}" akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _service.delete(u.id!);
      _toast('Data UMKM berhasil dihapus');
      _refresh();
    } on ApiException catch (e) {
      _toast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Direktori UMKM')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBar(
              controller: _search,
              hintText: 'Cari nama UMKM atau pemilik',
              leading: const Icon(Icons.search),
              onSubmitted: (_) {
                _page = 1;
                _refresh();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<UmkmPage>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.cloud_off, size: 48),
                      const SizedBox(height: 8),
                      Text('${snap.error}'),
                      TextButton(onPressed: _refresh, child: const Text('Coba lagi')),
                    ]),
                  );
                }
                final data = snap.data!;
                if (data.items.isEmpty) {
                  return const Center(child: Text('Belum ada data UMKM'));
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: data.items.length + 1,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      if (i == data.items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: data.page > 1 ? () { _page--; _refresh(); } : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text('Hal ${data.page}/${data.totalPages}  •  ${data.total} data'),
                              IconButton(
                                onPressed: data.page < data.totalPages ? () { _page++; _refresh(); } : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        );
                      }
                      final u = data.items[i];
                      return ListTile(
                        title: Text(u.namaUmkm),
                        subtitle: Text('${u.pemilik} • ${u.kategori}\n${u.alamat}'),
                        isThreeLine: true,
                        onTap: () => _openForm(u),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmDelete(u),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
