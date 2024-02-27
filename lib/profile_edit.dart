import 'package:flutter/material.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/user_service.dart';

const ip = "192.168.32.1";
const port = 3002;
class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  UserService userService=UserService();

    final String imageUrl = "http://$ip:$port/static/images";
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
        title: Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 45),),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Profile photo",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                    ),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){},
                                     child: Text("Change",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                                     style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F7BFF),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: (){},
             child: Text("Remove",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
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
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.all(8.0),
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
            SizedBox(height: 20),
            TextFormField(
             controller: nameController,
              keyboardType: TextInputType.text,
              style: TextStyle(
              color: Color(0xFF000000),
               fontSize: 27,
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
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
                               return 'Please enter a full name';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 20),  

            TextFormField(
             controller: cityController,
              keyboardType: TextInputType.text,
              style: TextStyle(
              color: Color(0xFF000000),
               fontSize: 27,
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
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
                               return 'Please enter a city';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 20),

            TextFormField(
             controller: phoneController,
              keyboardType: TextInputType.number,
              style: TextStyle(
              color: Color(0xFF000000),
               fontSize: 27,
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
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
                               return 'Please enter a phone number';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 20),

            TextFormField(
             controller: countryController,
              keyboardType: TextInputType.text,
              style: TextStyle(
              color: Color(0xFF000000),
               fontSize: 27,
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                labelText: 'Country',
                labelStyle: TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
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
                               return 'Please enter a country';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 20),

            TextFormField(
             controller: addressController,
              keyboardType: TextInputType.text,
              style: TextStyle(
              color: Color(0xFF000000),
               fontSize: 27,
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
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
                               return 'Please enter an adress';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 20),

            TextFormField(
             controller: nationalityController,
              keyboardType: TextInputType.text,
              style: TextStyle(
              color: Color(0xFF000000),
               fontSize: 27,
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                labelText: 'Nationality',
                labelStyle: TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
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
                               return 'Please enter a nationality';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 20),

            ElevatedButton(onPressed: (){
              updateEmployee();
            },
             child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25 ),),
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
            content: Text('Employee updated successfully!',style:TextStyle(color: Colors.black45,fontWeight: FontWeight.w600),),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.yellowAccent,
          ),
        );
      } catch (error) {
        print('Error updating employee: $error');
        ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
            content: Text('Error updating Profile',style:TextStyle(color: Colors.black45,fontWeight: FontWeight.w600),),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        ); 
      }
    }
  }
