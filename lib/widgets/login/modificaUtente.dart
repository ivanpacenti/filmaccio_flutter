import 'package:flutter/material.dart';

class ModificaUtente extends StatelessWidget {
  const ModificaUtente({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cambia il tuo nome visualizzato:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Nome visualizzato',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aggiungi qui la logica per salvare il nome visualizzato
              },
              child: Text('Salva'),
            ),
            Divider(height: 16),
            Text(
              'Cambia la tua foto profilo o la tua immagine di sfondo:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/default_propic.png'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aggiungi qui la logica per cambiare la foto profilo
              },
              child: Text('Cambia foto profilo'),
            ),
            Divider(height: 16),
            Text(
              'Cambia altre informazioni:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Aggiungi qui la logica per il cambio password
              },
              child: Text('Cambio password'),
            ),
          ],
        ),
      ),
    );
  }
}
