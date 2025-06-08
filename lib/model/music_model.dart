class MusicModel {
  String? mp3;
  String? song;
  String? artist;
  String? youtube;

  MusicModel({this.mp3, this.song, this.artist, this.youtube});

  MusicModel.fromJson(Map<String, dynamic> json) {
    mp3 = json['mp3'];
    song = json['songName'];
    artist = json['artistName'];
    youtube = json['youtube'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mp3'] = this.mp3;
    data['song'] = this.song;
    data['artist'] = this.artist;
    data['youtube'] = this.youtube;
    return data;
  }
}
