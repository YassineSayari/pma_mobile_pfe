import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/user_service.dart';
// import 'package:get_it/get_it.dart';
// import 'package:pma/models/project_model.dart';
 import 'package:pma/services/project_service.dart';

class EditProject extends StatefulWidget {
  final String projectId;
  final String projectTitle;
  final String description;
  final String type;
  final String status;
  final String priority;
  final String dateFin;
  final String teamLeaderId;
  final List<dynamic> equipe;

  const EditProject({
    Key? key,
    required this.projectId,
    required this.projectTitle,
    required this.description,
    required this.type,
    required this.status,
    required this.priority,
    required this.dateFin,
     required this.teamLeaderId,
      required this.equipe,
  }) : super(key: key);

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {

    final _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();

  String? projectStatus;
  String? projectType;

  String? projectPriority;
  
  DateTime? projectEndDate;
  final TextEditingController projectEndDateController = TextEditingController();

  String? team;
  final MultiSelectController teamController = MultiSelectController();
  late Future<List<User>> engineers; 
  List<User> selectedEngineers = [];
  

  String? teamLeader;
   late Future<List<User>> teamLeaders;
  final UserService userService = GetIt.I<UserService>();
  final ProjectService projectService = GetIt.I<ProjectService>();


  final TextEditingController description = TextEditingController();


  // late ProjectService projectService;
  //  Project? project;


    Future<void> _updateProject() async {
        print("equipe::::::${widget.equipe}");
              List<String> equipe = selectedEngineers.map((user) => user.id).toList();

    try {
      Map<String, dynamic> updatedProjectData = {
        'Projectname': title.text,
        'status': projectStatus,
        'description': description.text,
        'type': projectType,
        'priority': projectPriority,
        'dateFin': DateFormat('yyyy-MM-dd').format(projectEndDate!),
        'teamLeaderId': teamLeader,
        'equipe': jsonEncode(equipe),
      };

      await projectService.updateProject(widget.projectId, updatedProjectData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project Updated successfully',style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.yellowAccent,
      ),
      );
    } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update project',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
      ),
      );
      print("Error updating project: $error");
    }
  }



  @override
  void initState() {
    super.initState();
      teamLeaders = userService.getAllTeamLeaders();
      engineers = userService.getAllEngineers();


      
    title.text = widget.projectTitle;
    projectStatus= widget.status;
    description.text=widget.description;
    projectType = widget.type;
    projectPriority = widget.priority;
    projectEndDate = DateTime.parse(widget.dateFin);
    projectEndDateController.text = DateFormat('yyyy-MM-dd').format(projectEndDate!);
  
    teamLeader!=widget.teamLeaderId;
    

    selectedEngineers = widget.equipe.map((engineerData) {

      return User(
        id: engineerData['_id'],
        fullName: engineerData['fullName'],
         phone:engineerData['phone'] ,
          email: engineerData['email'], 
          roles:List<String>.from(engineerData['roles']), 
          gender: engineerData['gender'], 
          isEnabled: true,
           experience: 0, 
           title:engineerData['title'],
            hiringDate: DateTime.parse( engineerData['hiringDate']),
      );
    }).toList();


    print("team ::::${widget.equipe}");

  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    body: ListView(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  'Edit Project',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
                ),
                centerTitle: true,
              ),
            ),
          ],
        ),
          // Text("Project title: ${widget.projectTitle}"),
          // Text("Project Name: ${widget.type}"),
          // Text("Description: ${widget.description}"),
          // Text("Status: ${widget.status}"),
          // Text("team leader:${widget.teamLeaderId}"),
            Text("equipe:${widget.equipe}"),


          Padding(padding: EdgeInsets.all(16),
          child: Form(
                  key: _formKey,

            child:Column(
              children: [
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
                  
                  DropdownButtonFormField(
                    value: projectStatus,
                    decoration: InputDecoration(
                      labelText: 'Status*',
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
                      DropdownMenuItem(child: Text('Pending',style: TextStyle(fontSize:20),), value: 'Pending'),
                      DropdownMenuItem(child: Text('In Progress',style: TextStyle(fontSize: 20),), value: 'In Progress'),
                      DropdownMenuItem(child: Text('On Hold',style: TextStyle(fontSize: 20),), value: 'On Hold'),
                      DropdownMenuItem(child: Text('Completed',style: TextStyle(fontSize: 20),), value: 'Completed'),
                    ],
                    onChanged: (selectedValue) {
                      setState(() {
                        projectStatus = selectedValue as String?;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Status is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Project Type and Priority
                  DropdownButtonFormField(
                    value: projectType,
                    decoration: InputDecoration(
                      labelText: 'Type*',
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
                      labelText: 'Priority*',
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
                            SizedBox(height: 10),
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),

                    TextFormField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Description*',
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

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (){
                              _updateProject();
                                  Navigator.of(context).pushReplacementNamed('/allprojects');
                            },
                                       child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
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
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed('/allprojects');
                        },
                                   child: Text("Cancel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                                   style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 172, 19, 19),
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


        // if (project != null) ...[
         
        //   Text("Project ID: ${project!.id}"),
        //   Text("Project Name: ${project!.projectName}"),
        //   Text("Description: ${project!.description}"),
        //   Text("Status: ${project!.status}"),

        // ] 
      ],
    ),
  );
}
}