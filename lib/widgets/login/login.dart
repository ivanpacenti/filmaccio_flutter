import 'package:filmaccio_flutter/widgets/login/PasswordDimenticata.dart';
import 'package:filmaccio_flutter/widgets/login/RegPrima.dart';
import 'package:filmaccio_flutter/widgets/login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Classe che implementa la pagina di  login
/// {@autor ivanpacenti}
/// {@autor nicolaPiccia}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super
        .initState(); // Esegue il logout dell'utente quando si carica la pagina di login
  }

  bool visibilitaPassword = false;
  bool erroreLogin = false;
  bool isLoggedOut = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> SignIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      print(error);
      setState(() {
        erroreLogin = true;
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
                      color: Theme.of(context).colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 50, right: 50),
                    width: 300,
                    child: TextFormField(
                      onChanged: (String newValue) {
                        // test for your condition
                        setState(() {
                          erroreLogin = false; // change the color
                        });
                      },
                      controller: _email,
                      decoration: InputDecoration(
                          labelText: 'Indirizzo email',
                          labelStyle:
                              TextStyle(color: erroreLogin ? Colors.red : null),
                          prefixIcon: const Icon(Icons.person),
                          prefixIconColor:
                              erroreLogin ? Colors.red : Colors.grey,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _email.text = "";
                              setState(() {
                                erroreLogin = false;
                              });
                            },
                          )),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (erroreLogin)
                        const Text(
                          "Indirizzo email o password errati",
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 50, right: 50),
                    width: 300,
                    child: TextFormField(
                      onChanged: (String newValue) {
                        // test for your condition
                        setState(() {
                          erroreLogin = false; // change the color
                        });
                      },
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: erroreLogin ? Colors.red : null),
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: erroreLogin ? Colors.red : Colors.grey,
                        suffixIcon: IconButton(
                          icon: Icon(visibilitaPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              visibilitaPassword = !visibilitaPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: !visibilitaPassword,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 5, left: 130, right: 130),
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        SignIn();
                        setState(() {
                          if (erroreLogin) {}
                        });
                      },
                      child: const Text('Entra'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordDimenticata()),
                      );
                    },
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
                    margin:
                        const EdgeInsets.only(top: 10, left: 100, right: 100),
                    width: 250,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.login),
                      label: const Text('Accedi con Google'),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, left: 120, right: 40),
                    child: const Text(
                      'Non hai un account?',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, left: 100, right: 100),
                    width: 250,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegPrima()),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Registrati con email'),
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
