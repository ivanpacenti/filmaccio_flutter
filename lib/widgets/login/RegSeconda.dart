import 'package:filmaccio_flutter/widgets/login/RegPrima.dart';
import 'package:flutter/material.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';

class RegSeconda extends StatefulWidget {
  const RegSeconda({Key? key}) : super(key: key);

  @override
  _RegSecondaState createState() => _RegSecondaState();
}
enum Genere {Maschile,Femminile,Altro}
class _RegSecondaState extends State<RegSeconda> {
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

          const Text(
            'Seleziona il tuo genere',
            style: TextStyle(
              fontSize: 18,
            ),
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
            height: 20,
            thickness: 0,
          ),
          const Text(
            'Inserisci la tua data di nascita',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Container(
            width: 450,
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
              onChangedDay: (value) => print('onChangedDay: $value'),
              onChangedMonth: (value) => print('onChangedMonth: $value'),
              onChangedYear: (value) => print('onChangedYear: $value'),
              //boxDecoration: BoxDecoration(
              // border: Border.all(color: Colors.grey, width: 1.0)), // optional
              // showDay: false,// optional
              // dayFlex: 2,// optional
              locale: "it_IT",// optional
              // hintDay: 'Day', // optional
              // hintMonth: 'Month', // optional
              // hintYear: 'Year', // optional
              // hintTextStyle: TextStyle(color: Colors.grey), // optional
            ),
          ),
          const Divider(
            height: 20,
            thickness: 0,
          ),
          ElevatedButton(
            onPressed: () {
              // Azione da eseguire quando il pulsante viene premuto
            },
            child: const Text('Avanti'),
          ),
        ],
      ),
    );
  }
}
