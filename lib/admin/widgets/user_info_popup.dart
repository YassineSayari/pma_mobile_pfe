import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pma/const.dart';
import 'package:pma/theme.dart';

import '../../models/user_model.dart';



class EmployeeInfo extends StatelessWidget {
  final User employee;


  const EmployeeInfo({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        //height: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),
              ),
              SizedBox(height: 15),
              buildInfoRow(Icons.person, "Full Name:", employee.fullName),
              buildInfoRow(Icons.people_rounded, "Role:", employee.roles[0]),
              buildInfoRow(Icons.email, "Email:", employee.email),
              buildInfoRow(Icons.local_fire_department, "Department:", employee.department ?? "N/A"),
              buildInfoRow(Icons.phone, "Phone:", employee.phone),
              buildInfoRow(Icons.calendar_month, "Hiring Date:", DateFormat('MMM dd yyyy').format(employee.hiringDate)),
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
                      fontSize: 24,
                      color: Color.fromARGB(255, 20, 91, 150),
                      fontWeight:FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
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
            color: AppTheme.buildLightTheme().primaryColor,
            size: 34,
          ),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 24,fontWeight:FontWeight.w500,fontFamily: AppTheme.fontName),
          ),
                    SizedBox(width: 10),

          Text(
            value,
            style: TextStyle(fontSize: 24,fontFamily: AppTheme.fontName),
          ),
        ],
      ),
    );
  }
}