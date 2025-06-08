// controllers/main_controller.dart
import 'package:ai_music/model/artist_list_model.dart';
import 'package:get/get.dart';

import '../../helper/network_manager/api_constant.dart';
import '../../helper/network_manager/remote_services.dart';
import '../../model/music_list_model.dart';
import '../../model/response_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/snackbar_util.dart';

class BottombarController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  RxList<MusicListModel> musicList = <MusicListModel>[].obs;
  RxList<ArtistListModel> artistList = <ArtistListModel>[].obs;

  getMusicAPiCall() async {
    ResponseModel<List<MusicListModel>> response = await sharedServiceManager
        .createGetRequest<List<MusicListModel>>(typeOfEndPoint: ApiType.musics);

    if (response.status == ApiConstant.statusCodeSuccess) {
      musicList.value = response.data ?? [];
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

  getArtistAPiCall() async {
    ResponseModel<List<ArtistListModel>> response = await sharedServiceManager
        .createGetRequest<List<ArtistListModel>>(typeOfEndPoint: ApiType.artist);

    if (response.status == ApiConstant.statusCodeSuccess) {
      artistList.value = response.data ?? [];
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
