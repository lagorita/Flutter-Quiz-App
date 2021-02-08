import 'dart:io';

import 'package:denemequiz/const/const.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> copyDB() async {
  //Database path tanımlanır
  var dbPath = await getDatabasesPath();
  var path = join(dbPath, dbName);

  var exists = await databaseExists(path);
  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);

    } catch (_) {
      // Copy from assets
      ByteData data = await rootBundle.load(join("assets/db", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }
  } else {
    print("DB already exist");
  }
  return await openDatabase(path, readOnly: true);
}
