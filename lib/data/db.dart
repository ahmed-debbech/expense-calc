import 'package:sqflite/sqflite.dart';
import 'package:calculator/logic/trx.dart';
import 'package:path/path.dart';

Future<Database> openMyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'db6.db');
  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      db.execute('''
          CREATE TABLE trx (
            time text PRIMARY KEY,
            amount double NOT NULL,
            name text NOT NULL,
            isadd boolean not null
          )
          ''');
    },
  );
  return database;
}

Future<List<Trx>> getAllDb() async {
  final db = await openMyDatabase();

  List<Trx> list = [];

  List<Map<String, dynamic>> rows = await db.query("trx");
  for (int i = 0; i <= rows.length - 1; i++) {
    list.add(Trx(
        name: (rows[i]["name"]) as String,
        time: (rows[i]["time"]) as String,
        amount: (rows[i]["amount"]) as double,
        type: (rows[i]["isadd"]) == 0 ? false : true));
  }
  await db.close();
  return list;
}

Future<List<Trx>> getAllDbSorted() async {
  final db = await openMyDatabase();

  List<Trx> list = [];

  List<Map<String, dynamic>> rows = await db
      .rawQuery('SELECT * FROM trx order by cast(time as integer) desc');
  for (int i = 0; i <= rows.length - 1; i++) {
    list.add(Trx(
        name: (rows[i]["name"]) as String,
        time: (rows[i]["time"]) as String,
        amount: (rows[i]["amount"]) as double,
        type: (rows[i]["isadd"]) == 0 ? false : true));
  }
  await db.close();
  return list;
}

void add(Trx t) async {
  final db = await openMyDatabase();
  await db.insert(
    'trx',
    {'time': t.time, 'amount': t.amount, 'name': t.name, 'isadd': t.type},
  );
  db.close();
}
