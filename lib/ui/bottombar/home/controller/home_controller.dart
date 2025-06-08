import 'package:get/get.dart';

class HomeController extends GetxController {
  var searchText = ''.obs;
  var courses = [].obs;
  var mentors = [].obs;

  @override
  void onInit() {
    fetchCourses();
    fetchMentors();
    super.onInit();
  }

  void fetchCourses() {
    courses.value = [
      {"title": "Music Basic", "price": 28, "rating": 4.2, "students": 7830},
      {"title": "Music Advanced", "price": 42, "rating": 4.5, "students": 9320},
    ];
  }

  void fetchMentors() {
    mentors.value = ["Sonja", "Jensen", "Victoria", "Castaldo"];
  }
}
