import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pma/const.dart';

import '../../models/user_model.dart';



class EmployeeInfo extends StatelessWidget {
  final User employee;


  const EmployeeInfo({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 8.0,
      content: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      "$imageUrl/${employee.image}",
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImageUrl,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Employee's Details",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  buildInfoRow(Icons.person, "Full Name:", employee.fullName),
                  buildInfoRow(Icons.people_rounded, "Role:", employee.roles[0]),
                  buildInfoRow(Icons.email, "Email:", employee.email),
                  buildInfoRow(Icons.local_fire_department, "Department:", employee.department??"N/A"),                  
                  buildInfoRow(Icons.phone, "Phone:", employee.phone),
                  buildInfoRow(Icons.calendar_month, "Hiring Date:",  DateFormat('MMM dd yyyy').format(employee.hiringDate)),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 20, 91, 150),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color.fromARGB(255, 20, 91, 150),
          ),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
