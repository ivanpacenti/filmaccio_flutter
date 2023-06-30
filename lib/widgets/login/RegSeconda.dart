import 'package:filmaccio_flutter/widgets/login/RegPrima.dart';
import 'package:flutter/material.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';

import 'RegTerza.dart';

class RegSeconda extends StatefulWidget {
  const RegSeconda({Key? key}) : super(key: key);

  @override
  _RegSecondaState createState() => _RegSecondaState();
}
enum Genere {Maschile,Femminile,Altro}
class _RegSecondaState extends State<RegSeconda> {
  int day=0;
  int month=0;
  int year=0;
  bool dateValidator(int year,int month,int day)
  {
    var eta=DateTime(year,month,day);
    var today=DateTime.now();
    var difference=today.difference(eta).inDays/365.round();
    if(difference<14) return false;
    else return true;
  }

  Genere? _genere= Genere.Maschile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  RegPrima()),
            );
          },
        ),
        title: Align(
            alignment: Alignment.centerRight,
            child:Text(
              '2/3',
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
          const Divider(
            height: 50,
            thickness: 0,
          ),
          const Text(
            'Seleziona il tuo genere',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const Divider(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Genere>(
                value: Genere.Maschile,
                groupValue: _genere,
                onChanged: (Genere? value) {
                  setState(() {
                    _genere=value;
                  });
                },
              ),
              const Text('Maschile'),
              Radio<Genere>(
                value: Genere.Femminile,
                groupValue: _genere,
                onChanged: (Genere? value) {
                  setState(() {
                    _genere=value;
                  });
                },
              ),
              const Text('Femminile'),
              Radio<Genere>(
                value: Genere.Altro,
                groupValue: _genere,
                onChanged: (Genere? value) {
                  setState(() {
                    _genere=value;
                  });
                },
              ),
              const Text('Altro'),
            ],
          ),
          const Divider(
            height: 30,
          ),
          const Text(
            'Inserisci la tua data di nascita',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const Divider(
            height: 20,
          ),
          Container(
            width: 420,
            child: DropdownDatePicker(

              inputDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))), // optional
              isDropdownHideUnderline: true, // optional
              isFormValidator: true, // optional
              startYear: 1900, // optional
              endYear: 2020, // optional
              selectedDay: 14, // optional
              selectedMonth: 10, // optional
              selectedYear: 1993, // optional
              onChangedDay: (value) => setState(() {
                if(value!.isNotEmpty){
                  day=int.parse(value);
                } else day=14;
              }),
              onChangedMonth: (value) => setState(() {
                if(value!.isNotEmpty){
                  month=int.parse(value);
                } else month=10;
              }),
              onChangedYear: (value) => setState(() {
                if(value!.isNotEmpty){
                  year=int.parse(value);
                } else year=1993;
              }),
              locale: "it_IT",// optional
            ),
          ),
          const Divider(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if(dateValidator(year, month, day)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  RegTerza()),
                );
              }
              else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopupDialog(context));
                };
            },
            child: const Text('Avanti'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 40),
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Errore'),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Inserisci una data di nascita valida (almeno 14 anni)"),
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