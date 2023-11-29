import 'package:dormnow/core/common/error_text.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/constants/constants.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  void toggleFavorites() {
    ref.read(userProfileControllerProvider.notifier).addOrRemoveFromFavorites(context, widget.postId);
  }

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
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Image.network((data.pictures.isEmpty) ? Constants.postThumbnailDefault : data.pictures[0]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (data.authorUsername != "")
                            ? "Опубліковано користувачем ${data.authorUsername}"
                            : "Анонімне оголошення",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          width: 108.w,
                          padding: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: const Color(0xffFFCE0C),
                            width: 1,
                          )),
                          //margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Ціна: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          height: 30.h,
                          width: 232.w,
                          padding: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              top: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                            ),
                          ),
                          //margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          child: Text(
                            (data.isFree == false) ? data.price.toString() : "Безкоштовно",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          width: 108.w,
                          padding: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              left: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                            ),
                          ),
                          //margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Контакти: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          height: 30.h,
                          width: 232.w,
                          padding: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                            ),
                          ),
                          //margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          child: Text(
                            data.contacts,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          width: 108.w,
                          padding: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              left: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                            ),
                          ),
                          //margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Адреса: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          height: 30.h,
                          width: 232.w,
                          padding: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Color(0xffFFCE0C),
                                width: 1,
                              ),
                            ),
                          ),
                          //margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          child: Text(
                            (data.address == null) ? "-" : "${data.address}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 342.w,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: const BoxDecoration(
                          border: Border(
                        right: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                      )),
                      child: Column(
                        children: [
                          Container(
                            width: 342.w,
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xffFFCE0C),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              "ОПИС:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              (data.description == '') ? "-" : data.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      //alignment: Alignment.center,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Дата публікації: ${data.createdAt.hour}:${data.createdAt.minute} ${data.createdAt.day}.${data.createdAt.month}.${data.createdAt.year}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          toggleFavorites();
                          setState(() {});
                        },
                        child: liked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border)),
                  ],
                ),
              ),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
