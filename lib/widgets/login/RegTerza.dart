import 'package:filmaccio_flutter/main.dart';
import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:filmaccio_flutter/widgets/login/RegSeconda.dart';
import 'package:filmaccio_flutter/widgets/login/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/UserData.dart';
import '../nav/bottomnavbar.dart';

class RegTerza extends StatefulWidget {

  final UserData userData;

  const RegTerza( {Key? key,required this.userData}) : super(key: key);
  @override
  _RegTerzaState createState() => _RegTerzaState();

}

class _RegTerzaState extends State<RegTerza> {
  int lunghezza=0;
  final TextEditingController _nomeVisualizzato=TextEditingController();
  bool signupSuccess=false;
  late UserData userData;
  bool nomeCorretto=true;
  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    _nomeVisualizzato.text = userData.nomeUtente;
    lunghezza=userData.nomeUtente.length;
  }
  // This is the file that will be used to store the image
  File? _image;

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
       setState(() {

         _image = File(pickedFile.path);
       });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  RegSeconda(userData: userData)),
            );
          },
        ),
        title: Align(
            alignment: Alignment.centerRight,
            child:Text(
              '3/3',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 24,

              ),
            )),
      ),
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
            Container(
              height: 50,

            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                    child:TextFormField(
                controller: _nomeVisualizzato,
                onChanged: (hasValue){
                  setState(() {
                    lunghezza=hasValue.length;
                    nomeCorretto=true;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nome visualizzato',
                  labelStyle: TextStyle(color: !nomeCorretto?Colors.red:null),
                  counterText: '$lunghezza / 50',
                  prefixIcon: const Icon(Icons.person),
                  prefixIconColor: !nomeCorretto?Colors.red:null,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _nomeVisualizzato.text="";
                        lunghezza=0;
                        nomeCorretto=true;
                      });
                    },
                    icon:  Icon(nomeCorretto ? Icons.clear:Icons.warning_amber,color: !nomeCorretto?Colors.red:null),

                  ),
                ),
                maxLength: 80,
                keyboardType: TextInputType.text,

            )),
                const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                  "Se vuoi imposta un'immagine del profilo",
                  style: TextStyle(fontSize: 14),
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                width: 150.0,
                height: 150.0,
                child: GestureDetector(
                  onTap: (){
                    _getFromGallery();
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: (_image != null)
                        ? Image.file(_image!).image
                        : AssetImage('assets/images/default_propic.png'),
                  ),
                ),
              ),
            ),
                ElevatedButton(
                  onPressed: () async{
                    if(lunghezza<3||lunghezza>50){
                      setState(() {
                        nomeCorretto=false;
                        Fluttertoast.showToast(
                            msg: "Il nome visualizzato deve essere tra i 3 e i 50 caratteri",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      });
                    }else {
                  userData.nomeVisualizzato = _nomeVisualizzato.text;
                  if (_image != null) {
                    userData.avatar = File(_image!.path);
                  } else {
                    final defaultImagePath = await rootBundle
                        .load('assets/images/default_propic.png');
                    final defaultImageData =
                        await defaultImagePath.buffer.asUint8List();
                    final appDir = await getApplicationDocumentsDirectory();
                    final defaultImageSavePath =
                        '${appDir.path}/default_propic.png';
                    await File(defaultImageSavePath)
                        .writeAsBytes(defaultImageData);
                    userData.avatar = File(defaultImageSavePath);
                  }
                  try {
                    FirestoreService.createUser(userData);
                  //  FirestoreService.popolateUser(userData);
                    signupSuccess = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  } catch (e) {
                    setState(() {
                      signupSuccess = false;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialogErrore(context));
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
      ]),
    );
  }

}
Widget _buildPopupDialogErrore(BuildContext context) {
  return AlertDialog(
    title: const Text('Errore'),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Registrazione fallita, riprova."),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Chiudi'),
      ),
    ],
  );

}
