import 'package:flutter/material.dart';
import 'package:pma/custom_appbar.dart';

import '../widgets/client_drawer.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: ClientDrawer(selectedRoute: '/procesv'),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Dashboard"),
        Center(child: Text("dashboard works")),
      ],
    ),
    );
  
}
}