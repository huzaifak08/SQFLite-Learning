import 'package:sqflite/sqflite.dart';

class UserRepo {
  void createTable(Database? db) {
    db?.execute(
        'CREATE TABLE IF NOT EXISTS User(id INTEGER PRIMARY KEY, name TEXT, email TEXT, age INTEGER)');
  }

  // Future<void> getUser(Database? db) async {
  //   final List<Map<String, dynamic>> maps = await db!.query('User');
  //   print(maps);
  // }

  // For fetching all the data:
  Future<List<Map<String, dynamic>>> getUsers(Database? db) async {
    final List<Map<String, dynamic>> maps = await db!.query('User');
    return maps;
  }
}
