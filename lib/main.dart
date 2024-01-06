import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'lyrics_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String songLink = ''; // Global variable to store the link

  Future<void> _launchURL(String url) async {
    if (!await canLaunch(url)) {
      throw "Can not launch url";
    }

    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController artistController = TextEditingController();

    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Songs About You',
                    style: TextStyle(
                      fontFamily: 'Musicografi',
                      fontSize: 25.0,
                    ),
                  ),
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Color(0xFF3a264f),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.history),
                      onPressed: () {
                        print('History Button Pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryScreen(
                              songTitle: titleController.text.isNotEmpty
                                  ? titleController.text
                                  : null,
                              songArtist: artistController.text.isNotEmpty
                                  ? artistController.text
                                  : null,
                              songLink: songLink, // Pass the link to HistoryScreen
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                body: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/saylogo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Discover the lyrics of the songs that you love',
                          style: TextStyle(
                            fontFamily: 'AgainstHistory',
                            fontSize: 30.0,
                            color: Color(0xFF3a264f),
                          ),
                        ),
                        const Text(
                          'in one place.',
                          style: TextStyle(
                            fontFamily: 'TheSignature',
                            fontSize: 50.0,
                            color: Color(0xFF3a264f),
                          ),
                        ),
                        const SizedBox(
                          width: 200.0,
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFF3a264f),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 30.0),
                          color: Color(0xFFf8f6fc),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title: TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Song',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 30.0),
                          color: Color(0xFFf8f6fc),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title: TextField(
                                controller: artistController,
                                decoration: const InputDecoration(
                                  hintText: 'Artist',
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String title = titleController.text;
                            String artist = artistController.text;
                            print('Song Title: $title, Artist: $artist');
                            print('Get Lyrics Button Pressed');

                            // Reset songLink before making a new API request
                            songLink = '';

                            await getLyrics(context, title, artist);

                            // Check if songLink is not null and not empty before launching URL
                            if (songLink != null && songLink.isNotEmpty) {
                              _launchURL(songLink);
                            } else {
                              // Display "No result" message
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'No result',
                                    style: TextStyle(
                                      color: Color(0xFF3a264f),
                                    ),
                                  ),
                                  content: Text(
                                    'Sorry, no lyrics found for the given title and artist.',
                                    style: TextStyle(
                                      color: Color(0xFF3a264f),
                                    ), // Set font color
                                  ),
                                  backgroundColor: Color(0xFFf8f6fc), // Set box color
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Color(0xFFa684ce),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            primary: Color(0xFFa684ce),
                          ),
                          child: const Text(
                            'Get Lyrics',
                            style: TextStyle(color: Color(0xFFe7e0f4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> getLyrics(
      BuildContext context, String title, String artist) async {
    String songTitle, songArtist;
    String data;

    Uri url = Uri.parse(
        "https://www.stands4.com/services/v2/lyrics.php?uid=12281&tokenid=4fUNfYbiQ4dEmEed&term=$title&artist=$artist&format=json");
    Response response = await get(url);
    print(response.body);
    data = response.body;

    if (response.statusCode == 200) {
      var result = jsonDecode(data)['result'];

      if (result != null) {
        if (result is List && result.isNotEmpty) {
          songTitle = result[0]['song'];
          songArtist = result[0]['artist'];

          if (result[0].containsKey('song-link')) {
            songLink = result[0]['song-link'];
          } else {
            songLink = '';
          }
        } else if (result is Map) {
          songTitle = result['song'];
          songArtist = result['artist'];

          if (result.containsKey('song-link')) {
            songLink = result['song-link'];
          } else {
            songLink = '';
          }
        } else {
          print('Invalid response format');
          return;
        }

        print(songTitle);
        print(songArtist);
        print(songLink);
      } else {
        print('Invalid response format');
      }
    }
  }
}