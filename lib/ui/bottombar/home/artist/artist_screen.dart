import 'package:ai_music/model/artist_list_model.dart';
import 'package:ai_music/ui/common_component/common_button.dart';
import 'package:ai_music/utils/size_box_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_common/string_const.dart';

class ArtistDetailsPage extends StatefulWidget {
  final ArtistListModel artistListModel;

  const ArtistDetailsPage({super.key, required this.artistListModel});

  @override
  State<ArtistDetailsPage> createState() => _ArtistDetailsPageState();
}

class _ArtistDetailsPageState extends State<ArtistDetailsPage> {
  final Map<String, String> data = {
    "name": "Jennifer Lopez",
    "image": "", // Add an actual image URL or asset path here
    "details":
        "Jennifer Lynn Lopez, also known by her nickname J.Lo, is an American singer, songwriter, actress, dancer and businesswoman. Lopez is regarded as one of the most influential entertainers of her time, credited with breaking barriers for Latino Americans in Hollywood and helping propel the Latin pop movement in music.",
    "born": "24 July 1969",
    "link": "https://www.youtube.com/channel/UCr8RjWUQ_9KYcIPmWiqBroQ",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(data['name']!)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9B57FF), // top-left
              Color(0xFF6D4AFF), // bottom-right
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            40.sizeBoxH,
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          20.sizeBoxH,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: CachedNetworkImage(
                              imageUrl: widget.artistListModel.image ?? '',
                              width: 200.w,
                              height: 300.w,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 40.w,
                                          width: 40.w,
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
                          SizedBox(height: 16),
                          Text(
                            widget.artistListModel.name ?? "",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Born: ${widget.artistListModel.born ?? ""}",
                            style: TextStyle(color: Colors.white60),
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.artistListModel.details ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 50),

                          CommonButton(
                            text: "Visit YouTube Channel",
                            onPressed: () async {
                              final url = Uri.parse(widget.artistListModel.link ?? "");
                              await launchUrl(url);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
