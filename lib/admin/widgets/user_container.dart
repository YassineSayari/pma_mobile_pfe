import 'package:flutter/material.dart';
import 'package:pma/admin/screens/employees/edit_employee_popup.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/admin/widgets/user_info_popup.dart';

const ip = "192.168.0.17";
const port = 3002;

class UserContainer extends StatelessWidget {
  final User user;
  final String imageUrl = "http://$ip:$port/static/images";
  final String noImageUrl ="http://$ip:$port/static/images/16-02-2024--no-image.jpg";
        
  final Function(String) onDelete;

  UserContainer({required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:20.0,left:20.0,bottom:20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "$imageUrl/${user.image}",
                      width: 90.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImageUrl,
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        user.roles[0],
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                      ),
                      Text(
                        user.phone,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12.0,
              right: 12.0,
              child: GestureDetector(
                      onTap: () {
                      print("info clicked");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                        return EmployeeInfo(employee: user);
                         },
                      );
                    },
                child: Icon(
                  Icons.info_outline,
                  size: 27,
                  color: Color.fromARGB(255, 102, 31, 184),
                ),
              ),
            ),

            Positioned(
              bottom: 12.0,
              right: 12.0,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                        return EditEmployeePopup(employee: user);
                         },
                      );
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      size: 27,
                      color: Color.fromARGB(255, 102, 31, 184),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => onDelete(user.id),
                    child: Icon(
                      Icons.delete_outline,
                      size: 27,
                      color: Color.fromARGB(255, 188, 14, 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
