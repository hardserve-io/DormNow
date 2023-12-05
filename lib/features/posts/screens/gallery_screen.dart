import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dormnow/core/common/error_text.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/constants/constants.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryWidget extends StatefulWidget {
  final List<String> urlImages;
  final String title;

  GalleryWidget({required this.urlImages, required this.title});

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text('${widget.title}'),
          ),
          body: PhotoViewGallery.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.urlImages.length,
            builder: (context, index) {
              final urlImage = widget.urlImages[index];

              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(urlImage), //AssertImage
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4,
              );
            },
          ),
        ),
        onWillPop: () async {
          return false;
        },
      );
}
