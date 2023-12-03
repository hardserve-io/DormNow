import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  final List<String> urlImages;

  GalleryWidget({required this.urlImages});

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Gallery'),
          ),
          body: PhotoViewGallery.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.urlImages.length,
              builder: (context, index) {
                final urlImage = widget.urlImages[index];

                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(urlImage),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4,
                );
              }),
        ),
      );
}
