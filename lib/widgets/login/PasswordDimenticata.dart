import 'package:filmaccio_flutter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordDimenticata extends StatefulWidget {
  @override
  _PasswordDimenticataState createState() => _PasswordDimenticataState();
}

class _PasswordDimenticataState extends State<PasswordDimenticata> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              "Problemi di accesso?",
              style: TextStyle(
                fontFamily: "sans-serif-medium",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Inserisci il tuo indirizzo email e ti invieremo un link per il reset della tua password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Indirizzo email",
                prefixIcon: Icon(Icons.email),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _emailController.text="";
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async{
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                Fluttertoast.showToast(
                    msg: "Controlla la tua mail per il link al reset della tua password",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Text("Invia il link di reset"),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Oppure",
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  child: Text(
                    "Torna indietro e registrati o prova ad entrare con Google.",
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MyApp()),
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text("Indietro"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
