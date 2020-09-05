import 'dart:async';
import 'dart:math';

import 'package:coruscate_demo/provider/db_provider.dart';
import 'package:coruscate_demo/provider/employee_api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _deleteData();
    _loadFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Coruscate Demo'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _creatingListView(),
      ),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _creatingListView() {
    return FutureBuilder(
      //calling method to get Data
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              int random = new Random().nextInt(20);
              return CustomListTile(
                name: snapshot.data[index].name,
                username: snapshot.data[index].username,
                timerValue: random,
              );
            },
          );
        }
      },
    );
  }
}

//Custom Widget for list items
class CustomListTile extends StatefulWidget {
  final String name;
  final String username;
  int timerValue;

  Color color = Colors.green[200];

  CustomListTile({this.name, this.username, this.timerValue});

  Timer _timer;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    widget._timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.timerValue > 0) {
          widget.timerValue -= 1;
        } else {
          timer.cancel();
          widget.color = Colors.red[200];
        }
      });
    });
    return Container(
      color: widget.color,
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name),
                SizedBox(
                  height: 5,
                ),
                Text(widget.username),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(widget.timerValue.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
