import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key, this.songTitle, this.songArtist, this.songLink})
      : super(key: key);

  final String? songTitle;
  final String? songArtist;
  final String? songLink; // Updated to be nullable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E57C2),
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontFamily: 'Musicografi',
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.deepPurple[100],
        foregroundColor: Color(0xFF3a264f),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/saylogo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: songTitle != null && songArtist != null
              ? Card(
            margin: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 30.0),
            color: Color(0xFFf8f6fc),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Song: $songTitle\nArtist: $songArtist',
                        style: const TextStyle(
                          color: Color(0xFF3a264f),
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Color(0xFFa684ce),
                    onPressed: () {
                      // Launch URL when IconButton is pressed
                      if (songLink != null && songLink!.isNotEmpty) {
                        _launchURL(songLink!);
                      }
                    },
                  ),
                ],
              ),
            ),
          )
              : const Text(
            'No history',
            style: TextStyle(
              fontFamily: 'AgainstHistory',
              color: Color(0xFF3a264f),
              fontSize: 40.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await canLaunch(url)) {
      throw "Can not launch url";
    }

    await launch(url);
  }
}
