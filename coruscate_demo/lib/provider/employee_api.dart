import 'package:coruscate_demo/models/Employee.dart';
import 'package:dio/dio.dart';

import 'db_provider.dart';

class EmployeeApiProvider {
  Future<List<Employee>> getAllEmployees() async {
    //this point is used to get records from api
    var url = "https://jsonplaceholder.typicode.com/users";
    Response response = await Dio().get(url);

    return (response.data as List).map((employee) {
//      print('Inserting $employee');
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}
