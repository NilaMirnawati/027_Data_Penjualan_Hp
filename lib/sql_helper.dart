import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE catatan_database(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nama TEXT,
      tipe TEXT,
      warna TEXT,
      harga TEXT,
      stok TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('catatan_database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // add
  static Future<int> addCatatan(
      String nama, String tipe, String warna, String harga, String stok) async {
    final db = await SQLHelper.db();
    final data = {
      'nama': nama,
      'tipe': tipe,
      'warna': warna,
      'harga': harga,
      'stok': stok
    };
    return await db.insert('catatan_database', data);
  }

  // read
  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await SQLHelper.db();
    return db.query('catatan_database');
  }

  // update
  static Future<int> updateCatatan(int id, String nama, String tipe,
      String warna, String harga, String stok) async {
    final db = await SQLHelper.db();

    final data = {
      'nama': nama,
      'tipe': tipe,
      'warna': warna,
      'harga': harga,
      'stok': stok
    };
    return await db.update('catatan_database', data, where: "id = $id");
  }

  // delete
  static Future<void> deleteCatatan(int id) async {
    final db = await SQLHelper.db();
    await db.delete('catatan_database', where: "id = $id");
  }
}
