class Kelas {
  int? _id;
  String _namaKelas;
  String _deskripsi; 
  String _instruktur;

  Kelas(
    this._namaKelas, 
    this._deskripsi, 
    this._instruktur, {int? id}) {
    _id = id;
  }

  // get membaca data 
  int? get id => _id;
  String get namaKelas => _namaKelas;
  String get deskripsi => _deskripsi;
  String get instruktur => _instruktur;

  // set untuk edit kelas nya 
  set namaKelas(String value) => _namaKelas = value;
  set deskripsi(String value) => _deskripsi = value;
  set instruktur(String value) => _instruktur = value;

  // datanya diubah ke map untuk disimpan di Database
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nama_kelas': _namaKelas,
      'deskripsi': _deskripsi,
      'instruktur': _instruktur,
    };
    if (_id != null) map['id'] = _id;
    return map;
  }

  // untuk menampilkan dari map ke UI atau tampilan
  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(
      map['nama_kelas'],
      map['deskripsi'],
      map['instruktur'],
      id: map['id'],
    );
  }
}