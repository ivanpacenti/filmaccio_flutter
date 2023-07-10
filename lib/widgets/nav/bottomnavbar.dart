import 'package:filmaccio_flutter/widgets/profilo.dart';
import 'package:filmaccio_flutter/widgets/public.dart';
import 'package:filmaccio_flutter/widgets/ricerca.dart';
import 'package:flutter/material.dart';

import '../login/home.dart';
/// Clase per la navigazione tra le pagine
/// {@autor ivanpacenti}
/// {@autor nicolaPiccia}
/// {@autor nicolobartolinii}
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            Home(),
            Ricerca(),
            HomeApi(),
            Profilo(),
          ],
        ),
        bottomNavigationBar: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.search),
                  text: 'Ricerca',
                ),
                Tab(
                  icon: Icon(Icons.explore),
                  text: 'Esplora',
                ),
                Tab(
                  icon: Icon(Icons.account_circle_rounded),
                  text: 'Profilo',
                ),
              ],
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ],
        ),
      ),
    );
  }
}
