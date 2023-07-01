import 'package:filmaccio_flutter/widgets/login/RegSeconda.dart';
import 'package:flutter/material.dart';

class RegTerza extends StatefulWidget {
  @override
  _RegTerzaState createState() => _RegTerzaState();
}

class _RegTerzaState extends State<RegTerza> {
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
              MaterialPageRoute(builder: (context) =>  RegSeconda()),
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
                child: Image.asset('assets/images/default_propic.png'),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
