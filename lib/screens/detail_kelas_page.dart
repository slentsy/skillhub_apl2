import 'package:flutter/material.dart';
import 'package:skillhub_apl2/models/registrasi_model.dart';
import '../db/database_helper.dart';
import '../models/kelas_model.dart';
// import '../models/peserta_model.dart';

class DetailKelasPage extends StatefulWidget {
  final Kelas kelas;

  const DetailKelasPage({super.key, required this.kelas});

  @override
  State<DetailKelasPage> createState() => _DetailKelasPageState();
}

class _DetailKelasPageState extends State<DetailKelasPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // method yang digunakan untuk menghapus peserta dari kelas yang diikuti
  void _hapusPesertaDariKelas(int pesertaId) async {
    await _dbHelper.hapusPendaftaran(pesertaId, widget.kelas.id!);
    // refresh halaman untuk update list peserta
    setState(() {}); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Peserta berhasil dihapus dari kelas ini"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Kelas")),
      body: Column(
        children: [
          // info kelas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.orange.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.kelas.namaKelas, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Instruktur: ${widget.kelas.instruktur}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text(widget.kelas.deskripsi, style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.centerLeft, 
              child: Text("Peserta di kelas ini:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
          ),

          // list peserta yang terdaftar di kelas
          Expanded(
            child: FutureBuilder<List<PesertaTerdaftar>>(
              // memanggil function di database helper
              future: _dbHelper.getPesertaByKelasId(widget.kelas.id!), 
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada peserta di kelas ini."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final regist = snapshot.data![index];
                    // final peserta = snapshot.data![index].peserta.nama;
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(regist.peserta.nama),
                        subtitle: Text("Tanggal Daftar: ${regist.tanggal.substring(0,16)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _hapusPesertaDariKelas(regist.peserta.id!),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}