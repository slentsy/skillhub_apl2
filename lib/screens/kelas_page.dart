import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/kelas_model.dart';
import 'detail_kelas_page.dart';

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Kelas> _listKelas = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final data = await _dbHelper.getKelas();
    setState(() {
      _listKelas = data;
    });
  }

  // form untuk tambah kelas baru atau edit kelas 
  void _showForm(Kelas? kelas) {
    final namaController = TextEditingController(text: kelas?.namaKelas);
    final deskripsiController = TextEditingController(text: kelas?.deskripsi);
    final instrukturController = TextEditingController(text: kelas?.instruktur);

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kelas == null ? "Tambah Kelas" : "Edit Kelas"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: "Nama Kelas"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Kelas wajib diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(labelText: "Deskripsi Singkat"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi Singkat wajib diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: instrukturController,
                  decoration: const InputDecoration(labelText: "Nama Instruktur"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Instruktur wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()){
                final k = Kelas(
                  namaController.text,
                  deskripsiController.text,
                  instrukturController.text,
                  id: kelas?.id,
                );

                if (kelas == null) {
                  await _dbHelper.tambahKelas(k);
                } else {
                  await _dbHelper.updateKelas(k);
                }
                _refreshData();
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  void _deleteItem(int id) async {
    await _dbHelper.deleteKelas(id);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Kelas")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _listKelas.length,
        itemBuilder: (context, index) {
          final item = _listKelas[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.class_, 
                color: Colors.blue
              ),
              title: Text(
                item.namaKelas, 
                style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Instruktur: ${item.instruktur}"),
              
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showForm(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(item.id!),
                  ),
                ],
              ),
              
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKelasPage(kelas: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}