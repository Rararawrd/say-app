import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LyricsScreen extends StatelessWidget {
  final String songTitle;
  final String songLink;
  final String artistName;

  Future<void> _launchURL(String url) async {
    if (!await canLaunch(url)) {
      throw "Can not launch url";
    }

    await launch(url);
  }

  LyricsScreen(this.songTitle, this.songLink, this.artistName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E57C2),
      appBar: AppBar(
        title: Text(songTitle),
        backgroundColor: Colors.yellow[200],
        foregroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Text(
              '"$songTitle"', // Display title of the song
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
            Text(
              'By: $artistName', // Display artist name
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Song Link: $songLink',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                print('Get Lyrics Button Pressed');
                _launchURL(songLink);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                primary: Colors.white,
              ),
              child: const Text(
                'Get Lyrics',
                style: TextStyle(color: Color(0xFF4A148C)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
