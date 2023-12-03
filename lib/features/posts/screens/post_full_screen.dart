import 'package:dormnow/core/common/error_text.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/constants/constants.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dormnow/features/posts/screens/gallery_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  void toggleFavorites() {
    ref
        .read(userProfileControllerProvider.notifier)
        .addOrRemoveFromFavorites(context, widget.postId);
  }

  Future<void> _showAlertDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Контакти:',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xff16382B),
          //iconColor: Color(0xffFFCE0C),
          content: Text(
            "${text}",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Копіювати',
                style: TextStyle(
                  color: Color(0xffFFCE0C),
                ),
              ),
              onPressed: () {
                print("${text} copied to clipboard");
                Clipboard.setData(ClipboardData(text: text));
              },
            ),
            TextButton(
              child: const Text(
                'Закрити',
                style: TextStyle(
                  color: Color(0xffFFCE0C),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildImage(String ImageUrl, int index) => CachedNetworkImage(
        imageUrl: ImageUrl,
        imageBuilder: (context, ImageProvider) => Container(
          height: 400.h,
          width: 362.w,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Ink.image(
            image: ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Loader(),
      );

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    bool liked = user!.likedMarketAdverts.contains(widget.postId);

    return ref.watch(getPostByIdProvider(widget.postId)).when(
        data: (data) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff16382B),
                title: Text(
                  data.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (data.pictures.isEmpty)
                        ? CachedNetworkImage(
                            imageUrl: Constants.postThumbnailDefault,
                            imageBuilder: (context, imageProvider) => Container(
                              child: Image(image: imageProvider),
                            ),
                            placeholder: (context, url) => Loader(),
                          )
                        : InkWell(
                            child: (data.pictures.length == 1)
                                ? CachedNetworkImage(
                                    imageUrl: data.pictures[0],
                                    imageBuilder: (context, imageProvider) =>
                                        Ink.image(
                                      image: imageProvider,
                                      height: 400.h,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    placeholder: (context, url) => Loader(),
                                  )
                                : CarouselSlider.builder(
                                    itemCount: (data.pictures.isEmpty)
                                        ? 1
                                        : data.pictures.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return buildImage(
                                          data.pictures[index], index);
                                    },
                                    options: CarouselOptions(
                                      height: 400.h,
                                      viewportFraction: 0.99,
                                    ),
                                  ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GalleryWidget(
                                  urlImages: data.pictures,
                                  title: data.title,
                                ),
                              ),
                            ),
                          ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        //bottom: 10,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280.w,
                          // height: 36.h,
                          margin: const EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            (data.authorUsername != "")
                                ? "Додав користувач: ${data.authorUsername}"
                                : "Анонімне оголошення",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white54,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 10, minHeight: 10),
                          alignment: Alignment.topLeft,
                          icon: liked
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border_outlined),
                          color: const Color(0xffFFCE0C),
                          iconSize: 36,
                          onPressed: () {
                            toggleFavorites();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        (data.address != null)
                            ? "Адреса: ${data.address}"
                            : "Адреса відсутня",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: 362,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xff16382B),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      //color: Colors.amber,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              (data.isFree == false)
                                  ? data.price.toString()
                                  : "Безкоштовно",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          Container(
                            width: 130.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xffFFCE0C),
                              ),
                              //color: Color(0xff519872),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            margin: EdgeInsets.only(right: 15),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  //foregroundColor: Colors.black,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  "ЗВ'ЯЗАТИСЯ",
                                  style: TextStyle(
                                    // color: Color(0xffFFCE0C),
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () =>
                                    _showAlertDialog(data.contacts),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    (data.description.isEmpty)
                        ? Container()
                        : Container(
                            width: 342.w,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xff16382B),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 342.w,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xff519872),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "ОПИС",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Text(
                                    (data.description == '')
                                        ? "-"
                                        : data.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                )
                              ],
                            ),
                            //alignment: Alignment.center,
                          ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Дата публікації: ${data.createdAt.hour}:${data.createdAt.minute} ${data.createdAt.day}.${data.createdAt.month}.${data.createdAt.year}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    (user.uid == data.authorUid)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffFFCE0C),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 50.h,
                                width: 150.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => print("edit post"),
                                    child: Text(
                                      "Редагувати",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      //foregroundColor: Colors.black,
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffFFCE0C),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 50.h,
                                width: 150.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => print("delete post"),
                                    child: Text(
                                      "Видалити",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      //foregroundColor: Colors.black,
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 1.h,
                          ),
                  ],
                ),
              ),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
