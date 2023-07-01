import 'package:flutter/material.dart';

class Profilo extends StatelessWidget {
  const Profilo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          'intenditore equino',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Nome utente', style: TextStyle(fontSize: 14)),
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
                                            Text('2',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text('mesi'),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          children: [
                                            Text('15',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text('giorni'),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          children: [
                                            Text('10',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text('ore'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('TV TIME'),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('4',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text('mesi'),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          children: [
                                            Text('25',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text('giorni'),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          children: [
                                            Text('18',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text('ore'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Film visti'),
                                    Text('50',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Episodi visti'),
                                    Text('500',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Follower'),
                                    Text('1000',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Following'),
                                    Text('500',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
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
                              Card(
                                child: Container(
                                  width: 150,
                                  height: 120,
                                  child: Container(),
                                ),
                              ),
                              Card(
                                child: Container(
                                  width: 150,
                                  height: 120,
                                  child: Container(),
                                ),
                              ),
                              Card(
                                child: Container(
                                  width: 150,
                                  height: 120,
                                  child: Container(),
                                ),
                              ),
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
                              Card(
                                child: Container(
                                  width: 100,
                                  height: 150,
                                  child: Container(),
                                ),
                              ),
                              Card(
                                child: Container(
                                  width: 100,
                                  height: 150,
                                  child: Container(),
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
          ],
        ),
      ),
    );
  }
}
