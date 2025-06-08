import 'package:ai_music/model/music_list_model.dart';
import 'package:ai_music/model/music_model.dart';
import 'package:ai_music/model/user_model.dart';

import 'artist_list_model.dart';

class ResponseModel<T> {
  ResponseModel({this.status, this.message, this.data});

  late int? status;
  late String? message;
  T? data;

  ResponseModel.fromJson(Map<String, dynamic> json, int? statusCode) {
    status = json['status'] ?? statusCode;
    message = json['message'];
    data = (json['data'] == null || json["data"].length == 0) ? null : _handleClasses(json['data']);
  }

  _handleClasses(json) {
    if (T == UserModel) {
      return UserModel.fromJson(json) as T;
    } else if (T == List<MusicModel>) {
      // return MusicModel.fromJson(json) as T;

      List<MusicModel> temp = [];
      if (json != null && json is List<dynamic>) {
        for (var element in json) {
          temp.add(MusicModel.fromJson(element as Map<String, dynamic>));
        }
      }
      return temp as T;
    } else if (T == List<MusicListModel>) {
      // return MusicModel.fromJson(json) as T;

      List<MusicListModel> temp = [];
      if (json != null && json is List<dynamic>) {
        for (var element in json) {
          temp.add(MusicListModel.fromJson(element as Map<String, dynamic>));
        }
      }
      return temp as T;
    }else if (T == List<ArtistListModel>) {
      // return MusicModel.fromJson(json) as T;

      List<ArtistListModel> temp = [];
      if (json != null && json is List<dynamic>) {
        for (var element in json) {
          temp.add(ArtistListModel.fromJson(element as Map<String, dynamic>));
        }
      }
      return temp as T;
    } else {
      return json;
    }
  }
}
