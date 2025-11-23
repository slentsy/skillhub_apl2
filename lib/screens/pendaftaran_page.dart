import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/peserta_model.dart';
import '../models/kelas_model.dart';

class PendaftaranPage extends StatefulWidget {
  const PendaftaranPage({super.key});

  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // untuk menjadikan list peserra dan kelas saat dropdown
  List<Peserta> _listPeserta = [];
  List<Kelas> _listKelas = [];
  
  // untuk simpan pilihan user dr dropdown
  int? _selectedPesertaId;
  int? _selectedKelasId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ambil data peserta dan kelas yg dipilih
  void _loadData() async {
    final pesertaData = await _dbHelper.getPeserta();
    final kelasData = await _dbHelper.getKelas();
    
    setState(() {
      _listPeserta = pesertaData;
      _listKelas = kelasData;
    });
  }

  // func simpan pendaftaran
  void _submitPendaftaran() async {
    if (_selectedPesertaId == null || _selectedKelasId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih Peserta dan Kelas dulu!"))
      );
      return;
    }

    // setelah itu dimpan ke database
    int result = await _dbHelper.daftarKelas(_selectedPesertaId!, _selectedKelasId!);

    // sesuai di database, -1 berarti gagal (sudah terdaftar)
    if (result == -1) {
      final kelasTerpilih = _listKelas.firstWhere((item) => item.id == _selectedKelasId);
      final pesertaTerpilih = _listPeserta.firstWhere((item) => item.id == _selectedPesertaId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${pesertaTerpilih.nama} sudah terdaftar di kelas ${kelasTerpilih.namaKelas}!"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        )
      );
    } else {
      // berhasil terdaftar
      setState(() {
        _selectedPesertaId = null;
        _selectedKelasId = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil Mendaftar!"),
          backgroundColor: Colors.green,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Pendaftaran Kelas")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Pilih Peserta:"),
            DropdownButton<int>(
              isExpanded: true,
              value: _selectedPesertaId,
              hint: const Text("Nama Peserta"),
              items: _listPeserta.map((Peserta p) {
                return DropdownMenuItem<int>(
                  value: p.id,
                  child: Text("${p.nama} | ${p.email} | ${p.noHp}", 
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPesertaId = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Pilih Kelas:"),
            DropdownButton<int>(
              isExpanded: true,
              value: _selectedKelasId,
              hint: const Text("Pilih kelas yang akan diikuti"),
              items: _listKelas.map((Kelas k) {
                return DropdownMenuItem<int>(
                  value: k.id,
                  child: Text("${k.namaKelas} (Oleh: ${k.instruktur})"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKelasId = value;
                });
              },
            ),

            const SizedBox(height: 40),

            // tombol daftar
            ElevatedButton.icon(
              onPressed: _submitPendaftaran,
              icon: const Icon(Icons.check_circle),
              label: const Text("Daftar Kelas"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}