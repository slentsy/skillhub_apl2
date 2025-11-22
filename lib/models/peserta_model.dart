class Peserta{
  int? _id;
  String _nama;

  Peserta (this._nama, {int? id}) {
    _id = id;
  }

  // getter untuk membaca data
  int? get id => _id;
  String get nama => _nama;

  // set namanya untuk edit 
  set nama(String value) => _nama = value;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nama': _nama,
    };
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  factory Peserta.fromMap(Map<String, dynamic> map) {
    return Peserta(
      map['nama'],
      id: map['id'],
    );
  }
}