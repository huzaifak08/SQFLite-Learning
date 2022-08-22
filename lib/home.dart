import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_learn/database_handler.dart';
import 'package:sqflite_learn/user_model.dart';
import 'package:sqflite_learn/user_repo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Database? _database;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SqfLite Learn'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name:',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email:',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your age:',
              ),
            ),
            SizedBox(height: 12),
            OutlinedButton(
                onPressed: () {
                  insertDB();
                },
                child: Text('Insert Data')),
            SizedBox(height: 12),
            OutlinedButton(
                onPressed: () {
                  getFromUser();
                },
                child: Text('Read Data')),
          ],
        ),
      ),
    );
  }

  Future<Database?> openDB() async {
    _database = await DatabaseHandler().openDB();
    return _database;
  }

  Future<void> insertDB() async {
    _database = await openDB(); // Upper openDB function

    UserRepo userRepo = new UserRepo();
    userRepo.createTable(_database);

    UserModel userModel = new UserModel(
      nameController.text.toString(),
      emailController.text.toString(),
      int.tryParse(
        ageController.text.toString(),
      )!, // Remember this !
    );

    await _database?.insert('User', userModel.toMap());

    await _database?.close();
  }

  Future<void> getFromUser() async {
    _database = await openDB();
    UserRepo userRepo = new UserRepo();
    await userRepo.getUser(_database);
    await _database?.close();
  }
}
