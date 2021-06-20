import 'package:flutter/material.dart';
import './user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              user.ob(() => Text(user.age.toString())),
              user.ob(() => Text(user.name)),
              TextField(
                onChanged: (text) => user.changeName(text),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => user.add(),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
