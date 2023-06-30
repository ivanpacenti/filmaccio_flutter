import 'package:flutter/material.dart';

class RegTerza extends StatefulWidget {
  @override
  _RegTerzaState createState() => _RegTerzaState();
}

class _RegTerzaState extends State<RegTerza> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Registrati a',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Filmaccio',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Azione del pulsante "Fine"
                  },
                  child: const Text('Fine'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Azione del pulsante "Indietro"
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '3 su 3',
                        style: TextStyle(
                          fontFamily: 'sans-serif-medium',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Imposta propic',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome visualizzato',
                  counterText: '0 / 50',
                  prefixIcon: const Icon(Icons.contact_page),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Azione dell'icona di cancellazione del testo
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                maxLength: 50,
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                width: 150.0,
                height: 150.0,
                child: Image.asset('assets/default_propic.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
