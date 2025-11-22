import 'kelas_model.dart';
import 'peserta_model.dart';

class PesertaTerdaftar {
  final Peserta peserta;
  final String tanggal;

  PesertaTerdaftar({
    required this.peserta, 
    required this.tanggal
  });
}

class KelasTerambil {
  final Kelas kelas;
  final String tanggal;

  KelasTerambil({
    required this.kelas, 
    required this.tanggal
  });
}