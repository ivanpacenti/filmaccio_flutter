import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstraintLayout(),
    );
  }
}

class ConstraintLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage("path/to/movie_backdrop.png"),
          fit: BoxFit.cover,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage("path/to/movie_poster.png"),
                fit: BoxFit.cover,
              ),
              ConstraintLayout(
                id: "constraint_interno_details",
                color: Colors.white,
                children: [
                  Text(
                    "Guardiani della Galassia Volume 3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "2023 | Diretto da",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "James Gunn",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "150 minuti",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {},
                  ),
                  Text("Guardato"),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                  Text("Preferiti"),
                  IconButton(
                    icon: Icon(Icons.more_time),
                    onPressed: () {},
                  ),
                  Text("Watchlist"),
                  Divider(),
                  Text(
                    "Descrizione",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                  // ...other widgets
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
