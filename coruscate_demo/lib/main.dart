import 'package:coruscate_demo/provider/db_provider.dart';
import 'package:coruscate_demo/provider/employee_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
//    getData();
  }

  getData() async {
    await _loadApiData();
  }

  _loadApiData() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApi();
    await apiProvider.getAllEmployees();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  _deleteDataMethod() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();
    setState(() {
      isLoading = false;
    });

    print("Employee deleted from DB...");
  }

  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<dynamic> fetchData() async {
      final response = await http.get('https://jsonplaceholder.typicode.com/users');
      if (response.statusCode == 200) {
        print(response.body.toString());
        return Emp.fromJson(json.decode(response.body));
      } else {
        print("==>Something went wrong");
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users Data'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
//          child: FutureBuilder(
//              future: DBProvider.db.getAllEmployees(),
//              builder: (context, snapshot) {
//                if (!snapshot.hasData) {
//                  print(snapshot);
//                  return Center(child: Text('something went wrong'));
//                } else {
//                  return ListView.builder(
//                    itemCount: snapshot.data.length,
//                    itemBuilder: (context, index) {
//                      return ListTile(
//                        leading: Text(
//                          "${index + 1}",
//                        ),
//                        title: Text("${snapshot.data[index].name}"),
//                        subtitle: Text("${snapshot.data[index].address}"),
//                      );
//                    },
//                  );
//                }
//              }),
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print(snapshot);
                  return Center(child: Text('something went wrong'));
                } else {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("${snapshot.data.name}"),
//                        subtitle: Text("${snapshot.data.address[index]['street']}"),
                      );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}

class Emp {
  final int id;
  final String name;
  final List<dynamic> address;

  Emp({this.id, this.name, this.address});

  factory Emp.fromJson(Map<String, dynamic> json) {
    return Emp(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}
