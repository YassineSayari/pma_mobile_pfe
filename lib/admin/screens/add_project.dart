import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/models/user_model.dart';
import '../../services/user_service.dart';
import '../widgets/admin_drawer.dart';
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
  late Future<List<User>> engineers; // Add this line
  late Future<List<User>> teamLeaders;

  final UserService userService = GetIt.I<UserService>();

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
      appBar: AppBar(
        title: Text('Add Projects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
      ),
      drawer: AdminDrawer(selectedRoute: '/addproject'),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Project Title
            TextFormField(
              controller: title,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 27,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Project Title*',
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
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: projectType,
                    decoration: InputDecoration(
                      labelText: 'Project Type*',
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
                    ),
                    items: [
                      DropdownMenuItem(child: Text('Systems Infrastructure',style: TextStyle(fontSize: 10),), value: 'Systems Infrastructure'),
                      DropdownMenuItem(child: Text('Network Infrastructure',style: TextStyle(fontSize: 10),), value: 'Network Infrastructure'),
                      DropdownMenuItem(child: Text('Systems And Networks Infrastructure',style: TextStyle(fontSize: 10),), value: 'Systems And Networks Infrastructure'),
                      DropdownMenuItem(child: Text('Development',style: TextStyle(fontSize: 10),), value: 'Development'),
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
                ),
                SizedBox(width: 5),

                Expanded(
                  child: DropdownButtonFormField(
                    value: projectPriority,
                    decoration: InputDecoration(
                      labelText: 'Project Priority*',
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
                    ),
                    items: [
                      DropdownMenuItem(child: Text('Low'), value: 'Low'),
                      DropdownMenuItem(child: Text('Medium'), value: 'Medium'),
                      DropdownMenuItem(child: Text('High'), value: 'High'),
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
                ),
              ],
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
                    items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                      return DropdownMenuItem<String>(
                        value: user.fullName,
                        child: Text(user.fullName),
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
                          DateTime today = DateTime.now();
                          DateTime eighteenYearsAgo = today.subtract(Duration(days: 18 * 365));
                          DateTime sixtyYearsAgo = today.subtract(Duration(days: 60 * 365));

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: today,
                            firstDate: sixtyYearsAgo,
                            lastDate: eighteenYearsAgo,
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
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
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


            Row(
              children: [
                Expanded(
                  child: Column(
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
                              //disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
                              selectionType: SelectionType.multi,
                              chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                              dropdownHeight: dropdownHeight,
                              optionTextStyle: const TextStyle(fontSize: 16),
                              selectedOptionIcon: const Icon(Icons.check_circle),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
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
                              items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                                return DropdownMenuItem<String>(
                                  value: user.fullName,
                                  child: Text(user.fullName),
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
                ),
              ],
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                    }
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
    );
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
