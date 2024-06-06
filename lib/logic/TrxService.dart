import 'dart:io';

import 'package:calculator/logic/csv_gen.dart';
import 'package:calculator/logic/trx.dart';
import 'package:calculator/data/db.dart';
import 'dart:core';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TrxService {
  Future<List<Trx>> getAll() async {
    List<Trx> tt = await getAllDbSorted();
    return tt;
  }

  void addNew(Trx x) {
    add(x);
  }

  void editTrx(String time, String name, double amount, bool isAdd) async {
    Trx x = Trx(name: name, time: time, amount: amount, type: isAdd);
    await editTrxDB(time, x);
  }

  void delete(String time) async {
    await deleteDb(time);
  }

  Future<double> balanceIt() async {
    double b = 0;
    List<Trx> tt = await getAllDbSorted();
    if (tt.isEmpty) return 0;

    for (int j = 0; j <= tt.length - 1; j++) {
      if (tt[j].type) {
        b = b + tt[j].amount;
      }
      if (!tt[j].type) {
        b = b - tt[j].amount;
      }
    }
    print(b);
    return b;
  }

  Future<bool> export() async {
    bool done = false;
    print("exporting...");
    List<Trx> tt = await getAllDbSorted();
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final directory = await getExternalStorageDirectory();
        String newPath = '';
        List<String> folders = directory!.path.split('/');
        for (int i = 1; i < folders.length; i++) {
          String folder = folders[i];
          if (folder.isNotEmpty) {
            newPath += '/' + folder;
            Directory dir = Directory(newPath);
            if (!await dir.exists()) {
              await dir.create();
            }
          }
        }
        final filePath =
            '${directory!.path}/exported-${DateTime.now().toIso8601String()}.csv';
        final file = File(filePath);
        Future<String> csv = genCsv();
        csv.then((value) async => {
              await file.writeAsString(value),
              print('File saved at: $filePath'),
            });
      } else {
        print('Permission denied');
      }
    } catch (e) {
      print('Error saving file: $e');
    }
    return done;
  }
}
