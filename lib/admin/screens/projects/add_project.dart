import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import '../../../services/user_service.dart';
import '../../widgets/admin_drawer.dart';
class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();

  String? projectType;
  String? projectPriority;

  String? client;
  DateTime? projectStartDate;
  final TextEditingController projectStartDateController = TextEditingController();

  DateTime? projectEndDate;
  final TextEditingController projectEndDateController = TextEditingController();

  String? team;
  final MultiSelectController teamController = MultiSelectController();

  String? teamLeader;

  List<User> selectedEngineers = [];

  final TextEditingController description = TextEditingController();

  late Future<List<User>> clients;
  late Future<List<User>> engineers; 
  late Future<List<User>> teamLeaders;

  final UserService userService = GetIt.I<UserService>();
  final ProjectService projectService = GetIt.I<ProjectService>();

  @override
  void initState() {
    super.initState();
    clients = userService.getAllClients();
    engineers = userService.getAllEngineers();
    teamLeaders = userService.getAllTeamLeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: AdminDrawer(selectedRoute: '/addproject'),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomAppBar(title: "Add Project"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Project Title
                  TextFormField(
                    controller: title,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Project Title*',
                      labelStyle: TextStyle(
                        color: Color(0xFF7743DB),
                        fontSize: 20,
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
                        return 'Project title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
          
                  // Project Type and Priority
                  DropdownButtonFormField(
                    value: projectType,
                    decoration: InputDecoration(
                      labelText: 'Project Type*',
                      labelStyle: TextStyle(
                        color: Color(0xFF7743DB),
                        fontSize: 20,
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
                    items: [
                      DropdownMenuItem(child: Text('-Systems Infrastructure',style: TextStyle(fontSize:20),), value: 'Systems Infrastructure'),
                      DropdownMenuItem(child: Text('-Network Infrastructure',style: TextStyle(fontSize: 20),), value: 'Network Infrastructure'),
                      DropdownMenuItem(child: Text('-Systems And Networks Infrastructure',style: TextStyle(fontSize: 20),), value: 'Systems And Networks Infrastructure'),
                      DropdownMenuItem(child: Text('-Development',style: TextStyle(fontSize: 20),), value: 'Development'),
                    ],
                    onChanged: (selectedValue) {
                      setState(() {
                        projectType = selectedValue as String?;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Project Type is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  
                  DropdownButtonFormField(
                    value: projectPriority,
                    decoration: InputDecoration(
                      labelText: 'Project Priority*',
                      labelStyle: TextStyle(
                        color: Color(0xFF7743DB),
                        fontSize: 20,
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
                    items: [
                      DropdownMenuItem(child: Text('Low',style: TextStyle(fontSize:20),), value: 'Low'),
                      DropdownMenuItem(child: Text('Medium',style: TextStyle(fontSize:20),), value: 'Medium'),
                      DropdownMenuItem(child: Text('High',style: TextStyle(fontSize:20),), value: 'High'),
                    ],
                    onChanged: (selectedValue) {
                      setState(() {
                        projectPriority = selectedValue as String?;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Project Priority is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
          
                  // Client Dropdown
                  FutureBuilder<List<User>>(
                    future: clients,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No clients available.');
                      } else {
                        return DropdownButtonFormField(
                          value: client,
                          decoration: InputDecoration(
                            labelText: 'Client*',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 20,
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
                          items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                            return DropdownMenuItem<String>(
                              value: user.id.toString(),
                              child: Text(user.fullName,style: TextStyle(fontSize:20),),
                            );
                          }).toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              client = selectedValue as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Client is required';
                            }
                            return null;
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
          
                  // Project Dates
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            // Project Start Date
                            TextFormField(
                              onTap: () async {
          
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null && pickedDate != projectStartDate) {
                                  setState(() {
                                    projectStartDate = pickedDate;
                                    projectStartDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  });
                                }
                              },
                              controller: projectStartDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Project Start Date*',
                                labelStyle: TextStyle(
                                  color: Color(0xFF7743DB),
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
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[400],
                                ),
                              ),
                              validator: (value) {
                                if (projectStartDate == null) {
                                  return 'Project Start Date is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            // Project End Date
                            TextFormField(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                );
                                if (pickedDate != null && pickedDate != projectEndDate) {
                                  setState(() {
                                    projectEndDate = pickedDate;
                                    projectEndDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  });
                                }
                              },
                              controller: projectEndDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Project End Date*',
                                labelStyle: TextStyle(
                                  color: Color(0xFF7743DB),
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
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[400],
                                ),
                              ),
                              validator: (value) {
                                if (projectEndDate == null) {
                                  return 'Project End Date is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
          
                  Column(
                    children: [
                      FutureBuilder<List<User>>(
                        future: engineers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('No engineers available.');
                          } else {
                                
                            // padding + (length * height per option)
                            double dropdownHeight = 50.0 + (snapshot.data!.length * 50.0);
                            return MultiSelectDropDown(
                              borderColor:Colors.grey, 
                              borderWidth: 3,
                              focusedBorderWidth: 3,
                              
                              controller: teamController,
                              onOptionSelected: (options) {
                                setState(() {
                                  selectedEngineers = options
                                      .map((valueItem) => snapshot.data!
                                      .firstWhere((user) => user.fullName == valueItem.label))
                                      .toList();
                                });
                              },
                              options: snapshot.data!
                                  .map((user) => ValueItem(label: user.fullName, value: user.id.toString()))
                                  .toList(),
                              maxItems: 11,
                              hint: "Select Team",
                              hintStyle: TextStyle(fontSize:20),
                              hintFontSize: 20,
                              //disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
                              selectionType: SelectionType.multi,
                              chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                              dropdownHeight: dropdownHeight,
                              optionTextStyle: const TextStyle(fontSize: 25),
                              selectedOptionIcon: const Icon(Icons.check_circle),
                              
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      FutureBuilder<List<User>>(
                        future: teamLeaders,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('No team leaders available.');
                          } else {
                            print('team leaders: $teamLeaders');
                            return DropdownButtonFormField(
                              value: teamLeader,
                              decoration: InputDecoration(
                                labelText: 'Team Leader*',
                                labelStyle: TextStyle(
                                  color: Color(0xFF7743DB),
                                  fontSize: 20,
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
                              items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                                return DropdownMenuItem<String>(
                                  value: user.id.toString(),
                                  child: Text(user.fullName,style: TextStyle(fontSize:20),),
                                );
                              }).toList(),
                              onChanged: (selectedValue) {
                                setState(() {
                                  teamLeader = selectedValue as String?;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Team Leader is required';
                                }
                                return null;
                              },
                              
                            );
                          }
                        },
                      ),
                    ],
                  ),
          
                  SizedBox(height: 10),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print("add project button pressed");
                          addProject();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9F7BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          resetForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addProject() async {
    try {
      if (!_formKey.currentState!.validate()) {
        print("Invalid information");
      }
      print("team leader: $teamLeader , client : $client");

      List<String> equipe = selectedEngineers.map((user) => user.id).toList();

      Map<String, dynamic> projectData = {
        'Projectname': title.text,
        //'description': 'dessc sqxws',
        'description':description.text,
        'TeamLeader': teamLeader,
        'type': projectType,
        'equipe': jsonEncode(equipe),
        'client': client,
        'dateFin': projectEndDate?.toIso8601String(),
        'dateDebut': projectStartDate?.toIso8601String(),
        'priority':projectPriority,
        'status':'Pending',
      };
        print("preparing project data $projectData");
      // Extract team members' IDs

      print("equipe: $equipe");

      print("prepared project data");


      print("calling add project method from service");
      await projectService.addProject(projectData);
      Navigator.of(context).pushReplacementNamed('/allprojects');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project added successfully',style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.yellowAccent,
      ),
      );

      resetForm();
    } catch (error) {

      //Navigator.of(context).pushReplacementNamed('/allprojects');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add project. Please try again.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  void resetForm() {
    setState(() {
      title.clear();
      description.clear();
      projectPriority = null;
      projectStartDate = null;
      projectEndDate = null;
      team = null;
      teamLeader = null;
      projectType = null;
    });
  }
}
