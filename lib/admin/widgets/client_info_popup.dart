import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pma/const.dart';
import 'package:pma/theme.dart';

import '../../models/user_model.dart';



class ClientInfo extends StatelessWidget {
  final User user;


  const ClientInfo({Key? key, required this.user}) : super(key: key);



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
                  "$imageUrl/${user.image}",
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      noImageUrl,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
                  Text(
                    "Client's Details",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),
                  ),
                  SizedBox(height: 10),
                  buildInfoRow(Icons.person, "Full Name:", user.fullName),
                  //buildInfoRow(Icons.people_rounded, "Role:", user.roles[0]),
                  buildInfoRow(Icons.email, "Email:", user.email),
                  buildInfoRow(Icons.phone, "Phone:", user.phone),
                  buildInfoRow(Icons.factory_outlined, "Company Name:", user.company ?? 'N/A'),
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
    ).animate(delay: 200.ms).fade().shimmer(duration: 1000.ms);
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