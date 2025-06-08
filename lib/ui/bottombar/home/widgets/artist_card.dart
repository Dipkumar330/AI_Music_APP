import 'package:ai_music/model/artist_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_common/string_const.dart';
import '../artist/artist_screen.dart';

class ArtistCard extends StatelessWidget {
  final ArtistListModel artistListModel;

  const ArtistCard({Key? key, required this.artistListModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(ArtistDetailsPage(artistListModel: artistListModel,)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(color: Colors.white),
                child: CachedNetworkImage(
                  imageUrl: artistListModel.image ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                  errorWidget:
                      (context, url, error) =>
                          Image.network(AppStrings.defaultImage, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            artistListModel.name ?? "",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
