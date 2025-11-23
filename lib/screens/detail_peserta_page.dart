import 'package:flutter/material.dart';
import 'package:skillhub_apl2/models/registrasi_model.dart';
import '../db/database_helper.dart';
import '../models/peserta_model.dart';
// import '../models/kelas_model.dart';

class DetailPesertaPage extends StatelessWidget {
  final Peserta peserta;

  const DetailPesertaPage({super.key, required this.peserta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Peserta")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade100,
            child: Column(
              children: [
                const Icon(Icons.person, size: 80, color: Colors.blue),
                const SizedBox(height: 10),
                Text(peserta.nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("ID: ${peserta.id} | Email: ${peserta.email} | No HP: ${peserta.noHp}", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          
          // kelas yang diikuti peserta
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.centerLeft, 
              child: Text("Kelas yang diikuti:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<KelasTerambil>>(
              // memanggil method untuk dapat informasi kelas yang diikuti pserta
              future: DatabaseHelper().getKelasByPesertaId(peserta.id!), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum mendaftar kelas apapun."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final regist = snapshot.data![index];
                    // final kelas = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.class_, color: Colors.orange),
                        title: Text(regist.kelas.namaKelas),
                        subtitle: Text("Instruktur: ${regist.kelas.instruktur}\nTanggal Daftar: ${regist.tanggal.substring(0,16)}"),
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