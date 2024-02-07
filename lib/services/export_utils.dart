import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

import '../models/user_model.dart';

class ExportEmployees {

  void  generateEmployeesTextTable(List<User> employees) {
    print ("exporting");
    String file= "Name\tRoles\tGender\tMobile\tEmail\n" +
        employees.map((user) {
          return "${user.fullName}\t${user.roles.join(', ')}\t${user
              .gender}\t${user.phone}\t${user.email}";
        }).join('\n');

    Share.share(file);

  }

  String generateEmployeesCsvTable(List<User> employees) {
    List<List<dynamic>> csvData = [
      ['Name', 'Roles', 'Gender', 'Mobile', 'Email'],
      ...employees.map((user) =>
      [
        user.fullName,
        user.roles.join(', '),
        user.gender,
        user.phone,
        user.email,
      ])
    ];

    return ListToCsvConverter().convert(csvData);
  }

  Future<String> generateEmployeesXlsxTable(List<User> employees) async {
    var excel = Excel.createExcel();
    var sheet = excel['Employees'];


    for (User user in employees) {
      sheet.appendRow([
        TextCellValue(user.fullName),
        TextCellValue(user.roles.join(', ')),
        TextCellValue(user.gender),
        TextCellValue(user.phone),
        TextCellValue(user.email),
      ]);
    }
    var bytes = excel.encode();

    return "sahit";

  }

  String generateEmployeesJsonTable(List<User> employees) {
    List<Map<String, dynamic>> jsonData = employees.map((user) {
      return {
        'Name': user.fullName,
        'Roles': user.roles,
        'Gender': user.gender,
        'Mobile': user.phone,
        'Email': user.email,
      };
    }).toList();

    return jsonEncode(jsonData);
  }

  void shareTable(String format, List<User> employees) {
    String tableText;

    switch (format) {
      case 'text':
    //    tableText = generateEmployeesTextTable(employees);
        break;
      case 'csv':
        tableText = generateEmployeesCsvTable(employees);
        break;
      case 'xlsx':
        generateEmployeesXlsxTable(employees);
        return;
      case 'json':
        tableText = generateEmployeesJsonTable(employees);
        break;
      default:
       // tableText = generateEmployeesTextTable(employees);
    }

  }

}