import 'package:filmaccio_flutter/widgets/login/RegSeconda.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/UserData.dart';

class RegTerza extends StatefulWidget {
  final UserData userData;
  const RegTerza( {Key? key,required this.userData}) : super(key: key);
  @override
  _RegTerzaState createState() => _RegTerzaState();
}

class _RegTerzaState extends State<RegTerza> {
  late UserData userData;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
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
  int lunghezza=0;
  final TextEditingController _nomeVisualizzato=TextEditingController();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Registrati a ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  Text(
                    'Filmaccio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
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
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nome visualizzato',
                  counterText: '$lunghezza / 50',
                  prefixIcon: const Icon(Icons.contact_page),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _nomeVisualizzato.text="";
                        lunghezza=0;
                      });
                    },
                    icon: const Icon(Icons.clear),

                  ),
                ),
                maxLength: 50,
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
                  onPressed: () {
                    userData.nomeVisualizzato=_nomeVisualizzato.text;
                    userData.avatar=Image.file(_image!).image;

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
