class ArtistListModel {
  String? name;
  String? image;
  String? details;
  String? born;
  String? link;

  ArtistListModel({this.name, this.image, this.details, this.born, this.link});

  ArtistListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    details = json['details'];
    born = json['born'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['details'] = this.details;
    data['born'] = this.born;
    data['link'] = this.link;
    return data;
  }
}