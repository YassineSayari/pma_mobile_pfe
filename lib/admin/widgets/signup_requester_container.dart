import 'package:flutter/material.dart';

class SignUpRequester extends StatelessWidget {
  final String name;
  final String role;
  final String mobile;
  final String email;

  const SignUpRequester({
    Key? key,
    required this.name,
    required this.role,
    required this.mobile,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xff8191da),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$name - $role',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Mobile: $mobile\nEmail: $email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle approve
                    },
                    icon: Icon(Icons.check_box_outlined),
                    tooltip: 'Approve',
                    iconSize: 40,

                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      // Handle delete
                    },
                    icon: Icon(Icons.delete_outline_rounded),
                    tooltip: 'Delete',
                    iconSize: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
