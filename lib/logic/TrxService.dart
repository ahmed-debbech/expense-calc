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

  void editTrx(String time, String name, double amount, bool isAdd) async {
    Trx x = Trx(name: name, time: time, amount: amount, type: isAdd);
    await editTrxDB(time, x);
  }

  void delete(String time) async {
    await deleteDb(time);
  }

  Future<double> balanceIt() async{
    double b = 0;
    List<Trx> tt = await getAllDbSorted();
    if(tt.length == 0) return 0;
    
    for(int j=0; j<=tt.length-1; j++){
      if(tt[j].type)
        b = b + tt[j].amount;
      if(!tt[j].type)
        b = b - tt[j].amount;
    }
    return b;
  }
}
