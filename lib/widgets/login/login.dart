import 'package:filmaccio_flutter/widgets/login/auth.dart';
import 'package:filmaccio_flutter/widgets/login/home.dart';
import 'package:filmaccio_flutter/widgets/login/RegPrima.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  bool visibilitaPassword=false;
  bool erroreLogin=false;
  Color _color= Colors.black;
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  Future<void> SignIn() async
  {
    try{
        await Auth().signInWithEmailAndPassword(email: _email.text, password: _password.text);
    }
    on FirebaseAuthException catch (error){
      print(error);
      setState(() {
        erroreLogin=true;
        _color=Colors.red;
      });

      }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Entra in ',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Filmaccio',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 300,
              decoration:
              BoxDecoration(
                  border: Border.all(color: _color)
              ),
              child: TextFormField(
                onChanged: (String newValue) {
                    // test for your condition
                    setState(() {
                      _color = Colors.black;
                      erroreLogin=false;// change the color
                    });
                },
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Nome utente o email',
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(erroreLogin) Text(
                  "Indirizzo email o password errati",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.red),),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 300,
              decoration:
                BoxDecoration(
                  border: Border.all(color: _color)
              ) ,
              child: TextFormField(
                onChanged: (String newValue) {
                  // test for your condition
                  setState(() {
                    _color = Colors.black;
                    erroreLogin=false;// change the color
                  });
                },
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(visibilitaPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        visibilitaPassword=!visibilitaPassword;
                      });
                    },
                  ),
                ),
                obscureText: !visibilitaPassword,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  SignIn();
                  setState(() {
                    if(erroreLogin)
                      {_color=Colors.red;}
                  });
                },
                child: const Text('Entra'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Password dimenticata',
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Row(
                children: [
                  Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Oppure',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 250,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text('Accedi con Google'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                'Non hai un account?',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  RegPrima()),
                  );
                },
                icon: const Icon(Icons.email),
                label: const Text('Registrati con email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}