import 'package:get/get.dart';

class Playlist {
  final String title;
  final String imageUrl;
  final int songCount;
  final String duration;
  final String? songLink;
  final String? lyricsLink;

  Playlist({
    required this.title,
    required this.imageUrl,
    required this.songCount,
    required this.duration,
    this.songLink,
    this.lyricsLink,
  });
}

class PlaylistController extends GetxController {
  var playlists =
      <Playlist>[
        Playlist(
          title: "Happy vibes only",
          imageUrl: "https://i.imgur.com/QCNbOAo.png",
          // replace with actual image URL or asset
          songCount: 20,
          duration: "2h 30m",
          songLink:
              "https://drive.google.com/uc?export=download&id=1p1n5aU4uF_3rb-m3avM99aHCcCAEsQ8g",
          lyricsLink:
              "https://drive.google.com/uc?export=download&id=1CESNv-HHZXRJxl4UQ2PpqC3fqLQQltoH",
        ),
        Playlist(
          title: "Chill & Relax",
          imageUrl: "https://i.imgur.com/QCNbOAo.png",
          songCount: 15,
          duration: "1h 45m",

          songLink:
              "https://drive.google.com/uc?export=download&id=18TOllFb9GdIpmZ0tClTXgUjWfX6Rd2_Z",

          lyricsLink:
              "https://drive.google.com/uc?export=download&id=1xtU-rTp4FKnPwn7M2FjmbHbTO7Z6QFBI",
        ),
      ].obs;
}
