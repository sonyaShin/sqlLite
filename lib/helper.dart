import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dogs.dart';

class DBHelper {
  //this is to initialize the SQLite database
  //Database is from sqflite package
  //as well as getDatabasesPath()
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'dogs.db');
    //this is to create database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //build _onCreate function
  static Future _onCreate(Database db, int version) async {
    //this is to create table into database
    //and the command is same as SQL statement
    //you must use ''' and ''', for open and close
    final sql = '''CREATE TABLE dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    );''';
    //sqflite is only support num, string, and unit8List format
    //please refer to package doc for more details
    await db.execute(sql);
  }

  //build create function (insert)
  static Future<int> createDogLists(Dog contact) async {
    Database db = await DBHelper.initDB();
    //create contact using insert()
    return await db.insert('dogs', contact.toJson());
  }

  //build read function
  static Future<List<Dog>> readDogLists() async {
    Database db = await DBHelper.initDB();
    var dog = await db.query('dogs', orderBy: 'name');
    //this is to list out the contact list from database
    //if empty, then return empty []
    List<Dog> dogList = dog.isNotEmpty
        ? dog.map((details) => Dog.fromJson(details)).toList()
        : [];
    return dogList;
  }

  //build update function
  static Future<int> updateDogLists(Dog contact) async {
    Database db = await DBHelper.initDB();
    //update the existing contact
    //according to its id
    return await db.update('dogs', contact.toJson(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  //build delete function
  static Future<int> deleteDogLists(int id) async {
    Database db = await DBHelper.initDB();
    //delete existing contact
    //according to its id
    return await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
}
