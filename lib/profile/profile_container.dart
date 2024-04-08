import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/const.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/profile/profile_edit.dart';
import 'package:pma/theme.dart';

import '../services/user_service.dart';



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
                    style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),
                  ),
          Expanded(
            flex: 6,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                  Information(user: user),
                  SecuritySettings(userId: user.id,userEmail: user.email,context: context),
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
                padding:EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0.r),
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
                  style: TextStyle(fontSize: 35.sp,fontWeight: FontWeight.bold,fontFamily: AppTheme.fontName),
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
                       size: 30.sp,
                       color: Color.fromARGB(255, 102, 31, 184),
                    ),
                  ),                  
                ],
              ),

                Row(   
                children: [
                  Icon(Icons.home_outlined,size: 30.sp,),
                  Flexible(
                    child: Text(
                      " ${user.address}",
                      style: TextStyle(fontSize: 25.sp,fontFamily: AppTheme.fontName),
                      
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.location_pin,size: 30.sp),
                  Text(
                    "Nationality : ${user.nationality}",
                      style: TextStyle(fontSize: 25.sp,fontFamily: AppTheme.fontName),  
                    ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.email_outlined,size: 30.sp),
                  Text(
                    " ${user.email}",
                    style: TextStyle(fontSize: 25.sp,fontFamily: AppTheme.fontName),
                    
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone,size: 30.sp,),
                  Text(
                    " ${user.phone}",
                    style: TextStyle(fontSize: 25.sp,fontFamily: AppTheme.fontName),
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
  final String userEmail;
  final BuildContext context;
   SecuritySettings({super.key, required this.userId, required this.context, required this.userEmail});

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
      changePassword(userId,userEmail, newpw);
    }
   }

    Future<void> changePassword(String userId,String userEmail, String newPassword) async {
    try {
      await UserService().changePassword(userId,userEmail, newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SuccessSnackBar(message: "Password changed successfully"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
      print("password changed");
    } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FailSnackBar(message: "Failed to change password, please try again"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                        Text("Change Password",style: TextStyle(fontSize: 35.sp,fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),),
                          TextFormField(
                            controller: oldpassword,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Current Password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                           SizedBox(height: 16.h),
                          TextFormField(
                            controller: newpassword,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'New Password'),
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
                            style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Re-Enter new password'),
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
             
                child: Text('Change Password',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily: AppTheme.fontName ),),
                                     style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F7BFF),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                ),
              
            ],
      
      ),
    );
  }
}


class _TopPortion extends StatelessWidget {
   final User user;
  final String imageUrl = "$baseUrl/static/images";
  
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
          child: Container(
            width: 200.w,
            height: 200.h,
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
