import 'package:flutter/material.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/profile_edit.dart';

import 'services/user_service.dart';

const ip = "192.168.32.1";
const port = 3002;

class ProfileContainer extends StatelessWidget {
  final User user;

  ProfileContainer({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion(user: user)),
                            Text(
                    "${user.fullName}",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                  ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                  const SizedBox(height: 16),
                  Information(user: user),
                  SecuritySettings(userId: user.id,context: context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Information extends StatelessWidget {
  final User user;
  const Information({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
                padding:EdgeInsets.all(12.0),

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
      child:  Column(  
             children: [
              Row(
                children: [
                  
                  Text("Info",
                  style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),
                  ),
                  Spacer(),

                  GestureDetector(
                    onTap: (){
                       Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(user: user),
      ),
    );
                    },
                    child: Icon(
                       Icons.edit_outlined,
                       size: 35,
                       color: Color.fromARGB(255, 102, 31, 184),
                    ),
                  ),                  
                ],
              ),

                Row(   
                children: [
                  Icon(Icons.home_outlined,size: 35,),
                  Text(
                    " ${user.address}",
                    style: TextStyle(fontSize: 25),
                    
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    "Nationality : ${user.nationality}",
                      style: TextStyle(fontSize: 25),  
                    ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.email_outlined,size: 35,),
                  Text(
                    " ${user.email}",
                    style: TextStyle(fontSize: 25),
                    
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone,size: 35,),
                  Text(
                    " ${user.phone}",
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
             ],
            ),
            
    );
  }
}

class SecuritySettings extends StatelessWidget {
    final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmnewpassword = TextEditingController();
  final String userId;
  final BuildContext context;
   SecuritySettings({super.key, required this.userId, required this.context});

   void verifier(){
    if(oldpassword.text.isEmpty)
    {
      print("wtf");
      
    }
    else if(newpassword.text!=confirmnewpassword.text)
    {
      print("passwords have to mach");
    }
    else{
      String newpw;
      newpw=newpassword.text.toString();
      print("valid========Changing password to $newpw");
      changePassword(userId, newpw);
    }
   }

    Future<void> changePassword(String userId, String newPassword) async {
    try {
      await UserService().changePassword(userId, newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password changed successfully!', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.yellowAccent,
      ),
    );
      print("password changed");
    } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to change password', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
      print('Error changing password: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 27),
      child: Column(
        children: [
                        Text("Change Password",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                          TextFormField(
                            controller: oldpassword,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Current Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF755DC1),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                           SizedBox(height: 16),
                          TextFormField(
                            controller: newpassword,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF755DC1),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              return null;
                            },
                          ),
                           SizedBox(height: 16),
                          TextFormField(
                            controller: confirmnewpassword,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF755DC1),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm new password';
                              }
                              return null;
                            },
                          ),
                           SizedBox(height: 16),
      
              ElevatedButton(
                onPressed: () {
                  print("change password pressed, changing password for user ${userId}");
                  verifier();
                },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9F7BFF),
                    ),
                child: Text('Change Password',
                style: TextStyle(color: Colors.white),
                ),
              ),
            ],
      
      ),
    );
  }
}


class _TopPortion extends StatelessWidget {
   final User user;
  final String imageUrl = "http://$ip:$port/static/images";
  
  const _TopPortion({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 90),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration:    BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '$imageUrl/${user.image}')
                            ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:pma/models/user_model.dart';

// const ip = "192.168.32.1";
// const port = 3002;

// class ProfileContainer extends StatelessWidget {
//   final User user;
//   final String imageUrl = "http://$ip:$port/static/images";
//   final String noImageUrl = "http://$ip:$port/static/images/16-02-2024--no-image.jpg";

//   ProfileContainer({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, 
//         children: [
//           Container(
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8.0),
//                 topRight: Radius.circular(8.0),
//               ),
//               child: Image.network(
//                 "$imageUrl/${user.image}",
//                 width: double.infinity,
//                 height: 300.0,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Image.network(
//                     noImageUrl,
//                     width: double.infinity,
//                     height: 350.0,
//                     fit: BoxFit.cover,
//                   );
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Column(
//             children: [
//               Center(
//                 child: Text(
//                   user.fullName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 50,
//                   ),
//                 ),
//               ),
//               Text(
//                 user.roles[0],
//                 style: TextStyle(fontSize: 25, color: Colors.grey[500]),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [


//                 Row(  
//                 children: [
//                   Icon(Icons.home_outlined),
//                   Text(
//                     " ${user.address}",
//                     style: TextStyle(fontSize: 25),
                    
//                   ),
//                 ],
//               ),

//               Text(
//                 "Nationality : ${user.nationality}",
//                   style: TextStyle(fontSize: 25),  
//                 ),
             

//               Row(
//                 children: [
//                   Icon(Icons.email_outlined),
//                   Text(
//                     " ${user.email}",
//                     style: TextStyle(fontSize: 25),
                    
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.phone),
//                   Text(
//                     " ${user.phone}",
//                     style: TextStyle(fontSize: 25),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
