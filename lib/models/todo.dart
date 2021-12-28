// To parse this JSON data, do
//
//     final todo = todoFromMap(jsonString);

import 'dart:convert';

Todo todoFromMap(String str) => Todo.fromMap(json.decode(str));

String todoToMap(Todo data) => json.encode(data.toMap());

class Todo {
  Todo({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  Datum(
      {required this.id,
      required this.title,
      required this.body,
      required this.endDate,
      required this.status});

  String id;
  String title;
  String body;
  String endDate;
  bool status;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
      id: json["_id"],
      title: json["title"],
      body: json["body"],
      endDate: json["date_time"],
      status: json["status"]);

  Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "body": body,
        "endDate": endDate,
        "status": status
      };
}
