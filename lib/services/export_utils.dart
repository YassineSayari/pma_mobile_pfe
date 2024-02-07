import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


import '../models/user_model.dart';

class ExportEmployees {

  Future<void> generateEmployeesTextFile(List<User> employees) async {
    final fileContent = "Name\tRoles\tGender\tMobile\tEmail\n" +
        employees.map((user) {
          return "${user.fullName}\t${user.roles.join(', ')}\t${user.gender}\t${user.phone}\t${user.email}";
        }).join('\n');

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/employees.txt';

    print('file content : $fileContent');
    print('file path: $filePath');

    final file = File(filePath);
    await file.writeAsString(fileContent);

  }

  Future<String> generateEmployeesCsvFile(List<User> employees) async {
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
    print("saving as csv file");

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/employees.csv';
    final file = File(filePath);
    await file.writeAsString(ListToCsvConverter().convert(csvData));

    print("csv file: $csvData");
    print("file saved to $filePath");

    return filePath;

  }

  Future<String> generateEmployeesXlsxFile(List<User> employees) async {
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

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/employees.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes!);

    return filePath;

  }

  Future<String> generateEmployeesJsonFile(List<User> employees) async {
    List<Map<String, dynamic>> jsonData = employees.map((user) {
      return {
        'Name': user.fullName,
        'Roles': user.roles,
        'Gender': user.gender,
        'Mobile': user.phone,
        'Email': user.email,
      };
    }).toList();
    print("saving as json file");

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/employees.json';
    final file = File(filePath);
    await file.writeAsString(jsonEncode(jsonData));

    print("json file content: $jsonData");
    print("json file path: $filePath");

    return filePath;
  }



}