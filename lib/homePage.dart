import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String artistName = '';
  String musicName = '';
  String youTubeSearch = '';
  String lyricMusic = '';

  Future<void> _lauchURL() async {
    youTubeSearch =
        'https://www.youtube.com/results?search_query=$artistName+$musicName';
    await canLaunch(youTubeSearch)
        ? await launch(youTubeSearch)
        : throw 'Error';
  }

  void _getMusicAPI() async {
    try {
      final uri = Uri.parse(
          'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?format=jsonp&callback=callback&q_track=$musicName&q_artist=$artistName&apikey=54adac49846aa5130d5ec9c73383d48a');
      final response = await http.get(uri);
      final reg = RegExp(r'\{.*\}');
      final aux =
          reg.allMatches(response.body).map((e) => e.group(0)).toList()[0];
      final res = json.decode(response.body);
      setState(() {
        lyricMusic = res["message"]["body"]["lyrics"]["lyrics_body"];
      });
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Dingo Music',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                height: 200,
                width: 200,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    child: Image.asset(
                      'images/principal_icon.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        artistName = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome do Artista'),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        musicName = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome da Música'),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Text(
                    'Buscar Letra',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _getMusicAPI,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Text(
                    'Buscar no YouTube',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // onPressed: (){},
                  onPressed: _lauchURL,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                decoration: BoxDecoration(color: Colors.purple),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        '$musicName',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$artistName.',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('$lyricMusic'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.purple),
                child: Text(
                  '@copyright Dingo Music',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
