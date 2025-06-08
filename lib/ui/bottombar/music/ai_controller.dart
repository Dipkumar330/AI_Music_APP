import 'dart:developer';

import 'package:ai_music/model/music_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../helper/network_manager/api_constant.dart';
import '../../../helper/network_manager/remote_services.dart';
import '../../../model/response_model.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/snackbar_util.dart';

class AiController extends GetxController {
  var selectedPrompt = ''.obs;

  TextEditingController searchMusicTextController = TextEditingController();

  RxList<Map<String, MusicModel?>> data = <Map<String, MusicModel?>>[].obs;

  void setPrompt(String prompt) {
    selectedPrompt.value = prompt;
    print("Selected Prompt: $prompt");
    searchMusicTextController.text = prompt;
    musicGenerateAPiCall(prompt.toLowerCase());
    // Call AI logic here
  }

  final prompts = [
    {'title': 'Happy Mood', 'subtitle': 'Depending on my mood'},
    {'title': 'Party Mood', 'subtitle': 'For my Party'},
    {'title': 'Sad Mood', 'subtitle': 'Sad vibe song'},
  ];

  musicGenerateAPiCall(prompt) async {
    Map<String, dynamic> param = {"prompt": "$prompt songs"};

    ResponseModel<List<MusicModel>> response = await sharedServiceManager
        .createPostRequest<List<MusicModel>>(typeOfEndPoint: ApiType.musicGenerate, params: param);

    if (response.status == ApiConstant.statusCodeSuccess) {
      data.add({searchMusicTextController.text: response.data![0]});
      log(data.toString());
      searchMusicTextController.clear();
      return true;
    } else {
      SnackBarUtil.showSnackBar(
        type: SnackType.error,
        message: response.message ?? "",
        context: Get.context!,
      );
      Logger().e(response.message);
      return false;
    }
  }
}
