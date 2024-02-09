import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../widgets/signup_requester_container.dart';

class SignUpRequests extends StatefulWidget {
  @override
  _SignUpRequestsState createState() => _SignUpRequestsState();
}

class _SignUpRequestsState extends State<SignUpRequests> {
  late Future<List<User>> futureSignUpRequests;

  @override
  void initState() {
    super.initState();
    futureSignUpRequests = UserService().getSignUpRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Requests'),
      ),
      body: FutureBuilder<List<User>>(
        future: futureSignUpRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final signUpRequests = snapshot.data!;
            return ListView.builder(
              itemCount: signUpRequests.length,
              itemBuilder: (context, index) {
                final signUpRequest = signUpRequests[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignUpRequester(
                    name: signUpRequest.fullName,
                    role: signUpRequest.roles.join(', '),
                    mobile: signUpRequest.phone,
                    email: signUpRequest.email,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
