import 'package:flutter/material.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';
import '../../../models/user_model.dart';

class EditClientPopup extends StatefulWidget {
  final User client;

  EditClientPopup({required this.client});

  @override
  _EditClientPopupState createState() => _EditClientPopupState();
}

class _EditClientPopupState extends State<EditClientPopup> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController companyController;
  UserService userService= UserService();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.client.fullName);
    mobileController = TextEditingController(text: widget.client.phone);
    emailController = TextEditingController(text: widget.client.email);
    companyController = TextEditingController(text: widget.client.company);

  }


  Future<void> updateClient() async {
    if (_formKey.currentState?.validate() == false ) {
        print("form invalid ");
    }
else{
    try {
      Map<String, dynamic> updatedData = {
        'fullName': nameController.text,
        'phone': mobileController.text,
        'email': emailController.text,
        'company': companyController.text,
      };
      print("updating client");
      await userService.updateUser(widget.client.id, updatedData);

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Client updated successfully!',style:TextStyle(color: Colors.black45,fontWeight: FontWeight.w600),),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.yellowAccent,
        ),
      );

    } catch (error) {
      print('Error updating client: $error');
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
         shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
         child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Center(child: Text("Edit Client",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600,fontSize: 34),)),
                SizedBox(height: 30),
                TextFormField(
                    controller: nameController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Name*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily: AppTheme.fontName,
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
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10),
         
                TextFormField(
                    controller: mobileController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mobile*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily: AppTheme.fontName,
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
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid mobile';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10),
         
                TextFormField(
                    controller: emailController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily: AppTheme.fontName,
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
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10),
         
                TextFormField(
                    controller: companyController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Company Name*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily: AppTheme.fontName,
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
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a company name';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10),
         
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print("update pressed");
                        updateClient();
                        },
                        child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25,fontFamily: AppTheme.fontName ),),
                                     style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F7BFF),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25,fontFamily: AppTheme.fontName ),),
                                     style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
               ),
       ),
    );
  }
}
