import 'package:calculator/logic/TrxService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Transaction extends StatefulWidget {
  late final String time;
  late final String name;
  late final double amount;
  late final bool isAdd;
  final VoidCallback onPop;

  Transaction(
      {super.key,
      required this.name,
      required this.time,
      required this.amount,
      required this.isAdd,
      required this.onPop});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  late BuildContext parentContext;

  TrxService ts = TrxService();

  String amount_t = "";

  String name_t = "";

  bool isAdd_t = false;

  @override
  Widget build(BuildContext context) {
    this.parentContext = context;

    return GestureDetector(
        onLongPress: () {
          print('Card long pressed!');
          _menu();
        },
        child: Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color.fromARGB(255, 242, 240, 240),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            "${this.widget.name}")),
                    (widget.isAdd)
                        ? Expanded(
                            child: Text(
                                style: TextStyle(color: Colors.green),
                                "+${this.widget.amount}"))
                        : Expanded(
                            child: Text(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 221, 74, 64),
                                    fontWeight: FontWeight.bold),
                                "-${this.widget.amount}")),
                    Expanded(
                        child: Text(
                            style: TextStyle(fontSize: 12.0),
                            "${timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(this.widget.time + "000")), locale: 'en')}")),
                  ])
                ]))));
  }

  _popEdit() {                                                                                                      
    this.name_t = this.widget.name;
    this.amount_t = this.widget.amount.toString();
    this.isAdd_t = widget.isAdd;

    showDialog(
      context: this.parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editing transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "made on: ${DateFormat('dd MMMM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(this.widget.time + "000")))}"),
              TextField(
                onChanged: (text) {
                  setState((){this.name_t = text;});
                },
                controller: TextEditingController(text: '${this.widget.name}'),
                decoration: InputDecoration(labelText: 'For what? (optional)'),
              ),
              TextField(
                onChanged: (text) {
                  setState((){this.amount_t = text;});
                },
                controller: TextEditingController(text: '${this.widget.amount}'),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'How much?',
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _edit();
                widget.onPop();
              },
              child: const Text('Done'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  _edit() {
    ts.editTrx(this.widget.time, this.name_t, double.parse(amount_t), this.widget.isAdd);
  }
  _delete(){
    ts.delete(this.widget.time);
  }
  _menu() {
    showDialog(
      context: this.parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _popEdit();
                },
                child: Text(' Edit '),
              ),
              SizedBox(height: 8), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _delete();
                  widget.onPop();
                },
                child: Text('Delete'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
