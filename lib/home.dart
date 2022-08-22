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
  List<Map<String, dynamic>>? usersList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SqfLite Learn'),
      ),
      body: SingleChildScrollView(
        child: Container(
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

              // Display Data on Screen:
              Container(
                // color: Colors.amber,
                height: 250,
                child: usersList != null
                    ? buildUserList()
                    : Text('data not found'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserList() => Expanded(
          child: ListView.builder(
        itemCount: usersList?.length,
        itemBuilder: (context, index) {
          var name = usersList?[index]['name'];
          var email = usersList?[index]['email'];
          var age = usersList?[index]['age'];
          return Card(
            child: Text('UserName: $name \n Email: $email \n Age: $age'),
          );
        },
      ));

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
    usersList = await userRepo.getUsers(_database);
    await _database?.close();
  }
}
