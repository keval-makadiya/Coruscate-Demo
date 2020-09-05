import 'dart:convert';

class Employee {
  int id;
  String name;
  String address;

  Employee({this.id, this.name, this.address});

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json['name'],
        address: json['address']['street'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
      };
}
