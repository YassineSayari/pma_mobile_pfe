import 'package:flutter/material.dart';

import '../../models/user_model.dart';

const ip = "192.168.0.17";
const port = 3002;

class ClientInfo extends StatelessWidget {
  final User user;
  final String imageUrl = "http://$ip:$port/static/images";
  final String noImageUrl = "http://$ip:$port/static/images/16-02-2024--no-image.jpg";

  const ClientInfo({Key? key, required this.user}) : super(key: key);

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
                      "$imageUrl/${user.image}",
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
                    "Client's Details",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
