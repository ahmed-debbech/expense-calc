import 'package:calculator/logic/trx.dart';
import 'package:calculator/data/db.dart';
import 'dart:core';
import 'dart:async';

class TrxService {
  Future<List<Trx>> getAll() async {
    List<Trx> tt = await getAllDbSorted();
    return tt;
  }

  void addNew(Trx x) {
    add(x);
  }

  void editTrx(String time, String name, double amount, bool isAdd) {}
}
