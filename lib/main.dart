import 'dart:math';

import 'package:calculator/logic/trx.dart';
import 'package:calculator/transaction.dart';
import 'package:flutter/material.dart';
import 'package:calculator/utils.dart';
import 'package:calculator/logic/TrxService.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(7, 101, 148, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> trx = [];

  TrxService ts = TrxService();

  String above_error = "";

  String add_howMuch = "";
  String add_whatIs = "";

  String sub_howMuch = "";
  String sub_whatIs = "";

  @override
  void initState() {
    _renderTransactions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (!above_error.isEmpty)
                ? Container(
                    height: 20.0, // Set the height of the line
                    color: Colors.red, // Set the background color to red
                    child: Center(
                      child: Text(
                        '$above_error', // Your text content
                        style: TextStyle(
                          fontSize: 12.0, // Adjust font size as needed
                          color:
                              Colors.white, // Text color (contrasting with red)
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 10.0),
            const Text(
              style: TextStyle(fontSize: 18.0),
              'Your current balance is:',
            ),
            Text(
              '129.234',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Container(
                margin: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "Your transactions:",
                    )),
                    Spacer(),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _export();
                        },
                        child: Text(
                          'Export to device',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            Expanded(child: ListView(children: this.trx)),
            IntrinsicHeight(
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: IconButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green)),
                                onPressed: () {
                                  _buildDialog(true);
                                },
                                icon: Icon(Icons.add))),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: IconButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 221, 74, 64))),
                                onPressed: () {
                                  _buildDialog(false);
                                },
                                icon: Icon(Icons.remove)))
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  _renderTransactions() {
    setState(() {
      this.trx = [];
    });
    ts.getAll().then((list) {
      List<Transaction> txs = [];
      for (int i = 0; i <= list.length - 1; i++) {
        txs.add(Transaction(
            name: list[i].name,
            time: list[i].time,
            amount: list[i].amount,
            isAdd: list[i].type));
      }
      setState(() {
        this.trx = txs;
      });
    });
  }

  _done(bool isAdd) {
    if (isAdd) {
      print(add_whatIs);
      print(add_howMuch);
      if (add_howMuch.isEmpty || !isFloat(add_howMuch)) {
        setState(() => {
              above_error =
                  "Transaction could not be made due to a wrong amount."
            });
        Future.delayed(Duration(seconds: 4)).then((_) {
          setState(() {
            above_error = "";
          });
        });
      } else {
        Trx t = Trx(
            name: add_whatIs,
            time: (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
            amount: double.parse(add_howMuch),
            type: true);
        ts.addNew(t);
      }
    } else {
      print(sub_whatIs);
      print(sub_howMuch);
      if (sub_howMuch.isEmpty || !isFloat(sub_howMuch)) {
        print("eeee");
        setState(() => {
              above_error =
                  "Transaction could not be made due to a wrong amount."
            });
        Future.delayed(Duration(seconds: 4)).then((_) {
          setState(() {
            above_error = "";
          });
        });
      } else {
        Trx t = Trx(
            name: sub_whatIs,
            time: (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
            amount: double.parse(sub_howMuch),
            type: false);
        ts.addNew(t);
      }
    }
  }

  _export() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exporting..'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "Exporting helps you save your transactions when you are going uninstall the app."),
              Text(
                  "The exported file will be named 'exported[date].cal' in your files.")
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Start'),
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

  _buildDialog(bool isAdd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialog w;
        (isAdd)
            ? w = AlertDialog(
                title: const Text('Adding..'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (text) {
                        add_whatIs = text;
                      },
                      decoration: InputDecoration(
                          labelText: 'Why adding it? (optional)'),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        add_howMuch = text;
                      },
                      decoration: InputDecoration(
                        labelText: 'How much?',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _done(true);
                      _renderTransactions();
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
              )
            : w = AlertDialog(
                title: const Text('Substacting..'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (text) {
                        sub_whatIs = text;
                      },
                      decoration:
                          InputDecoration(labelText: 'For what? (optional)'),
                    ),
                    TextField(
                      onChanged: (text) {
                        sub_howMuch = text;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'How much?',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _done(false);
                      _renderTransactions();
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
        return w;
      },
    );
  }
}
