import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pma/admin/screens/employees/edit_employee_popup.dart';
import 'package:pma/const.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/admin/widgets/user_info_popup.dart';
import 'package:pma/theme.dart';



class UserContainer extends StatelessWidget {
  final User user;

        
  final Function(String) onDelete;

  UserContainer({required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:20.0,left:20.0,bottom:20.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 2,
              offset: Offset(0, 2),
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
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImageUrl,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.fill,
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
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                          fontFamily: AppTheme.fontName,
                          
                        ),
                      ),
                      Text(
                        user.roles[0],
                        style: TextStyle(fontSize: 24, color: Colors.grey[600],fontFamily: AppTheme.fontName),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 24, color: Colors.grey[600],fontFamily: AppTheme.fontName),
                      ),
                      Text(
                        user.phone,
                        style: TextStyle(fontSize: 24, color: Colors.grey[600],fontFamily: AppTheme.fontName),
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
                  size: 34,
                  color: Color.fromARGB(255, 102, 31, 184),
                ),
              ),
            ),

            Positioned(
              bottom: 6.0,
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
                      size: 34,
                      color: Color.fromARGB(255, 102, 31, 184),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => onDelete(user.id),
                    child: Icon(
                      Icons.delete_outline,
                      size: 34,
                      color: Color.fromARGB(255, 188, 14, 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: 100.ms).slideX().shimmer(duration: 1500.ms),
    );
  }
}
