import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/peserta_model.dart';
import 'detail_peserta_page.dart'; 

class PesertaPage extends StatefulWidget {
  const PesertaPage({super.key});

  @override
  State<PesertaPage> createState() => _PesertaPageState();
}

class _PesertaPageState extends State<PesertaPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Peserta> _listPeserta = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final data = await _dbHelper.getPeserta();
    setState(() {
      _listPeserta = data;
    });
  }

  void _showForm(Peserta? peserta) {
    final nameController = TextEditingController(text: peserta?.nama);

    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(peserta == null ? "Tambah Peserta" : "Edit Peserta"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Peserta"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Peserta wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            )
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()){
                final p = Peserta(
                  nameController.text, 
                  id: peserta?.id
                );
                // if (nameController.text.isEmpty) return;
                
                if (peserta == null) {
                  await _dbHelper.tambahPeserta(p);
                } else {
                  await _dbHelper.updatePeserta(p);
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
    await _dbHelper.deletePeserta(id);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Peserta")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _listPeserta.length,
        itemBuilder: (context, index) {
          final item = _listPeserta[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(child: Text(item.nama[0])),
              title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  MaterialPageRoute(builder: (context) => DetailPesertaPage(peserta: item))
                );
              },
            ),
          );
        },
      ),
    );
  }
}