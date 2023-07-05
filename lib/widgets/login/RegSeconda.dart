import 'package:filmaccio_flutter/widgets/login/RegPrima.dart';
import 'package:filmaccio_flutter/widgets/models/UserData.dart';
import 'package:flutter/material.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'RegTerza.dart';

class RegSeconda extends StatefulWidget {
  final UserData userData;
  const RegSeconda( {Key? key,required this.userData}) : super(key: key);

  @override
  _RegSecondaState createState() => _RegSecondaState();
}
enum Genere {M,F,A}
class _RegSecondaState extends State<RegSeconda> {
  int day=1;
  int month=10;
  int year=1993;
  bool dateValidator(int year,int month,int day)
  {
    var eta=DateTime(year,month,day);
    var today=DateTime.now();
    var difference=today.difference(eta).inDays/365.round();
    if(difference<14) return false;
    else return true;
  }

  Genere? _genere= Genere.M;
  late UserData userData;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
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
           Container(
            height: 50,
          ),
          const Text(
            'Seleziona il tuo genere',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
           Container(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Genere>(
                value: Genere.M,
                groupValue: _genere,
                onChanged: (Genere? value) {
                  setState(() {
                    _genere=value;
                  });
                },
              ),
              const Text('Maschile'),
              Radio<Genere>(
                value: Genere.F,
                groupValue: _genere,
                onChanged: (Genere? value) {
                  setState(() {
                    _genere=value;
                  });
                },
              ),
              const Text('Femminile'),
              Radio<Genere>(
                value: Genere.A,
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
           Container(
            height: 30,
          ),
          const Text(
            'Inserisci la tua data di nascita',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
           Container(
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
                }
              }),
              onChangedMonth: (value) => setState(() {
                if(value!.isNotEmpty){
                  month=int.parse(value);
                }
              }),
              onChangedYear: (value) => setState(() {
                if(value!.isNotEmpty){
                  year=int.parse(value);
                }
              }),
              locale: "it_IT",// optional
            ),
          ),
           Container(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if(dateValidator(year, month, day)) {
                userData.dataNascita=DateTime(year,month,day);
                userData.genere = _genere.toString().split('.').last;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  RegTerza(userData: userData)),
                );
              }
              else {
                Fluttertoast.showToast(
                    msg: "Inserisci una data di nascita valida (almeno 14 anni)",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
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