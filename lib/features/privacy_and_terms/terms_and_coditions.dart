import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../drawer.dart';

class TermsAndCoditions extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms of Service",
                  style: Theme.of(context).textTheme.displayMedium
              ),
              SizedBox(height: 20),
              Text(
                "By using this app, you agree to the following terms and conditions. The app is provided to help connect drivers with customers for ride services. You must adhere to the following rules when using the app...",
                  style: Theme.of(context).textTheme.displayMedium
              ),
              SizedBox(height: 10),
              Text(
                "1. User Responsibilities",
              ),
              SizedBox(height: 10),
              Text(
                "Users must provide accurate information and follow local laws and regulations while using the service.",
                  style: Theme.of(context).textTheme.displayMedium),

            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

}