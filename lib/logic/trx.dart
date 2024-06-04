class Trx{
  String time = "";
  String name = "";
  double amount = 0.0;
  bool type;

  Trx({
    required this.name,
    required this.time,
    required this.amount,
    required this.type
  });
}