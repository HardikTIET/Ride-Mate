import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../drawer.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Privacy Policy",
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 20),
               Text(
                "This is the privacy policy of the application. We value your privacy and are committed to protecting your personal information. By using the app, you agree to the terms outlined in this privacy policy. We collect minimal user data for service improvements...",
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 10),
               Text(
                "1. Data Collection",
                  style: Theme.of(context).textTheme.displayMedium
              ),
              const SizedBox(height: 10),
               Text(
                "We collect data such as location, contact details, and other necessary information to provide the best service.",
                   style: Theme.of(context).textTheme.displayMedium ),
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
