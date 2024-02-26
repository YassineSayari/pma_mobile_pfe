import 'package:flutter/material.dart';
import 'package:pma/models/user_model.dart';

const ip = "192.168.32.1";
const port = 3002;

class ProfileContainer extends StatelessWidget {
  final User user;
  final String imageUrl = "http://$ip:$port/static/images";
  final String noImageUrl ="http://$ip:$port/static/images/16-02-2024--no-image.jpg";
        

  ProfileContainer({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:20.0,left:20.0,bottom:20.0),
      child: Container(

        child: Stack(
          children: [
            Expanded(
              child:ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "$imageUrl/${user.image}",
                      width: double.infinity,
                      height: 350.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImageUrl,
                         width: double.infinity,
                        height: 350.0,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
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
          ],
        ),
      ),
    );
  }
}
