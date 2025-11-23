class Peserta {
  int? _id;
  String _nama;
  String _email; 
  String _noHp; 

  Peserta(this._nama, this._email, this._noHp, {int? id}) {
    _id = id;
  }

  int? get id => _id;
  String get nama => _nama;
  String get email => _email;
  String get noHp => _noHp;

  set nama(String value) => _nama = value;
  set email(String value) => _email = value;
  set noHp(String value) => _noHp = value;

  Map<String, dynamic> toMap() {
    return {
      'nama': _nama,
      'email': _email,
      'no_hp': _noHp,
    };
  }

  factory Peserta.fromMap(Map<String, dynamic> map) {
    return Peserta(
      map['nama'],
      map['email'] ?? '-',
      map['no_hp'] ?? '-',
      id: map['id'],
    );
  }
}