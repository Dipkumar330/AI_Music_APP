// import 'dart:convert';
//
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../utils/app_common/preference_keys.dart';
//
// var userDataSingleton = UserDataSingleton.singleton;
//
// class UserDataSingleton {
//   UserDataSingleton._internal();
//
//   static final UserDataSingleton singleton = UserDataSingleton._internal();
//
//   factory UserDataSingleton() {
//     return singleton;
//   }
//
//   UserDataSingleton.fromJson(dynamic json) {
//     updateValue(json);
//   }
//
//   Future<void> updateValue(Map<String, dynamic> json) async {
//     if (json.isNotEmpty) {
//       role = json['role'];
//       name.value = json['name'];
//       fullName.value = json['fullName'];
//       email = json['email'];
//       fName.value = json['firstName'];
//       lName.value = json['lastName'];
//       phoneNo = json['phoneNo'];
//       token = json['token'];
//       profileStep = json['profileStep'];
//       cityID?.value = json['city'];
//       stateID?.value = json['state'];
//
//       saveUserDetails();
//     }
//   }
//
//   Future<void> saveUserDetails() async {
//     final dictOfUserDetails = toJson();
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString(PreferenceKeys.prefKeyUserData, json.encode(dictOfUserDetails));
//   }
//
//   static Future<void> saveIsLoginVerified() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setBool(PreferenceKeys.prefKeyIsLoginVerified, true);
//   }
//
//   static Future<bool> isLoginVerified() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     return preferences.getBool(PreferenceKeys.prefKeyIsLoginVerified) ?? false;
//   }
//
//   Future<void> clearPreference() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.clear();
//   }
//
//   Future<void> loadUserDetails() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String jsonStoredUserDetails = preferences.getString(PreferenceKeys.prefKeyUserData) ?? "";
//     if (jsonStoredUserDetails.isNotEmpty) {
//       Map<String, dynamic> jsonValue = json.decode(jsonStoredUserDetails);
//       await updateValue(jsonValue);
//     }
//   }
//
//   String? role;
//   RxnString name = RxnString();
//   RxnString fullName = RxnString();
//   RxnString fName = RxnString();
//   RxnString lName = RxnString();
//   String? email;
//   String? phoneNo;
//   String? token;
//   int? profileStep;
//   RxnInt? cityID = RxnInt();
//   RxnInt? stateID = RxnInt();
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['role'] = role;
//     map['name'] = name.value;
//     map['fullName'] = fullName.value;
//     map['email'] = email;
//     map['firstName'] = fName.value;
//     map['lastName'] = lName.value;
//     map['phoneNo'] = phoneNo;
//     map['token'] = token;
//     map['profileStep'] = profileStep;
//     return map;
//   }
// }
