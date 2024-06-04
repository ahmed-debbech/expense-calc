import 'package:calculator/logic/TrxService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Transaction extends StatelessWidget {
  late final String time;
  late final String name;
  late final double amount;
  late final bool isAdd;
  late BuildContext parentContext;

  TrxService ts = TrxService();

  String amount_t = "";
  String name_t = "";
  bool isAdd_t = false;

  Transaction(
      {super.key,
      required this.name,
      required this.time,
      required this.amount,
      required this.isAdd});

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
                            "${this.name}")),
                    (isAdd)
                        ? Expanded(
                            child: Text(
                                style: TextStyle(color: Colors.green),
                                "+${this.amount}"))
                        : Expanded(
                            child: Text(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 221, 74, 64),
                                    fontWeight: FontWeight.bold),
                                "-${this.amount}")),
                    Expanded(
                        child: Text(
                            style: TextStyle(fontSize: 12.0),
                            "${timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(this.time + "000")), locale: 'en')}")),
                  ])
                ]))));
  }

  _popEdit() {
    this.name_t = this.name;
    this.amount_t = this.amount.toString();
    this.isAdd_t = isAdd;

    showDialog(
      context: this.parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editing transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "made on: ${DateFormat('dd MMMM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(this.time + "000")))}"),
              TextField(
                onChanged: (text) {
                  this.name_t = text;
                },
                controller: TextEditingController(text: '${this.name}'),
                decoration: InputDecoration(labelText: 'For what? (optional)'),
              ),
              TextField(
                onChanged: (text) {
                  this.amount_t = text;
                },
                controller: TextEditingController(text: '${this.amount}'),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'How much?',
                ),
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    style: TextStyle(color: Color.fromARGB(255, 221, 74, 64)),
                    "Sub"),
                SizedBox(
                  width: 5,
                ),
                Switch(
                  value: this.isAdd_t,
                  onChanged: (bool newValue) {
                    this.isAdd_t = newValue;
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                Text(style: TextStyle(color: Colors.green), "Add")
              ])
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _edit();
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
    ts.editTrx(this.time, this.name_t, double.parse(amount_t), this.isAdd);
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
                  Navigator.of(context).pop(); // Close the dialog
                  // Do something when second button is pressed
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
