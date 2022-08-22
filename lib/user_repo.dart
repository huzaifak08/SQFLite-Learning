import 'package:sqflite/sqflite.dart';

class UserRepo {
  void createTable(Database? db) {
    db?.execute(
        'CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, email TEXT, age INTEGER)');
  }

  Future<void> getUser(Database? db) async {
    final List<Map<String, dynamic>> maps = await db!.query('User');
    print(maps);
  }
}
