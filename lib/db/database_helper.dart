import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/kelas_model.dart';
import '../models/peserta_model.dart';
import '../models/registrasi_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'skillhub.db'); 
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // tabel peserta
        await db.execute('''
          CREATE TABLE peserta(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nama TEXT
          )
        ''');

        // tabel kelas
        await db.execute('''
          CREATE TABLE kelas(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nama_kelas TEXT,
            deskripsi TEXT,
            instruktur TEXT
          )
        ''');

        // tabel pendaftaran
        await db.execute('''
          CREATE TABLE pendaftaran(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            peserta_id INTEGER, 
            kelas_id INTEGER, 
            tanggal_pendaftaran TEXT
          )
        ''');
      },
    );
  }

  // manage peserta
  Future<int> tambahPeserta(Peserta peserta) async {
    Database db = await database;
    return await db.insert('peserta', peserta.toMap());
  }

  Future<List<Peserta>> getPeserta() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'peserta', 
      orderBy: "id DESC"
    );
    return List.generate(maps.length, (i) {
      return Peserta.fromMap(maps[i]);
    });
  }

  Future<int> updatePeserta(Peserta peserta) async {
    Database db = await database;
    return await db.update(
      'peserta', 
      peserta.toMap(),
      where: 'id = ?',
      whereArgs: [peserta.id],
    );
  }

  Future<int> deletePeserta(int id) async {
    Database db = await database;
    return await db.delete(
      'peserta', 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  // manage kelas
  Future<int> tambahKelas(Kelas kelas) async {
    Database db = await database;
    return await db.insert('kelas', kelas.toMap());
  }

  Future<List<Kelas>> getKelas() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'kelas', 
      orderBy: "id DESC"
    );
    return List.generate(maps.length, (i) {
      return Kelas.fromMap(maps[i]);
    });
  }

  Future<int> updateKelas(Kelas kelas) async {
    Database db = await database;
    return await db.update(
      'kelas',
      kelas.toMap(),
      where: 'id = ?',
      whereArgs: [kelas.id],
    );
  }

  Future<int> deleteKelas(int id) async {
    Database db = await database;
    return await db.delete('kelas', where: 'id = ?', whereArgs: [id]);
  }

  // manage pendafataran
  Future<int> daftarKelas(int idPeserta, int idKelas) async {
    Database db = await database;

    // mengecek apakah peserta sudah pernah terdaftar
    final existingData = await db.query(
      'pendaftaran',
      where: 'peserta_id = ? AND kelas_id = ?',
      whereArgs: [idPeserta, idKelas],
    );

    // jika hasil dari exitingData ada dan tidak kosong
    if (existingData.isNotEmpty) {
      // dikembalikan -1 dengan tanda sudah terdaftar
      return -1; 
    }

    // kalau existingDatanya kosong, ditambahkan ke pendaftaran kelas yang baru 
    return await db.insert('pendaftaran', {
      'peserta_id': idPeserta,
      'kelas_id': idKelas,
      'tanggal_pendaftaran': DateTime.now().toString()
    });
  }

  // list kelas yang diikuti peseta
  Future<List<KelasTerambil>> getKelasByPesertaId(int pesertaId) async {
    Database db = await database;
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT k.*, p.tanggal_pendaftaran 
      FROM kelas k
      INNER JOIN pendaftaran p ON k.id = p.kelas_id
      WHERE p.peserta_id = ?
    ''', [pesertaId]);

    return List.generate(maps.length, (i) {
      return KelasTerambil(
        kelas: Kelas.fromMap(maps[i]),
        tanggal: maps[i]['tanggal_pendaftaran'],
      );
    });
  }

  // list peserta di spesifik kelas (detail kelas dengan informasi peserta yang terdaftar)
  Future<List<PesertaTerdaftar>> getPesertaByKelasId(int kelasId) async {
    Database db = await database;
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, d.tanggal_pendaftaran
      FROM peserta p
      INNER JOIN pendaftaran d ON p.id = d.peserta_id
      WHERE d.kelas_id = ?
    ''', [kelasId]);

    return List.generate(maps.length, (i) {
      return PesertaTerdaftar(
        peserta: Peserta.fromMap(maps[i]), 
        tanggal: maps[i]['tanggal_pendaftaran']
      );
    });
  }
  
  // hapus peserta dari kelas yang diikuti 
  Future<int> hapusPendaftaran(int pesertaId, int kelasId) async {
    Database db = await database;
    return await db.delete(
      'pendaftaran',
      where: 'peserta_id = ? AND kelas_id = ?',
      whereArgs: [pesertaId, kelasId],
    );
  }
}