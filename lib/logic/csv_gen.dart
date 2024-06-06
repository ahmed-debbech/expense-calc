import 'package:calculator/data/db.dart';
import 'package:calculator/logic/trx.dart';

Future<String> genCsv() async {
  String res = "";
  List<Trx> tt = await getAllDbSorted();
  res += "Name;Amount;Time\n";
  for (int i = 0; i <= tt.length - 1; i++) {
    res += tt[i].name +
        ";" +
        ((tt[i].type)
            ? tt[i].amount.toString()
            : "-" + tt[i].amount.toString()) +
        ";" +
        DateTime.fromMillisecondsSinceEpoch(int.parse(tt[i].time + "000"))
            .toIso8601String() +
        "\n";
  }
  print(res);
  return res;
}
