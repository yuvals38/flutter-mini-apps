import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'person.dart';
import 'package:sqflite/sqflite.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._();

  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "person.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Person ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "latitude REAL,"
          "longitude REAL,"
          "times TEXT,"
          "visible INTEGER,"
          "counter INTEGER" 
          ")");
    });
  }

  addPersonToDatabase(Person person) async {
    final db = await database;
    var raw = await db.insert(
      "Person",
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updatePerson(Person person) async {
    final db = await database;
    var response = await db.update("Person", person.toMap(),
        where: "id = ?", whereArgs: [person.id]);
    return response;
  }

  Future<Person> getPersonbyLatestDate() async {
    final db = await database;
    final sql = '''Select *,max(counter) from Person where visible = true''';
    var response = await db.rawQuery(sql);
    return response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

  Future<Person> getPersonWithId(int id) async {
    final db = await database;
    var response = await db.query("Person", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

  Future<Person> getPersonWithName(String name) async {
    final db = await database;
    var response = await db.query("Person", where: "name = ?", whereArgs: [name]);
    return response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

 
  Future<List> getAllPersonsList() async {
    final db = await database;
    var response = await db.query("Person",columns: ["id", "name", "latitude", "longitude","times","visible","counter"]);
    return response.toList();
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    var response = await db.query("Person");
    List<Person> list = response.map((c) => Person.fromMap(c)).toList();
    return list;
  }

  deletePersonWithId(int id) async {
    final db = await database;
    return db.delete("Person", where: "id = ?", whereArgs: [id]);
  }

  deleteAllPersons() async {
    final db = await database;
    db.delete("Person");
  }

  Future<Person> getLastId() async{
    final db = await database;
    final sql = '''Select max(id),id,name,latitude,longitude,times,visible,counter from Person''';
    var response = await db.rawQuery(sql);
    
    return  response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

  updatePersonwithVisiblity(int id) async {
    try{
    final db = await database;
    final sql = "update Person set visible = 0 where id =" + id.toString() ;//where counter = (select max(counter) from Person)";
    var response = await db.rawUpdate(sql);
    //var response = await db.update("Person", person.toMap(),
    //    where: "id = ?", whereArgs: [person.id]);
    return response;
    }
    catch(e)
    {
      //log
    }
  }
}