import 'package:oboe/oboe.dart';

// Definition Oboe
class User extends Oboe {
  String name = "dog";
  int age = 0;

  changeName(String nextName) {
    name = nextName;
    next();
  }

  add() {
    age += 1;
    next();
  }
}

// Instance, use some widgets
var user = User();
