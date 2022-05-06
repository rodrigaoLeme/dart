// void main(List<String> arguments) {
//   String nome;
//   String sobrenome;

//   nome = "Rodrigo";
//   sobrenome = "Leme";
//   print(retNome(nome: nome, sobrenome: sobrenome));

//   final Map<String, dynamic> map = {'name': 'Rodrigo', 'age': 30};

//   print(map['age']);
// }

// String retNome({required String nome, required String sobrenome}) {
//   return ("O nome compreto é: $nome $sobrenome");
// }

// void main() {
//   List<Student> students = [];

//   Student ralf = Student(name: 'Ralf', age: 30, lastName: 'Uilian');
//   Student eduardo = Student(name: 'Eduardo', age: 44, lastName: 'Carvalho');

//   students.add(ralf);
//   students.add(eduardo);

//   for (var student in students) {
//     print(student.name);
//   }

//   print(ralf.fullName());
// }

// class Student {
//   String name;
//   String lastName;
//   int age;

//   Student({required this.name, required this.age, required this.lastName});

//   String fullName() {
//     return '$name $lastName';
//   }
// }

// void main() {
//   final Dog animal = Dog(name: 'Cachorro');
//   print(animal.sound());
// }

// class Animal {
//   String name;

//   Animal({required this.name});

//   String sound() {
//     return '';
//   }
// }

// class Dog extends Animal {
//   Dog({required String name}) : super(name: name);

//   @override
//   String sound() {
//     return 'AU-AU';
//   }
// }

void main() {
  Carro kicks = Kicks();
  Fusca fusca = Fusca();
  print(kicks.engine());
  print(fusca.engine());
}

abstract class Carro {
  String color();
  String engine();
  String breaker();
}

class Kicks implements Carro {
  @override
  String breaker() {
    return 'ABS';
  }

  @override
  String color() {
    return 'Silver';
  }

  @override
  String engine() {
    return '1.6';
  }
}

class Fusca extends Carro {
  @override
  String breaker() {
    return 'Fé';
  }

  @override
  String color() {
    return 'Blue';
  }

  @override
  String engine() {
    return '1.2';
  }
}
