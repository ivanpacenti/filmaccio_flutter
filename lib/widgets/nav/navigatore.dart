/*import 'package:filmaccio_flutter/widgets/Navigazione/bottomnavbar.dart';
import 'package:filmaccio_flutter/widgets/login/home.dart';
import 'package:flutter/material.dart';

class Navigatore extends StatefulWidget {
  const Navigatore({super.key});

  @override
  State<Navigatore> createState() => _NavigatoreState();
}

class _NavigatoreState extends State<Navigatore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.purple,
      items:  [
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: (){() => Navigator.pushNamed(context, 'Home');},
              icon: Icon(Icons.home)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(onPressed: (){}, icon: Icon(Icons.notifications)),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          label: 'Ricerca',
        ),
        BottomNavigationBarItem(
          icon: IconButton(onPressed: (){}, icon: Icon(Icons.monitor)),
          label: 'Episodi',
        ),
        BottomNavigationBarItem(
          icon: IconButton(onPressed: (){}, icon: Icon(Icons.person)),
          label: 'Profilo',
        ),
        BottomNavigationBarItem(
          icon: IconButton(onPressed: (){SignOut();}, icon: Icon(Icons.logout)),
          label: 'Logout',
        ),
      ],
    ),
    body: Navigator(
    onGenerateRoute: (settings) {
    Widget page = Home();
    //if (settings.name == 'page2') page = Page2();
    return MaterialPageRoute(builder: (_) => page);
    },
    ),
    );
  }
}
*/