import 'package:flutter/material.dart';
import '../Services/UserService.dart';
import '../models/UserModel.dart';

class Profilo extends StatelessWidget {
  const Profilo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: UserService().user,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final UserModel? currentUser = snapshot.data;
          final String? nameShown = currentUser?.nameShown;
          final String? email = currentUser?.email;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameShown ?? 'Unknown User',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email ?? 'No Email',
                                style: TextStyle(fontSize: 14),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('SEGUI'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Card(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('TEMPO FILM'),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    '2',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text('mesi'),
                                                ],
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                children: [
                                                  Text(
                                                    '15',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text('giorni'),
                                                ],
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                children: [
                                                  Text(
                                                    '10',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text('ore'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add other cards here...
                                  ],
                                ),
                              ),
                              Divider(),
                              Text('Liste'),
                              SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Card(
                                      child: Container(
                                        width: 150,
                                        height: 120,
                                        child: Container(),
                                      ),
                                    ),
                                    // Add other cards here...
                                  ],
                                ),
                              ),
                              Divider(),
                              Text('Serie TV viste'),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Visualizza tutte'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Card(
                                      child: Container(
                                        width: 100,
                                        height: 150,
                                        child: Container(),
                                      ),
                                    ),
                                    // Add other cards here...
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
