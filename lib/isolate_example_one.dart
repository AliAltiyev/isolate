// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'extensions.dart';

import 'package:flutter/material.dart';

class IsoalteExampleOne extends StatefulWidget {
  const IsoalteExampleOne({super.key});

  @override
  State<IsoalteExampleOne> createState() => _IsoalteExampleOneState();
}

class _IsoalteExampleOneState extends State<IsoalteExampleOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () {
                  testGetMessages();
                },
                child: const Text("Get Persons"))
          ],
        ),
      ),
    );
  }
}

void testGetMessages() async {
  await for (final msg in getMessages()) {
    msg.log();
  }
}

Stream<String> getMessages() {
  final recivePort = ReceivePort();
  return Isolate.spawn(_getMessages, recivePort.sendPort)
      .asStream()
      .asyncExpand((_) => recivePort)
      .takeWhile((element) => element is String)
      .cast();
}

void _getMessages(SendPort sendPort) async {
  await for (final tick in Stream<String>.periodic(
          const Duration(seconds: 1), (_) => DateTime.now().toIso8601String())
      .take(10)) {
    sendPort.send(tick);
  }
  Isolate.exit(sendPort);
}

// Future<Iterable<Person>> getPersons() async {
//   final recivePort = ReceivePort();

//   await Isolate.spawn(_getPersons, recivePort.sendPort);

//   return await recivePort.first;
// }

// void _getPersons(SendPort sendPort) async {
//   const url = 'http://192.168.0.133:5500/apis/person.json';

//   final persons = await HttpClient()
//       .getUrl(Uri.parse(url))
//       .then((request) => request.close())
//       .then((response) => response.transform(utf8.decoder).join())
//       .then((jsonString) => json.decode(jsonString) as List<dynamic>)
//       .then((json) => json.map((map) => Person.fromMap(map)));

//   Isolate.exit(sendPort, persons);
// }

@immutable
class Person {
  final String name;
  final int age;
  const Person({
    required this.name,
    required this.age,
  });

  Person copyWith({
    String? name,
    int? age,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Person(name: $name, age: $age)';

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
