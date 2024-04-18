import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/const.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

import 'edit_profile_photo.dart';


class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  UserService userService=UserService();

  
    final TextEditingController nameController=TextEditingController();
    final TextEditingController cityController=TextEditingController();
    final TextEditingController phoneController=TextEditingController();
    final TextEditingController countryController=TextEditingController();
    final TextEditingController addressController=TextEditingController();
    final TextEditingController nationalityController=TextEditingController();


      @override
  void initState() {
    nameController.text = widget.user.fullName;
    cityController.text = widget.user.fullName;
    phoneController.text = widget.user.phone;
    countryController.text = widget.user.fullName;


    //extract city, country from address (address:country,city,address)
    List<String> addressParts = widget.user.address?.split(',') ?? ['', '', ''];
    
    countryController.text = addressParts.length > 0 ? addressParts[0] : '';
    cityController.text = addressParts.length > 1 ? addressParts[1] : '';
    addressController.text = widget.user.address?? '';
    nationalityController.text = widget.user.nationality?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 45.sp,fontFamily: AppTheme.fontName),),
        centerTitle: true,
      ),

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical:8.h),
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Profile photo",style: TextStyle(fontSize: 30.sp,fontFamily: AppTheme.fontName,fontWeight: FontWeight.bold),
                    ),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            print("change pressed");
                             showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditProfileImageDialog(idUser: widget.user.id);
                                  },
                                );
                                },
                                child: Text("Change",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12.5.sp,fontFamily: AppTheme.fontName),),
                                style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F7BFF),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                    SizedBox(width: 10.h),
                    ElevatedButton(
                      onPressed: (){},
             child: Text("Remove",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12.5.sp,fontFamily: AppTheme.fontName),),
             style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 172, 19, 19),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
                      ],
                    ),
                    
                  ],
                ),
                Spacer(),
                    Container(
                      width: 100.w,
                      height: 100.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                    decoration:    BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              '$imageUrl/${widget.user.image}')
                              ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.h),
            TextFormField(
             controller: nameController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a full name';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10.h),  

            TextFormField(
             controller: cityController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'City'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a city';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10.h),

            TextFormField(
             controller: phoneController,
              keyboardType: TextInputType.number,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Phone'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a phone number';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10.h),

            TextFormField(
             controller: countryController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Country'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a country';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10.h),

            TextFormField(
             controller: addressController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Address'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter an adress';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10.h),

            TextFormField(
             controller: nationalityController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Nationality'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a nationality';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10.h),

            ElevatedButton(onPressed: (){
              updateEmployee();
            },
             child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily: AppTheme.fontName, ),),
             style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9F7BFF),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                  ),
                   minimumSize: Size(double.infinity, 60),
                ),
                          
             ),
          ],
        ),
      ),
    );
  }

    Future<void> updateEmployee() async {

      String updatedAddress = '${countryController.text},${cityController.text},${addressController.text}';

      try {
        Map<String, dynamic> updatedData = {
          'fullName': nameController.text,
          'phone': phoneController.text,
          'address': updatedAddress,
          'nationality': nationalityController.text,

        };

        print("updating employee");
        await userService.updateUser(widget.user.id, updatedData);
        Navigator.of(context).pushReplacementNamed('/profile');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SuccessSnackBar(message: "Profile updated successfully!"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      } catch (error) {
        print('Error updating employee: $error');
        ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
            content: FailSnackBar(message: "Failed to update profile, please try again"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ); 
      }
    }
  }
