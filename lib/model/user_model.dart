import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_common/preference_keys.dart';

var userModelSingleton = UserModel.singleton;

class UserModel {
  UserModel._internal();

  static final UserModel singleton = UserModel._internal();

  factory UserModel() {
    return singleton;
  }

  UserModel.fromJson(dynamic json) {
    updateValue(json);
  }

  updateValue(dynamic json) {
    id = json['_id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
    birthDate = json['birthDate'];
    email = json['email'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accessToken =
        (json['authToken'] != null && json['authToken'] != "") ? json['authToken'] : accessToken;

    saveUserDetails();
  }

  String? id;
  String? name;
  String? phoneNumber;
  String? countryCode;
  String? birthDate;
  String? email;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? accessToken;

  Future<void> saveUserDetails() async {
    final dictOfUserDetails = toJson();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(PreferenceKeys.prefKeyUserData, json.encode(dictOfUserDetails));
  }

  static Future<void> saveIsLoginVerified() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(PreferenceKeys.prefKeyIsLoginVerified, true);
  }

  static Future<bool> isLoginVerified() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(PreferenceKeys.prefKeyIsLoginVerified) ?? false;
  }

  Future<void> clearPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Future<void> loadUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jsonStoredUserDetails = preferences.getString(PreferenceKeys.prefKeyUserData) ?? "";
    if (jsonStoredUserDetails.isNotEmpty) {
      Map<String, dynamic> jsonValue = json.decode(jsonStoredUserDetails);
      await updateValue(jsonValue);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['countryCode'] = countryCode;
    map['birthDate'] = birthDate;
    map['email'] = email;
    map['isActive'] = isActive;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['authToken'] = accessToken;
    return map;
  }
}
