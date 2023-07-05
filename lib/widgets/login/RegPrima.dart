import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:filmaccio_flutter/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../models/UserData.dart';
import 'Auth.dart';
import 'RegSeconda.dart';



class RegPrima extends StatefulWidget {
  UserData userData=UserData();

  @override
  _RegPrimaState createState() => _RegPrimaState();
}

class _RegPrimaState extends State<RegPrima> {
  var confirmPass;
  bool visibilitaPassword1=false;
  bool visibilitaPassword2=false;
  int lunghezza=0;
  final TextEditingController _email=TextEditingController();
  final TextEditingController _utente=TextEditingController();
  final TextEditingController _password1=TextEditingController();
  final TextEditingController _password2=TextEditingController();
  bool passwordUguali=true;
  bool emailValida=true;
  bool utenteValido=true;
  bool passwordValida=true;
  bool emailEsistente=false;
  late UserData userData;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
  }

  bool isEmail(String string) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(string);
  }
  bool isUtente(String string) {
    RegExp regex = RegExp(r"^(?=.*[a-zA-Z])[a-zA-Z0-9._]{3,}$");
    return regex.hasMatch(string);
  }
  bool isPassword(String string) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    return regex.hasMatch(string);
  }
  bool isPasswordUguali(String pwd1, String pwd2)
  {
    return(_password2.text==_password1.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Registrati a ',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Filmaccio',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Indirizzo email',
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: IconButton(
                      icon:  Icon(emailValida?Icons.clear:Icons.warning_amber),
                      onPressed: () {
                        _email.text="";
                        setState(() {
                          emailValida=true;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!emailValida) const Text("Indirizzo mail non valido",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red)) else
                              if(emailEsistente) const Text("Indirizzo mail già esistente",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red))

                  ],
                ),
                TextFormField(
                  onChanged: (hasValue)
                  {
                    setState(() {
                      lunghezza=_utente.text.length;
                    });
                  },
                  controller:_utente,
                  decoration: InputDecoration(
                    labelText: 'Nome utente',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon:  Icon(utenteValido?Icons.clear:Icons.warning_amber),
                      onPressed: () {
                        _utente.text="";
                        setState(() {
                          lunghezza=0;
                          utenteValido=true;
                        });
                      },
                    ),
                    counter:  Text('$lunghezza / 30'),
                  ),
                  keyboardType: TextInputType.text,
                  //maxLength: 30,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [  if(!utenteValido)
                      Container(
                        width: 300,
                        child: const Text("Il nome utente deve essere lungo "
                            "almeno 3 caratteri, deve contenere almeno una lettera e può contenere "
                            "solo lettere, numeri e i caratteri '.' e '_'",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red))
                      )
                    
                  ],
                ),
                TextFormField(

                  controller: _password1,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(visibilitaPassword1 ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          visibilitaPassword1=!visibilitaPassword1;
                        });
                      },
                    ),
                  ),
                  obscureText: !visibilitaPassword1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [  if(!passwordValida)  Container(
                    width: 300,
                    child: const Text("La password deve essere lunga "
                        "almeno 8 caratteri e contenere almeno una lettera "
                        "maiuscola, una minuscola e un numero",style: TextStyle(
                        fontSize: 12,
                        color: Colors.red)),
                  )

                  ],
                ),

                TextFormField(
                  controller: _password2,
                  decoration: InputDecoration(
                    labelText: 'Conferma password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(visibilitaPassword2 ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          visibilitaPassword2=!visibilitaPassword2;
                        });
                      },
                    ),
                  ),
                  obscureText: !visibilitaPassword2,
                  onChanged: (String hasChange){
                    if(hasChange.isNotEmpty){
                      passwordUguali=isPasswordUguali(_password1.text, _password2.text);
                      } else passwordUguali=false;
                    },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(passwordUguali==false) const Text("Le password non corrispondono",
                        style: TextStyle(
                        fontSize: 12,
                        color: Colors.red)),
                  ],
                ),
                const Divider(height: 16),
                ElevatedButton(
                  onPressed: () async{
                    if (isEmail(_email.text)) {
                      setState(() {
                      emailValida=true;
                    });
                    } else {
                      setState(() {
                      emailValida=false;
                    });
                    }
                    if (isUtente(_utente.text)) {
                      setState(() {
                        utenteValido=true;
                      });
                    } else {
                      setState(() {
                        utenteValido=false;
                      });
                    }
                    if (isPassword(_password1.text)) {
                      setState(() {
                        passwordValida=true;
                      });
                    } else {
                      setState(() {
                        passwordValida=false;
                      });
                    }
                    passwordUguali=isPasswordUguali(_password1.text,_password2.text);
                    if(utenteValido&&emailValida&&passwordUguali&&passwordValida)
                      {

                        userData.email=_email.text;
                        userData.nomeUtente=_utente.text;
                        userData.password=_password1.text;
                        if(await FirestoreService.searchUsersByEmail(_email.text)){
                          setState(() {
                            emailEsistente=true;
                            emailValida=false;
                          });
                        }
                        else{
                          setState(() {
                            emailEsistente=false;
                            emailValida=true;
                          });
                        }
                        if(!emailEsistente) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegSeconda(userData: userData)),
                        );
                        }
                      }
                  },
                  child: const Text('Avanti'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async{
            try {
              await Auth().signOut();
            } catch (e) {
              print('Errore durante il logout: $e');
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );

          },
        ),
        title: Align(
            alignment: Alignment.centerRight,
            child:Text(
              '1/3',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 24,

              ),
            )),
      ),
    );
  }
}
