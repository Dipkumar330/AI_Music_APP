class MusicListModel {
  String? artistName;
  String? songName;
  String? imageName;
  String? mp3File;
  String? lrcFile;

  MusicListModel({this.artistName, this.songName, this.imageName, this.mp3File, this.lrcFile});

  MusicListModel.fromJson(Map<String, dynamic> json) {
    artistName = json['artistName'];
    songName = toTitleCase(json['songName']?.replaceAll("_", " ") ?? "");
    imageName = json['imageName'];
    mp3File = json['mp3File'];
    lrcFile = json['lrcFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artistName'] = artistName;
    data['songName'] = songName?.replaceAll("_", " ") ?? "";
    data['imageName'] = imageName;
    data['mp3File'] = mp3File;
    data['lrcFile'] = lrcFile;
    return data;
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}
